# NativeTavern Backup & Cloud Sync Specification

## Overview

NativeTavern supports comprehensive data portability and synchronization across devices through dedicated file formats and cloud providers (Apple iCloud and Google Drive).

---

## 1. File Formats

### `.ntb` (NativeTavern Backup, legacy)
- **Status**: No longer imported or exported by the app. Convert to `.ntx` with the in-app converter (`LegacyNtxConverter`).
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
- **Optional password**: Local save/share can wrap the `.ntx` zip in AES-256-GCM (`payload.bin`) with a PBKDF2-HMAC-SHA256 key. The password is never stored. Forgetting it makes that file unimportable. Automatic iCloud and Google Drive sync is not password-gated.

### `.ntm` (NativeTavern Media Package, legacy)
- **Status**: No longer imported or exported on its own. Merge with a `.ntb` into `.ntx` using the converter.
- **Format**: ZIP archive bundle containing only the `media/` directory.
- **Purpose**: Historical companion to a separately exported `.ntb` file.

### `.jsonl` (Chat Transcript Export)
- **Format**: Line-delimited JSON.
- **Purpose**: Export individual chat histories for external analysis or SillyTavern web client compatibility.

---

## 2. Cloud Synchronization

### Apple iCloud (private Cloud Documents, not the Files app)
- **Container Identifier**: Configured via `NSUbiquitousContainers` in `Info.plist` (default: `iCloud.com.miaomiaoxworld.nativetavern`).
- **Visibility**: `NSUbiquitousContainerIsDocumentScopePublic` is `false`. Automatic sync lives in the container `Library/Application Support/NativeTavern/sync/` folder so it is not shown in the iOS Files app.
- **Storage Path**:
  - **iOS / macOS**: Retrieved via `FileManager.default.url(forUbiquityContainerIdentifier:)` then `Library/Application Support/NativeTavern/sync`.
- **Payload**: Combined `.ntx` snapshot (`NativeTavern_sync.ntx`) including chats, messages, lorebooks, moments, story chapters, media, app/connection settings (when settings sync is on), and an encrypted `ntxVault` of API keys.
- **Settings sync**: Optional. On by default. Theme, language, AI connection settings, TTS/STT, prompts, regex, presets, and other SharedPreferences / `globalStates` / `llmConfigs` travel with the snapshot. A device can turn this off to keep per-device settings; that device still syncs chats and will not overwrite the other device's settings in iCloud.
- **API keys**: AES-256-GCM vault. The wrapping key is stored in iCloud Keychain (`synchronizable`) and also as `NativeTavern_sync.vault.json` in the private container so a second Apple device can decrypt keys if Keychain has not caught up yet. The vault includes `llm_config` / `llm_provider_config_*` connection snapshots (the keys the settings UI actually uses) as well as `llmConfigs` table keys. Plaintext keys never appear in JSON backups.
- **First launch**: If iCloud already has `NativeTavern_sync.ntx` and this install has never synced, the app asks whether to import that snapshot or start from scratch. Starting from scratch does not overwrite the other device.
- **Sync Behavior**:
  - The app pulls then merges on cold start and when returning from the background, then pushes the merged snapshot. A device that has never synced will not push until it has either imported the remote file or confirmed that none exists, so a second device cannot overwrite the first.
  - Chat titles merge independently of `updatedAt` (message sends bump `updatedAt` without renaming). Custom names win over default "Chat with …" / "New Chat" titles.
  - Native iOS/macOS code uses `NSMetadataQueryUbiquitousDataScope` to find `NativeTavern_sync.ntx` before it is materialized locally, then waits until `NSURLUbiquitousItemDownloadingStatusCurrent`.
  - While the app is open, the user can choose On open/resume, every 15 minutes, every 30 minutes, or hourly. iOS may also run `BGAppRefresh` to prefetch ubiquity files; that is opportunistic and does not need extra privacy permissions.
  - Concurrent edits open a conflict dialog: keep this device, keep the other device, merge (newer wins), or choose collections. A local `.ntx` snapshot is written before applying the other device.

### Google Drive
- Authenticated via Google Sign-In with `drive.appdata` (automatic sync) and `drive.file` (manual backups) OAuth scopes (`googleapis` package).
- **Automatic sync**: Hidden Google Drive App Data files (`NativeTavern_sync.ntx`, metadata, and vault wrap key). Same Google account on a second Android device sees the same App Data. Not shown in the user's Drive folders.
- **Manual backups**: Visible `NativeTavern Backups` folder created with `drive.file`.
- **Payload**: Combined `.ntx` snapshot including chats, characters, lorebooks, moments, story chapters, media, and an encrypted `ntxVault` of API keys.
- **API keys**: AES-256-GCM vault. The wrapping key is stored in this app's private Drive App Data so a second Android device signed into the same Google account can decrypt keys. Plaintext keys never appear in JSON backups.
- **Sync Behavior**:
  - Pull on launch/resume and push when the app is backgrounded, matching iCloud.
  - Concurrent edits open the same conflict dialog as iCloud: keep this device, keep the other device, merge (newer wins), or choose collections. A local `.ntx` snapshot is written first.
