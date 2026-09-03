---
name: nativetavern-architecture
description: >-
  Navigates and explains NativeTavern's layered codebase architecture, Riverpod providers,
  Drift SQLite persistence, domain services, AI provider adapters, and routing structure.
---

# NativeTavern Architecture Guide

## Overview

NativeTavern is a cross-platform (iOS, Android, macOS) AI roleplaying client compatible with SillyTavern character cards, lorebooks, and chat formats.

## Key Subsystems

### 1. Data Layer (`lib/data/`)
- **Database (`lib/data/database/`)**: Drift SQLite database definition (`app_database.dart`). Contains tables for characters, chat sessions, messages, lorebooks, personas, and settings.
- **Models (`lib/data/models/`)**: Freezed/json_serializable data models (`character.dart`, `chat_message.dart`, `world_info.dart`, `live2d.dart`, `sprite.dart`).
- **Repositories (`lib/data/repositories/`)**: Abstract data operations (`character_repository.dart`, `chat_repository.dart`, `setting_repository.dart`).

### 2. Domain Layer (`lib/domain/`)
- **Services (`lib/domain/services/`)**:
  - `llm_service.dart`: LLM dispatch, token counting, streaming text responses.
  - `prompt_service.dart`: Assembles system prompts, character definitions, persona info, world info, and chat history into prompt context.
  - `import_service.dart`: Imports PNG character cards (V2/V3), JSON files, CharX archives, and `.ntb` backups.
  - `cloud_backup_service.dart`: Handles iCloud Drive and Google Drive backup synchronization.
  - `live2d_service.dart`: Discovers and manifests Live2D model files and motion groups.
  - `mcp_service.dart`: Model Context Protocol client orchestration for tool-calling extensions.
- **AI Providers (`lib/domain/providers/`)**:
  - Direct adapters for xAI (Grok), OpenAI, Anthropic Claude, OpenRouter, Google Gemini, Ollama, LM Studio, etc.

### 3. Presentation Layer (`lib/presentation/`)
- **Router (`lib/presentation/router/app_router.dart`)**: GoRouter declarative route hierarchy.
- **Providers (`lib/presentation/providers/`)**: Riverpod state management.
- **Screens (`lib/presentation/screens/`)**:
  - `chat/`: Core conversation UI, message bubbles, swipe actions, branching alternatives.
  - `character/`: Character gallery, details, tags, sorting.
  - `character_editor/`: Character metadata, prompt fields, alternate greetings, sprite bindings.
  - `settings/`: AI configuration, theme, backups, Live2D, audio/TTS.
- **Widgets (`lib/presentation/widgets/`)**:
  - `live2d/`: Native texture views and stage gestures.
  - `chat/`: Markdown rendering, LaTeX math formatting, streaming response indicators.
