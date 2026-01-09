//! NativeTavern Core Library
//! 
//! This library provides native performance for:
//! - PNG character card parsing (V2/V3 spec)
//! - CharX archive extraction
//! - LLM inference via llama.cpp (future)
//! - Tokenization

pub mod png_parser;
pub mod charx_parser;
pub mod models;
pub mod error;

// Re-exports for FFI
pub use png_parser::*;
pub use charx_parser::*;
pub use models::*;
pub use error::*;

/// Initialize the library
pub fn init() {
    env_logger::init();
    log::info!("NativeTavern Core initialized");
}