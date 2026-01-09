//! PNG Character Card Parser
//! 
//! Parses PNG files with embedded character card metadata in tEXt chunks.
//! Supports both V2 (chara) and V3 (ccv3) specifications.

use std::io::{Read, Write, Cursor};
use png::{Decoder, Encoder, ColorType, BitDepth};
use base64::{Engine as _, engine::general_purpose::STANDARD as BASE64};
use crate::error::{CoreError, Result};
use crate::models::{CharacterCardData, CharacterCardSpec, ParsedCharacterCard};

/// tEXt chunk keywords
const CHARA_KEYWORD: &str = "chara";
const CCV3_KEYWORD: &str = "ccv3";

/// Parse character card data from PNG bytes
pub fn parse_png_card(data: &[u8]) -> Result<ParsedCharacterCard> {
    let decoder = Decoder::new(Cursor::new(data));
    let reader = decoder.read_info()?;
    let info = reader.info();
    
    // Look for tEXt chunks with character data
    let mut ccv3_data: Option<String> = None;
    let mut chara_data: Option<String> = None;
    
    for chunk in &info.uncompressed_latin1_text {
        let keyword = chunk.keyword.to_lowercase();
        if keyword == CCV3_KEYWORD {
            ccv3_data = Some(chunk.text.clone());
        } else if keyword == CHARA_KEYWORD {
            chara_data = Some(chunk.text.clone());
        }
    }
    
    // Prefer V3 over V2
    let (raw_base64, spec) = if let Some(data) = ccv3_data {
        (data, "chara_card_v3")
    } else if let Some(data) = chara_data {
        (data, "chara_card_v2")
    } else {
        return Err(CoreError::NoMetadata);
    };
    
    // Decode base64
    let decoded_bytes = BASE64.decode(&raw_base64)?;
    let json_str = String::from_utf8(decoded_bytes)
        .map_err(|e| CoreError::InvalidCharacterCard(e.to_string()))?;
    
    // Parse JSON
    let card_data: CharacterCardData = if spec == "chara_card_v3" {
        // V3 wraps data in a spec envelope
        let spec_wrapper: CharacterCardSpec = serde_json::from_str(&json_str)?;
        spec_wrapper.data
    } else {
        // V2 is just the data directly
        serde_json::from_str(&json_str)?
    };
    
    Ok(ParsedCharacterCard {
        spec: spec.to_string(),
        data: card_data,
        raw_json: json_str,
    })
}

/// Write character card data to PNG bytes
pub fn write_png_card(image_data: &[u8], card_data: &CharacterCardData) -> Result<Vec<u8>> {
    // First, decode the original PNG
    let decoder = Decoder::new(Cursor::new(image_data));
    let mut reader = decoder.read_info()?;
    let mut buf = vec![0; reader.output_buffer_size()];
    let info = reader.next_frame(&mut buf)?;
    let bytes = &buf[..info.buffer_size()];
    
    let original_info = reader.info().clone();
    
    // Create output buffer
    let mut output = Vec::new();
    
    // Create encoder
    {
        let mut encoder = Encoder::new(&mut output, original_info.width, original_info.height);
        encoder.set_color(original_info.color_type);
        encoder.set_depth(original_info.bit_depth);
        
        // Create V2 and V3 JSON
        let v2_json = serde_json::to_string(&card_data)?;
        let v2_base64 = BASE64.encode(v2_json.as_bytes());
        
        let v3_spec = CharacterCardSpec::new_v3(card_data.clone());
        let v3_json = serde_json::to_string(&v3_spec)?;
        let v3_base64 = BASE64.encode(v3_json.as_bytes());
        
        // Add tEXt chunks
        encoder.add_text_chunk(CHARA_KEYWORD.to_string(), v2_base64)?;
        encoder.add_text_chunk(CCV3_KEYWORD.to_string(), v3_base64)?;
        
        let mut writer = encoder.write_header()?;
        writer.write_image_data(bytes)?;
    }
    
    Ok(output)
}

/// Extract just the character name from PNG (fast path)
pub fn extract_character_name(data: &[u8]) -> Result<String> {
    let card = parse_png_card(data)?;
    Ok(card.data.name)
}

/// Check if a PNG contains character card data
pub fn has_character_data(data: &[u8]) -> bool {
    let decoder = match Decoder::new(Cursor::new(data)).read_info() {
        Ok(reader) => reader,
        Err(_) => return false,
    };
    
    let info = decoder.info();
    
    for chunk in &info.uncompressed_latin1_text {
        let keyword = chunk.keyword.to_lowercase();
        if keyword == CCV3_KEYWORD || keyword == CHARA_KEYWORD {
            return true;
        }
    }
    
    false
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_has_character_data_invalid() {
        let data = b"not a png";
        assert!(!has_character_data(data));
    }
}