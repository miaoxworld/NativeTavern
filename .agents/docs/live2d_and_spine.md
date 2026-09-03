# Live2D & Spine Native Animation Runtimes

## Overview

NativeTavern supports high-framerate 2D skeletal and mesh-based animations for character avatars via Live2D Cubism and Esoteric Software's Spine runtime.

---

## 1. Live2D Cubism Native SDK

### Architecture & Pipeline
- **Cubism Core Runtime**: Pinned to version 6.0.1 (`libLive2DCubismCore.dylib` / `.a` / `.so`).
- **Rendering**:
  - Models load `.model3.json` manifests, physics (`.physics3.json`), pose (`.pose3.json`), and motion files (`.motion3.json`).
  - Vertices and textures render into an offscreen OpenGL framebuffer.
  - Framebuffer contents share memory with Flutter via `FlutterTextureRegistry`, eliminating UI thread overhead and maintaining 60+ FPS.

### Platform Bridges
- **macOS (`packages/native_tavern_live2d_macos/`)**:
  - Native CocoaPods plugin linking `FlutterMacOS`, `AppKit`, `OpenGL`, and `CoreVideo`.
  - C++ wrapper class `Live2DMacOSTexture` manages OpenGL context and texture lifecycle.
  - Setup requirement: `Live2DCubismCore.h` must be copied to `macos/CubismCore/include/` before macOS compilation.
- **iOS (`ios/Runner/`)**:
  - Uses `Live2DView` and native OpenGL ES rendering integrated into Flutter Platform Views.

---

## 2. Spine Flutter Runtime (`packages/spine_flutter_4_1_compat/`)

- **Version**: 4.1.14
- **Compatibility**:
  - Spine binary skeletons (`.skel`) require a strict major/minor runtime version match.
  - `spine_flutter_4_1_compat` provides an in-tree compatibility layer bridging Spine 4.1 assets to modern Flutter engine APIs.
- **Assets**:
  - `.skel` (binary) or `.json` (text) skeleton definition.
  - `.atlas` texture atlas and accompanying PNG spritesheet.
