//! Data models for NativeTavern Core
//! 
//! These models match the SillyTavern character card V2/V3 specification

use serde::{Deserialize, Serialize};

/// Character Card V3 specification wrapper
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CharacterCardSpec {
    pub spec: String,
    pub spec_version: String,
    pub data: CharacterCardData,
}

/// Character card data (V2/V3 compatible)
#[derive(Debug, Clone, Serialize, Deserialize, Default)]
pub struct CharacterCardData {
    pub name: String,
    
    #[serde(default)]
    pub description: String,
    
    #[serde(default)]
    pub personality: String,
    
    #[serde(default)]
    pub scenario: String,
    
    #[serde(default, rename = "first_mes")]
    pub first_message: String,
    
    #[serde(default, rename = "mes_example")]
    pub example_dialogue: String,
    
    #[serde(default, rename = "system_prompt")]
    pub system_prompt: String,
    
    #[serde(default, rename = "post_history_instructions")]
    pub post_history_instructions: String,
    
    #[serde(default, rename = "creator_notes")]
    pub creator_notes: String,
    
    #[serde(default)]
    pub tags: Vec<String>,
    
    #[serde(default)]
    pub creator: String,
    
    #[serde(default, rename = "character_version")]
    pub character_version: String,
    
    #[serde(default, rename = "alternate_greetings")]
    pub alternate_greetings: Vec<String>,
    
    #[serde(default)]
    pub extensions: serde_json::Value,
    
    // V3 specific fields
    #[serde(default)]
    pub assets: Option<Vec<CharacterAsset>>,
    
    #[serde(default)]
    pub character_book: Option<CharacterBook>,
}

/// Character asset (V3 spec)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CharacterAsset {
    #[serde(rename = "type")]
    pub asset_type: String,
    pub uri: String,
    pub name: String,
    #[serde(default)]
    pub ext: String,
}

/// Character book / embedded lorebook (V3 spec)
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CharacterBook {
    #[serde(default)]
    pub name: String,
    #[serde(default)]
    pub description: String,
    #[serde(default)]
    pub entries: Vec<CharacterBookEntry>,
}

/// Character book entry
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CharacterBookEntry {
    pub keys: Vec<String>,
    pub content: String,
    
    #[serde(default)]
    pub secondary_keys: Vec<String>,
    
    #[serde(default)]
    pub enabled: bool,
    
    #[serde(default)]
    pub insertion_order: i32,
    
    #[serde(default)]
    pub case_sensitive: bool,
    
    #[serde(default)]
    pub constant: bool,
    
    #[serde(default)]
    pub selective: bool,
    
    #[serde(default)]
    pub position: i32,
    
    #[serde(default)]
    pub extensions: serde_json::Value,
}

/// Result of parsing a character card
#[derive(Debug, Clone)]
pub struct ParsedCharacterCard {
    /// The spec version (chara_card_v2, chara_card_v3)
    pub spec: String,
    /// The parsed card data
    pub data: CharacterCardData,
    /// Raw JSON string for preservation
    pub raw_json: String,
}

/// Result of parsing a CharX archive
#[derive(Debug, Clone)]
pub struct ParsedCharX {
    /// Parsed card data
    pub card: CharacterCardData,
    /// Avatar image data (if found)
    pub avatar: Option<Vec<u8>>,
    /// Asset mappings (path -> data)
    pub assets: Vec<ExtractedAsset>,
}

/// Extracted asset from CharX
#[derive(Debug, Clone)]
pub struct ExtractedAsset {
    /// Asset type (sprite, background, etc.)
    pub asset_type: String,
    /// Asset name
    pub name: String,
    /// File extension
    pub ext: String,
    /// Raw data
    pub data: Vec<u8>,
}

impl CharacterCardSpec {
    /// Create a new V3 spec from card data
    pub fn new_v3(data: CharacterCardData) -> Self {
        Self {
            spec: "chara_card_v3".to_string(),
            spec_version: "3.0".to_string(),
            data,
        }
    }
    
    /// Create a new V2 spec from card data
    pub fn new_v2(data: CharacterCardData) -> Self {
        Self {
            spec: "chara_card_v2".to_string(),
            spec_version: "2.0".to_string(),
            data,
        }
    }
}

impl Default for CharacterBookEntry {
    fn default() -> Self {
        Self {
            keys: Vec::new(),
            content: String::new(),
            secondary_keys: Vec::new(),
            enabled: true,
            insertion_order: 0,
            case_sensitive: false,
            constant: false,
            selective: false,
            position: 1,
            extensions: serde_json::Value::Null,
        }
    }
}