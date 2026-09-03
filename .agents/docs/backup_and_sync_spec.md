# NativeTavern Backup & Cloud Sync Specification

## Overview

NativeTavern supports comprehensive data portability and synchronization across devices through dedicated file formats and cloud providers (Apple iCloud and Google Drive).

---

## 1. File Formats

### `.ntb` (NativeTavern Backup)
- **Format**: UTF-8 JSON document containing the complete relational database state.
- **Structure**:
  - `version`: Backup format schema version.
  - `timestamp`: Export timestamp in ISO 8601.
  - `characters`: List of character records and attributes.
  - `personas`: User personas and preferences.
  - `world_infos`: Lorebook entries and filter bindings.
  - `chat_sessions`: Chat session metadata and active configurations.
  - `messages`: Chronological conversation messages and branch alternatives.
  - `settings`: Non-sensitive application configuration flags.

### `.ntx` (NativeTavern Exchange Package)
- **Format**: Standard ZIP archive bundle.
- **Structure**:
  - `backup.ntb`: Core relational state.
  - `media/`: Directory containing all referenced binary assets:
    - `media/avatars/`: Character and user avatar images.
    - `media/backgrounds/`: Custom chat background images.
    - `media/sprites/`: Emotion sprite image collections.
    - `media/audio/`: Voice recordings or custom audio.
- **Purpose**: All-in-one export for backing up or migrating to a new device without missing images.

### `.ntm` (NativeTavern Media Package)
- **Format**: ZIP archive bundle containing only the `media/` directory.
- **Purpose**: Companion to a separately exported `.ntb` file when splitting data and media.

### `.jsonl` (Chat Transcript Export)
- **Format**: Line-delimited JSON.
- **Purpose**: Export individual chat histories for external analysis or SillyTavern web client compatibility.

---

## 2. Cloud Synchronization

### Apple iCloud Drive
- **Container Identifier**: Configured via `NSUbiquitousContainers` in `Info.plist` (default: `iCloud.com.miaomiaoxworld.nativetavern`).
- **Storage Path**:
  - **iOS**: Retrieved via `FileManager.default.url(forUbiquityContainerIdentifier: nil)`.
  - **macOS**: `~/Library/Mobile Documents/iCloud~com~miaomiaoxworld~nativetavern/Documents/`.
- **Sync Behavior**:
  - Background bidirectional delta synchronization handled by iOS/macOS CloudKit/Ubiquitous daemon.
  - Conflict resolution selects the newest modification timestamp with automatic snapshotting.

### Google Drive
- Authenticated via Google Sign-In with Google Drive AppData or drive.file OAuth scopes (`googleapis` package).
- Backups are stored in the app's hidden application data folder or selected user folder.
