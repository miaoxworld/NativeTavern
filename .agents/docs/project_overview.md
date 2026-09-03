# NativeTavern Technical Overview

## Introduction

NativeTavern is a native multi-platform client (iOS, Android, macOS) for interacting with large language models (LLMs) in roleplay, creative writing, and companion contexts. It provides full compatibility with the SillyTavern ecosystem (character cards, world info / lorebooks, chat history, regex scripts) while maintaining 60+ FPS native rendering, 2D avatar animations (Live2D Cubism and Spine), and end-to-end local data privacy.

---

## Technology Stack

| Layer | Technology | Pinned Version / Range | Purpose |
|---|---|---|---|
| **Framework** | Flutter | `>=3.44.9` | Cross-platform UI toolkit |
| **Language** | Dart | `>=3.2.0 <4.0.0` | Application logic |
| **State Management** | Riverpod | `^2.6.1` (`flutter_riverpod`, `riverpod_annotation`) | Unidirectional data flow, caching, dependency injection |
| **Persistence** | Drift (SQLite) | `^2.28.2` (`sqlite3_flutter_libs: ^0.5.41`) | Type-safe relational database |
| **Secure Storage** | flutter_secure_storage | `^9.2.4` | Keychain (iOS/macOS) / Keystore (Android) secret storage |
| **Routing** | GoRouter | `^13.2.5` | Declarative URL routing and deep linking |
| **Network & APIs** | Dio | `^5.9.0` | HTTP client with streaming and interceptors |
| **Protocol / Tools** | mcp_dart | `^2.4.0` | Model Context Protocol client for tool use |
| **2D Animation** | Live2D Cubism SDK | Cubism Core 6.0.1 | Native Live2D avatar rendering via OpenGL textures |
| **2D Animation** | Spine Flutter | `4.1.14` (`packages/spine_flutter_4_1_compat`) | 2D skeletal animation runtime |
| **Native Core** | Rust | `edition = "2021"`, `flutter_rust_bridge = "2.0"` | High-performance PNG card & CharX parsing |

---

## Directory Organization

```
NativeTavern/
├── android/                    # Android platform project & Gradle configuration
├── ios/                        # iOS platform project & Xcode configuration
├── macos/                      # macOS platform project & Xcode configuration
├── lib/
│   ├── data/                   # Drift database, models, DAOs, repositories
│   ├── domain/                 # Business logic, services (LLM, prompt, import, cloud)
│   ├── presentation/           # Screens, widgets, Riverpod providers, router, theme
│   └── l10n/                   # ARB localization files and generated localizations
├── packages/
│   ├── native_tavern_live2d_macos/  # macOS Live2D Cubism Native bridge
│   └── spine_flutter_4_1_compat/    # Spine 4.1 Flutter compatibility runtime
├── rust/                       # Rust native core (native_tavern_core)
├── tool/                       # Release, build, API, and automation scripts
├── .agents/                    # Rules, skills, and reference documentation
├── setup.sh                    # Turnkey developer onboarding script
├── build_ios.sh                # Official iOS release build script
├── build_ios_local.sh          # Local iOS development build script
├── build_android.sh            # Official Android release build script
├── build_android_local.sh      # Local Android development build script
├── build_macos.sh              # Official macOS release build script
└── build_macos_local.sh        # Local macOS development build script
```
