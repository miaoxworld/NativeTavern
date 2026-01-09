//! Error types for NativeTavern Core

use thiserror::Error;

/// Core library errors
#[derive(Error, Debug)]
pub enum CoreError {
    #[error("Failed to read file: {0}")]
    FileRead(String),
    
    #[error("Failed to write file: {0}")]
    FileWrite(String),
    
    #[error("Invalid PNG format: {0}")]
    InvalidPng(String),
    
    #[error("PNG metadata not found")]
    NoMetadata,
    
    #[error("Invalid character card format: {0}")]
    InvalidCharacterCard(String),
    
    #[error("Invalid CharX archive: {0}")]
    InvalidCharX(String),
    
    #[error("JSON parse error: {0}")]
    JsonParse(#[from] serde_json::Error),
    
    #[error("Base64 decode error: {0}")]
    Base64Decode(#[from] base64::DecodeError),
    
    #[error("ZIP error: {0}")]
    Zip(#[from] zip::result::ZipError),
    
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    
    #[error("PNG decode error: {0}")]
    PngDecode(#[from] png::DecodingError),
    
    #[error("PNG encode error: {0}")]
    PngEncode(#[from] png::EncodingError),
}

/// Result type alias
pub type Result<T> = std::result::Result<T, CoreError>;