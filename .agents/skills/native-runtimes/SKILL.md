---
name: native-runtimes
description: >-
  Explains the native FFI runtimes in NativeTavern: Live2D Cubism Native SDK bridge,
  Spine Flutter 4.1 FFI runtime, and the Rust native_tavern_core library.
---

# Native Runtimes & FFI in NativeTavern

## 1. Live2D Cubism Native SDK Bridge

NativeTavern renders interactive Live2D models natively on iOS, Android, and macOS:

### macOS Bridge (`packages/native_tavern_live2d_macos/`)
- Integrates the official Live2D Cubism Native Framework and Cubism Core 6.0.1.
- Renders via OpenGL directly into Flutter macOS external textures (`FlutterTextureRegistry`).
- Proprietary Cubism Core header (`Live2DCubismCore.h`) is placed under `macos/CubismCore/include/`.
- Redistributable dynamic library `libLive2DCubismCore.dylib` resides in `macos/Libs/`.

### iOS Implementation (`ios/Runner/`)
- Uses `Live2DView` and native OpenGL ES rendering integrated into Flutter Platform Views.

---

## 2. Spine Flutter 4.1 Runtime (`packages/spine_flutter_4_1_compat/`)

- Pins official Spine Runtime 4.1.14.
- Provides binary skeleton and atlas parsing with custom shims for current Flutter engine compatibility.
- Bundles C/C++ native assets across Android (`.so`), iOS (`.a`/framework), macOS (`.dylib`), Windows, and Linux.

---

## 3. Rust Native Core (`rust/native_tavern_core/`)

- Crate structure:
  - `src/png_parser.rs`: High-performance streaming extraction of `tEXt` chunks from PNG cards.
  - `src/charx_parser.rs`: Unpacking and validation of CharX compressed character packages.
  - `src/models.rs`: Strongly typed Rust models matching SillyTavern schemas.
- Bridge generation via **flutter_rust_bridge 2.0**:
  - Run codegen: `flutter_rust_bridge_codegen generate`
  - Targets compiled as `cdylib` and `staticlib`.
