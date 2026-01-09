//! CharX Archive Parser
//! 
//! Parses CharX (.charx) archives which are ZIP files containing:
//! - card.json: Character card data
//! - Assets (sprites, backgrounds, avatars)

use std::io::{Read, Cursor};
use zip::ZipArchive;
use crate::error::{CoreError, Result};
use crate::models::{CharacterCardData, CharacterCardSpec, CharacterAsset, ParsedCharX, ExtractedAsset};

/// Common embedded URI prefixes used in CharX files
const EMBEDDED_PREFIXES: &[&str] = &["embeded://", "embedded://", "__asset:"];

/// Image extensions we support
const IMAGE_EXTENSIONS: &[&str] = &["png", "jpg", "jpeg", "webp", "gif", "apng", "avif", "bmp", "jfif"];

/// Parse a CharX archive from bytes
pub fn parse_charx(data: &[u8]) -> Result<ParsedCharX> {
    // Find ZIP start (handle SFX archives)
    let zip_data = find_zip_start(data);
    
    let cursor = Cursor::new(zip_data);
    let mut archive = ZipArchive::new(cursor)?;
    
    // Extract and parse card.json
    let card_data = extract_card_json(&mut archive)?;
    
    // Collect assets to extract
    let assets_to_extract = collect_assets(&card_data);
    
    // Find avatar
    let avatar = extract_avatar(&mut archive, &card_data)?;
    
    // Extract other assets
    let assets = extract_assets(&mut archive, &assets_to_extract)?;
    
    Ok(ParsedCharX {
        card: card_data,
        avatar,
        assets,
    })
}

/// Find ZIP signature in data (handles SFX archives)
fn find_zip_start(data: &[u8]) -> &[u8] {
    const ZIP_SIGNATURE: &[u8] = &[0x50, 0x4B, 0x03, 0x04];
    
    if let Some(pos) = data.windows(4).position(|w| w == ZIP_SIGNATURE) {
        if pos > 0 {
            return &data[pos..];
        }
    }
    data
}

/// Extract and parse card.json from archive
fn extract_card_json(archive: &mut ZipArchive<Cursor<&[u8]>>) -> Result<CharacterCardData> {
    let mut card_file = archive.by_name("card.json")
        .map_err(|_| CoreError::InvalidCharX("card.json not found".to_string()))?;
    
    let mut contents = String::new();
    card_file.read_to_string(&mut contents)?;
    
    // Try parsing as V3 spec first
    if let Ok(spec) = serde_json::from_str::<CharacterCardSpec>(&contents) {
        return Ok(spec.data);
    }
    
    // Fall back to direct parsing
    let card: CharacterCardData = serde_json::from_str(&contents)?;
    Ok(card)
}

/// Collect asset paths to extract from card data
fn collect_assets(card: &CharacterCardData) -> Vec<(String, String, String)> {
    let mut assets = Vec::new();
    
    if let Some(ref card_assets) = card.assets {
        for asset in card_assets {
            if let Some(path) = get_embedded_path(&asset.uri) {
                let ext = normalize_extension(&asset.ext, &path);
                if is_image_extension(&ext) {
                    assets.push((asset.asset_type.clone(), asset.name.clone(), path));
                }
            }
        }
    }
    
    assets
}

/// Get embedded path from URI
fn get_embedded_path(uri: &str) -> Option<String> {
    let trimmed = uri.trim();
    let lower = trimmed.to_lowercase();
    
    for prefix in EMBEDDED_PREFIXES {
        if lower.starts_with(prefix) {
            let path = &trimmed[prefix.len()..];
            return Some(normalize_path(path));
        }
    }
    
    None
}

/// Normalize path (handle backslashes, etc.)
fn normalize_path(path: &str) -> String {
    path.replace('\\', "/")
        .trim_start_matches('/')
        .to_string()
}

/// Normalize file extension
fn normalize_extension(ext: &str, path: &str) -> String {
    let meta_ext = ext.trim().to_lowercase().trim_start_matches('.').to_string();
    if !meta_ext.is_empty() {
        return meta_ext;
    }
    
    // Extract from path
    if let Some(pos) = path.rfind('.') {
        return path[pos + 1..].to_lowercase();
    }
    
    String::new()
}

/// Check if extension is a supported image format
fn is_image_extension(ext: &str) -> bool {
    IMAGE_EXTENSIONS.contains(&ext.to_lowercase().as_str())
}

/// Extract avatar from archive
fn extract_avatar(archive: &mut ZipArchive<Cursor<&[u8]>>, card: &CharacterCardData) -> Result<Option<Vec<u8>>> {
    if let Some(ref assets) = card.assets {
        // Find icon asset
        let icon_assets: Vec<_> = assets.iter()
            .filter(|a| a.asset_type.to_lowercase() == "icon")
            .filter(|a| {
                let ext = normalize_extension(&a.ext, &a.uri);
                is_image_extension(&ext)
            })
            .collect();
        
        // Prefer "main" icon
        let icon = icon_assets.iter()
            .find(|a| a.name.to_lowercase() == "main")
            .or(icon_assets.first());
        
        if let Some(icon_asset) = icon {
            if let Some(path) = get_embedded_path(&icon_asset.uri) {
                if let Ok(data) = extract_file(archive, &path) {
                    return Ok(Some(data));
                }
            }
        }
    }
    
    // Try common avatar paths
    for path in &["avatar.png", "avatar.jpg", "icon.png", "icon.jpg"] {
        if let Ok(data) = extract_file(archive, path) {
            return Ok(Some(data));
        }
    }
    
    Ok(None)
}

/// Extract assets from archive
fn extract_assets(
    archive: &mut ZipArchive<Cursor<&[u8]>>, 
    assets: &[(String, String, String)]
) -> Result<Vec<ExtractedAsset>> {
    let mut extracted = Vec::new();
    
    for (asset_type, name, path) in assets {
        // Skip icons (handled separately as avatar)
        if asset_type.to_lowercase() == "icon" {
            continue;
        }
        
        if let Ok(data) = extract_file(archive, path) {
            let ext = path.rfind('.')
                .map(|i| path[i + 1..].to_string())
                .unwrap_or_default();
            
            extracted.push(ExtractedAsset {
                asset_type: asset_type.clone(),
                name: name.clone(),
                ext,
                data,
            });
        }
    }
    
    Ok(extracted)
}

/// Extract a single file from archive
fn extract_file(archive: &mut ZipArchive<Cursor<&[u8]>>, path: &str) -> Result<Vec<u8>> {
    // Try exact path first
    if let Ok(mut file) = archive.by_name(path) {
        let mut data = Vec::new();
        file.read_to_end(&mut data)?;
        return Ok(data);
    }
    
    // Try case-insensitive search
    let lower_path = path.to_lowercase();
    for i in 0..archive.len() {
        if let Ok(file) = archive.by_index(i) {
            if file.name().to_lowercase() == lower_path {
                let mut file = archive.by_index(i)?;
                let mut data = Vec::new();
                file.read_to_end(&mut data)?;
                return Ok(data);
            }
        }
    }
    
    Err(CoreError::InvalidCharX(format!("File not found: {}", path)))
}

/// Create a CharX archive from character data and assets
pub fn create_charx(
    card: &CharacterCardData,
    avatar: Option<&[u8]>,
    assets: &[(&str, &str, &str, &[u8])], // (type, name, ext, data)
) -> Result<Vec<u8>> {
    use std::io::Write;
    use zip::write::SimpleFileOptions;
    
    let mut buffer = Vec::new();
    let cursor = Cursor::new(&mut buffer);
    let mut zip = zip::ZipWriter::new(cursor);
    
    let options = SimpleFileOptions::default()
        .compression_method(zip::CompressionMethod::Deflated);
    
    // Write card.json
    let spec = CharacterCardSpec::new_v3(card.clone());
    let card_json = serde_json::to_string_pretty(&spec)?;
    zip.start_file("card.json", options)?;
    zip.write_all(card_json.as_bytes())?;
    
    // Write avatar
    if let Some(avatar_data) = avatar {
        zip.start_file("assets/avatar.png", options)?;
        zip.write_all(avatar_data)?;
    }
    
    // Write other assets
    for (asset_type, name, ext, data) in assets {
        let path = format!("assets/{}/{}.{}", asset_type, name, ext);
        zip.start_file(&path, options)?;
        zip.write_all(data)?;
    }
    
    zip.finish()?;
    drop(zip);
    
    Ok(buffer)
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_get_embedded_path() {
        assert_eq!(
            get_embedded_path("embedded://assets/avatar.png"),
            Some("assets/avatar.png".to_string())
        );
        assert_eq!(
            get_embedded_path("embeded://assets/avatar.png"),
            Some("assets/avatar.png".to_string())
        );
        assert_eq!(
            get_embedded_path("https://example.com/image.png"),
            None
        );
    }
    
    #[test]
    fn test_normalize_extension() {
        assert_eq!(normalize_extension("png", ""), "png");
        assert_eq!(normalize_extension(".PNG", ""), "png");
        assert_eq!(normalize_extension("", "file.jpg"), "jpg");
    }
    
    #[test]
    fn test_is_image_extension() {
        assert!(is_image_extension("png"));
        assert!(is_image_extension("PNG"));
        assert!(is_image_extension("jpg"));
        assert!(!is_image_extension("txt"));
        assert!(!is_image_extension(""));
    }
}