---
name: sillytavern-formats
description: >-
  Guides parsing, generating, and validating SillyTavern Character Cards (Spec V2 and V3),
  NativeTavern backup formats (.ntb, .ntx, .ntm), Chat JSONL exports, lorebooks, and regex scripts.
---

# SillyTavern & NativeTavern Data Formats

## 1. Character Card Spec V2 & V3

NativeTavern fully supports both **Character Card Spec V2** and **Character Card Spec V3**.

### Embedding in PNG
- Character cards are commonly distributed as PNG images with embedded metadata in a `tEXt` chunk with keyword `chara`.
- The text chunk contains base64-encoded UTF-8 JSON.
- NativeTavern decodes the `chara` chunk or parses raw `.json` files.

### Spec V2 Structure
```json
{
  "spec": "chara_card_v2",
  "spec_version": "2.0",
  "data": {
    "name": "Character Name",
    "description": "Short bio or visual description",
    "personality": "Personality traits",
    "scenario": "Current environment or starting situation",
    "first_mes": "Initial greeting message",
    "mes_example": "<START>\n{{user}}: Hi\n{{char}}: Hello!",
    "creator_notes": "Author comments",
    "system_prompt": "Optional system prompt override",
    "post_history_instructions": "Appended instructions",
    "alternate_greetings": ["Alternative greeting 1", "Alternative greeting 2"],
    "character_book": null,
    "tags": ["anime", "fantasy"],
    "creator": "Author Name",
    "character_version": "1.0"
  }
}
```

### Spec V3 Additions
- `spec`: `"chara_card_v3"`, `spec_version`: `"3.0"`
- `data.assets`: List of assets (sprites, expressions, audio files, Live2D bundles).
- `data.group_only_greetings`: Greetings exclusive to group chats.
- `data.nickname`: In-chat short name or handle.

---

## 2. NativeTavern Backup Formats

- **`.ntb` (NativeTavern Backup)**:
  - JSON-serialized export of SQLite tables: characters, personas, lorebooks, chat sessions, and message history.
  - Used for complete data backup and restore.
- **`.ntx` (NativeTavern Exchange Package)**:
  - Compressed zip archive bundle containing `.ntb` database payload plus associated media assets (character avatars, user avatars, chat backgrounds, audio).
- **`.ntm` (NativeTavern Media Package)**:
  - Companion media bundle matching a `.ntb` file when media is exported separately.
- **`.jsonl` (Chat Transcript Export)**:
  - Line-delimited JSON messages exportable from chat sessions, compatible with SillyTavern chat exports.

---

## 3. World Info / Lorebooks
- Stored as dictionaries of entries triggered by primary and secondary keywords.
- Supports recursive scanning, selective insertion (top of prompt, before character, depth-based), and character-specific filtering.
