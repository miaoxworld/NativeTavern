# SillyTavern Character Card Specification

## Overview

SillyTavern character cards are standardized data structures containing prompt engineering metadata, character attributes, lorebooks, and example dialogues for conversational AI roleplay.

---

## 1. PNG Image Embedding Specification

Character cards are widely distributed as PNG files that serve both as an image avatar and as a data carrier.

### The `tEXt` Chunk
- In the PNG file chunk structure, metadata is stored in an uncompressed `tEXt` chunk.
- **Chunk Keyword**: `chara`
- **Text Content**: Base64-encoded UTF-8 string containing the card's JSON payload.
- In Dart, this is decoded via:
  ```dart
  final bytes = base64Decode(charaTextChunkString);
  final jsonString = utf8.decode(bytes);
  final cardJson = jsonDecode(jsonString);
  ```

---

## 2. Character Card Spec V2

```json
{
  "spec": "chara_card_v2",
  "spec_version": "2.0",
  "data": {
    "name": "Eldoria",
    "description": "Guardian of the Whispering Glade...",
    "personality": "Gentle, protective, inquisitive",
    "scenario": "You awaken beneath an ancient luminescent tree...",
    "first_mes": "*Soft bioluminescent petals drift down...* Welcome, traveler.",
    "mes_example": "<START>\n{{user}}: Who are you?\n{{char}}: I am Eldoria, keeper of these woods.",
    "creator_notes": "Created by ModdersDen",
    "system_prompt": "You are roleplaying as Eldoria...",
    "post_history_instructions": "Maintain vivid sensory descriptions.",
    "alternate_greetings": [
      "*Rain patters across the canopy...*",
      "*The forest is unusually quiet today...*"
    ],
    "character_book": {
      "name": "Glade Lore",
      "entries": [
        {
          "keys": ["glade", "tree"],
          "content": "The Whispering Glade is protected by ancient magic.",
          "enabled": true,
          "insertion_order": 100
        }
      ]
    },
    "tags": ["fantasy", "companion", "magic"],
    "creator": "ModdersDen",
    "character_version": "1.0.0",
    "extensions": {}
  }
}
```

---

## 3. Character Card Spec V3 (CharX)

Spec V3 introduces unified multi-asset packages:

- `spec`: `"chara_card_v3"`
- `spec_version`: `"3.0"`
- `data.nickname`: Shorthand identifier for user mentions.
- `data.group_only_greetings`: Greetings delivered only when in a group chat room.
- `data.assets`: Structured asset bindings:
  ```json
  [
    {
      "type": "icon",
      "uri": "assets/avatar.png",
      "name": "main_avatar"
    },
    {
      "type": "emotion",
      "uri": "assets/expressions/happy.png",
      "name": "happy"
    },
    {
      "type": "live2d",
      "uri": "assets/live2d/model.model3.json",
      "name": "default_live2d"
    }
  ]
  ```

---

## 4. Prompt Macro Replacements

NativeTavern resolves SillyTavern macros during prompt assembly:
- `{{char}}`: Character's name.
- `{{user}}`: Active persona or user's name.
- `{{description}}`: Character description.
- `{{scenario}}`: Scenario text.
- `{{personality}}`: Character personality.
- `<START>`: Dialogue example separator.
