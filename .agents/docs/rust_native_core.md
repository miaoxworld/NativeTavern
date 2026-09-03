# NativeTavern Rust Native Core (`native_tavern_core`)

## Overview

The `rust/` directory contains `native_tavern_core`, a high-performance native library compiled as a C dynamic library (`cdylib`) and static library (`staticlib`). It provides optimized parsing for large character cards, CharX archives, and image transformations, bridged to Dart via **flutter_rust_bridge 2.0**.

---

## 1. Crate Architecture

```
rust/
├── Cargo.toml
└── src/
    ├── lib.rs              # Crate entry point and FFI initialization
    ├── png_parser.rs       # Direct zero-copy extraction of tEXt chunks
    ├── charx_parser.rs     # Zip archive extraction and manifest parsing
    ├── models.rs           # Strongly typed Serde models
    └── error.rs            # Custom error enumeration with anyhow/thiserror
```

---

## 2. Dependencies & Toolchain

- **Rust Edition**: 2021
- **Key Crates**:
  - `flutter_rust_bridge = "2.0"`: Safe cross-language FFI bindings.
  - `png = "0.17"`: Streaming PNG chunk decoder.
  - `serde`, `serde_json = "1.0"`: Fast JSON deserialization.
  - `zip = "0.6"`: In-memory and streaming archive extractor.
  - `tokio = "1.0"`: Multi-threaded async runtime.

---

## 3. Code Generation & Building

### Generating FFI Bindings:
```sh
cargo install flutter_rust_bridge_codegen
flutter_rust_bridge_codegen generate
```

### Compiling Targets:
- **macOS / Host**:
  ```sh
  cd rust && cargo build --release
  ```
- **Android**:
  Using `cargo-ndk`:
  ```sh
  cargo ndk -t arm64-v8a -t armeabi-v7a -o ../android/app/src/main/jniLibs build --release
  ```
- **iOS**:
  Using `cargo-lipo` or `cargo build --target aarch64-apple-ios`.
