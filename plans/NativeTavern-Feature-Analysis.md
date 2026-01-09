# NativeTavern Feature Analysis & Implementation Plan

## SillyTavern Original Features Analysis

Based on analysis of the SillyTavern codebase, here are all the major features categorized by priority for native implementation.

---

## ALREADY IMPLEMENTED IN NATIVETAVERN ✅

### Core Foundation (Phase 1-2)
- [x] Flutter + Riverpod architecture
- [x] SQLite database with Drift
- [x] Character import (PNG cards, JSON)
- [x] Basic chat functionality
- [x] LLM provider support (OpenAI, Claude, OpenRouter, Gemini, Ollama, KoboldCpp)
- [x] Streaming responses (SSE)
- [x] Character list with search
- [x] Chat history management
- [x] Settings screen with LLM configuration

### Phase 3A
- [x] **Message Actions** - Edit, delete, regenerate, swipe between alternatives
- [x] **Personas** - User profile management with descriptions
- [x] **Instruct Mode** - 9 built-in prompt templates (ChatML, Alpaca, Llama2, Llama3, Mistral, Vicuna, etc.)

### Phase 3B
- [x] **World Info / Lorebook System** - Keyword-triggered context injection with multiple positions, recursion, case sensitivity, group scoring
- [x] **Character Editor** - Create/edit characters natively with all fields, avatar support, export to PNG/JSON/CharX
- [x] **CharX Full Import** - V3 spec with embedded lorebooks, alternate greetings, character books

### Phase 4A
- [x] **Group Chats** - Multi-character conversations with 5 response modes (Sequential, Random, All, Manual, Natural), talkativeness, trigger words, muting

---

## ALREADY IMPLEMENTED: Phase 4A-4B ✅

### 1. Chat Bookmarks/Checkpoints ✅
**Source:** `public/scripts/bookmarks.js`

**Features:**
- [x] Create named checkpoints in chat
- [x] Branch from any checkpoint
- [x] Navigate between branches
- [x] Bookmark list dialog
- [x] Restore to checkpoint

### 2. Macro System ✅
**Source:** `public/scripts/macros.js`, `public/scripts/macros/`

**Core Macros:**
- [x] `{{user}}` - Current persona name
- [x] `{{char}}` - Character name
- [x] `{{time}}` - Current time (12/24 hour format)
- [x] `{{date}}` - Current date
- [x] `{{weekday}}` - Day of week
- [x] `{{random}}` - Random values (with min:max range)
- [x] `{{roll}}` - Dice rolling (NdM format)
- [x] `{{idle_duration}}` - Time since last message
- [x] `{{lastMessage}}` - Last message content
- [x] `{{lastUserMessage}}` / `{{lastCharMessage}}` - Role-specific last messages
- [x] `{{mesId}}` - Message ID counter
- [x] `{{input}}` - Current input field content
- [x] Nested macro support

---

## ALREADY IMPLEMENTED: Phase 5 ✅

### 7. Author's Note / System Prompts ✅
**Source:** `public/scripts/authors-note.js`, `public/scripts/sysprompt.js`

- [x] Author's note injection at configurable depth
- [x] System prompt management
- [x] Per-chat overrides
- [x] Character-specific system prompts

### 8. Prompt Manager ✅
**Source:** `public/scripts/PromptManager.js`, `public/scripts/itemized-prompts.js`

- [x] Prompt ordering/reordering
- [x] Prompt enabling/disabling
- [x] SillyTavern preset import (prompts + prompt_order)
- [x] Custom prompt sections with role support
- [x] Depth-based injection

### 9. Advanced Generation Settings ✅
**Source:** `public/scripts/textgen-settings.js`, `public/scripts/samplerSelect.js`

- [x] Full sampler control (top_k, top_p, typical_p, min_p, etc.)
- [x] Repetition penalty settings
- [x] Stop sequences
- [x] Mirostat mode (mode, tau, eta)
- [x] Tail-free sampling, Top-A
- [x] Token streaming controls

### 10. Quick Replies ✅
**Source:** `src/endpoints/quick-replies.js`

- [x] Customizable quick reply buttons
- [x] Macro support in replies
- [x] Built-in quick replies (Continue, Regenerate, etc.)

### 11. Themes ✅
**Source:** `src/endpoints/themes.js`

- [x] 18 built-in themes (7 dark + 11 light)
- [x] Custom color themes
- [x] Theme editor with color picker
- [x] Per-color customization

### 12. Statistics ✅
**Source:** `public/scripts/stats.js`, `src/endpoints/stats.js`

- [x] Message count per character
- [x] Total messages and chats
- [x] Character statistics screen

### 13. Chain of Thought / Reasoning Support ✅
**New Feature**

- [x] Parse reasoning from OpenAI o1/o3 models (reasoning_content)
- [x] Parse thinking from Claude (thinking blocks)
- [x] Parse thought from Gemini 2.0 Flash Thinking
- [x] Store reasoning in ChatMessage model
- [x] Reasoning swipes support

---

## PRIORITY 2: Convenience Features (Phase 6)

### 14. Slash Commands
**Source:** `public/scripts/slash-commands.js`, `public/scripts/slash-commands/`

- [x] `/continue` - Continue generation (via Quick Reply)
- [x] `/regenerate` - Regenerate last message (via Quick Reply)
- [ ] `/swipe` - Navigate swipes
- [ ] `/persona` - Switch persona
- [ ] `/sys` - Send system message
- [ ] `/bg` - Change background
- [ ] Custom command registration

### 15. Tags & Filters
**Source:** `public/scripts/tags.js`, `public/scripts/filters.js`

- [x] Character filtering (by name search)
- [ ] Character tagging
- [ ] Tag-based filtering
- [x] Favorites system
- [x] Recent characters
- [x] Sort options

### 16. Backgrounds
**Source:** `public/scripts/backgrounds.js`, `src/endpoints/backgrounds.js`

- [x] Custom chat backgrounds
- [x] Per-chat backgrounds
- [x] Background gallery
- [x] Background opacity control

---

## PRIORITY 3: Advanced Features (Phase 7+)

### 17. Extensions System
**Source:** `public/scripts/extensions.js`, `src/endpoints/extensions.js`

- [ ] Plugin architecture
- [ ] Extension marketplace
- [ ] Settings per extension

### 18. Expression Sprites
**Source:** `public/scripts/sprites.js`, `src/endpoints/sprites.js`

- [ ] Character expression images
- [ ] Emotion detection
- [ ] Sprite animations

### 19. Text-to-Speech / Speech-to-Text
**Source:** `public/scripts/speech.js`, `src/endpoints/speech.js`

- [ ] TTS providers (ElevenLabs, etc.)
- [ ] Voice per character
- [ ] STT for voice input

### 20. Image Generation
**Source:** `src/endpoints/stable-diffusion.js`, `src/endpoints/images.js`

- [ ] Stable Diffusion integration
- [ ] Character portrait generation
- [ ] In-chat image generation

### 21. Translation
**Source:** `src/endpoints/translate.js`

- [ ] Message translation
- [ ] Auto-translate settings

### 22. Vector Storage / RAG
**Source:** `src/endpoints/vectors.js`

- [ ] Long-term memory
- [ ] Semantic search
- [ ] Context retrieval

---

## Implementation Priority Summary

| Phase | Features | Status |
|-------|----------|--------|
| **1-2** | Core Foundation | ✅ Complete |
| **3A** | Message Actions, Personas, Instruct Mode | ✅ Complete |
| **3B** | World Info, CharX Full Import, Character Editor | ✅ Complete |
| **4A** | Group Chats, Chat Bookmarks | ✅ Complete |
| **4B** | Macro System | ✅ Complete |
| **5** | Author's Note, Prompt Manager, Advanced Settings, Quick Replies, Themes, Statistics, Chain of Thought | ✅ Complete |
| **6** | Slash Commands, Tags, Backgrounds | 🔄 Partial |
| **7+** | Extensions, Sprites, TTS/STT, Image Gen, Translation, RAG | ⏳ Pending |

---

## Next Steps

### Immediate Priority (Phase 6):
1. **Slash Commands** - Full command system with /swipe, /persona, /sys, /bg
2. **Tags & Filters** - Character tagging, tag-based filtering
3. **UI Polish** - Reasoning display in chat, markdown rendering improvements

### Then (Phase 7+):
4. **Extensions System** - Plugin architecture
5. **Expression Sprites** - Character expression images
6. **TTS/STT** - Voice support
7. **Image Generation** - Stable Diffusion integration

---

## Technical Notes

### World Info Implementation (DONE):
- ✅ SQLite storage with proper indexing
- ✅ Keyword matching engine in Dart
- ✅ Multiple insertion positions
- ✅ Recursion and group scoring support

### Group Chat Implementation (DONE):
- ✅ Extended Chat model with group support
- ✅ GroupMember with talkativeness, triggers, muting
- ✅ 5 turn order modes (Sequential, Random, All, Manual, Natural)
- ✅ Character switching in UI

### Chain of Thought Implementation (DONE):
- ✅ LLMStreamChunk class for streaming with reasoning
- ✅ Provider-specific parsing (OpenAI, Claude, Gemini)
- ✅ ChatMessage model with reasoning/reasoningSwipes fields
- ✅ chat_providers updated to use generateStreamWithReasoning

### Theme System (DONE):
- ✅ 18 built-in themes (7 dark + 11 light)
- ✅ AppThemeConfig model with full color customization
- ✅ Theme editor screen with color picker
- ✅ Theme persistence via SharedPreferences