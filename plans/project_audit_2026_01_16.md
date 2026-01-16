# NativeTavern vs SillyTavern Project Audit

**Date:** 2026-01-16  
**Purpose:** Compare data structures and feature parity between NativeTavern (Flutter native app) and SillyTavern (web project)

---

## Executive Summary

NativeTavern is a Flutter-based native cross-platform rewrite of SillyTavern. This audit compares the two projects to identify:
1. Data structure alignment
2. Feature parity gaps
3. Development tasks for completion and optimization

---

## 1. Data Structure Comparison

### 1.1 Character Model

| Field | SillyTavern | NativeTavern | Status |
|-------|-------------|--------------|--------|
| name | ✅ | ✅ | ✅ Aligned |
| description | ✅ | ✅ | ✅ Aligned |
| personality | ✅ | ✅ | ✅ Aligned |
| scenario | ✅ | ✅ | ✅ Aligned |
| first_mes | ✅ | ✅ | ✅ Aligned |
| mes_example | ✅ | ✅ | ✅ Aligned |
| avatar | ✅ | ✅ | ✅ Aligned |
| system_prompt | ✅ | ✅ | ✅ Aligned |
| post_history_instructions | ✅ | ✅ | ✅ Aligned |
| creator_notes | ✅ | ✅ | ✅ Aligned |
| tags | ✅ | ✅ | ✅ Aligned |
| character_book | ✅ | ✅ | ✅ Aligned |
| extensions | ✅ | ❌ | ⚠️ Missing |
| alternate_greetings | ✅ | ✅ | ✅ Aligned |
| depth_prompt | ✅ | ❌ | ⚠️ Missing |
| talkativeness | ✅ (group) | ❌ | ⚠️ Missing |

### 1.2 Persona Model

| Field | SillyTavern | NativeTavern | Status |
|-------|-------------|--------------|--------|
| name | ✅ | ✅ | ✅ Aligned |
| description | ✅ | ✅ | ✅ Aligned |
| avatar | ✅ | ✅ | ✅ Aligned |
| isDefault | ✅ | ✅ | ✅ Aligned |
| **connections** | ✅ (char/group binding) | ❌ | ❌ Missing |
| **lock** | ✅ (chat/char/default) | ❌ | ❌ Missing |
| **description_position** | ✅ | ❌ | ❌ Missing |
| **description_depth** | ✅ | ❌ | ❌ Missing |
| **description_role** | ✅ | ❌ | ❌ Missing |
| **lorebook** | ✅ | ❌ | ❌ Missing |

**Gap Analysis:** NativeTavern Persona is very basic. SillyTavern has:
- Persona connections (bind persona to character/group)
- Lock types (chat, character, default)
- Description positioning (before/after char, at depth)
- Persona-specific lorebook

### 1.3 Group Model

| Field | SillyTavern | NativeTavern | Status |
|-------|-------------|--------------|--------|
| id | ✅ | ✅ | ✅ Aligned |
| name | ✅ | ✅ | ✅ Aligned |
| members | ✅ | ✅ | ✅ Aligned |
| avatar | ✅ | ✅ | ✅ Aligned |
| **activation_strategy** | ✅ (NATURAL/LIST/MANUAL/POOLED) | ❌ | ⚠️ Partial |
| **generation_mode** | ✅ (SWAP/APPEND/APPEND_DISABLED) | ❌ | ⚠️ Partial |
| disabled_members | ✅ | ✅ (isMuted) | ✅ Aligned |
| talkativeness | ✅ | ✅ | ✅ Aligned |
| trigger_words | ❌ | ✅ | ✅ Extra |
| allow_self_response | ✅ | ✅ | ✅ Aligned |
| **past_metadata** | ✅ | ❌ | ❌ Missing |
| **chat_metadata** | ✅ | ❌ | ❌ Missing |
| **depth_prompts** | ✅ (per member) | ❌ | ❌ Missing |

**NativeTavern GroupResponseMode:**
- sequential, random, all, manual, natural

**SillyTavern group_activation_strategy:**
- NATURAL(0), LIST(1), MANUAL(2), POOLED(3)

**SillyTavern group_generation_mode:**
- SWAP(0), APPEND(1), APPEND_DISABLED(2)

### 1.4 World Info Model

| Field | SillyTavern | NativeTavern | Status |
|-------|-------------|--------------|--------|
| uid | ✅ | ✅ | ✅ Aligned |
| keys | ✅ | ✅ | ✅ Aligned |
| secondary_keys | ✅ | ✅ | ✅ Aligned |
| content | ✅ | ✅ | ✅ Aligned |
| comment | ✅ | ✅ | ✅ Aligned |
| constant | ✅ | ✅ | ✅ Aligned |
| selective | ✅ | ✅ | ✅ Aligned |
| position | ✅ (0-7) | ✅ (0-7) | ✅ Aligned |
| depth | ✅ | ✅ | ✅ Aligned |
| order | ✅ | ✅ | ✅ Aligned |
| enabled | ✅ | ✅ | ✅ Aligned |
| **sticky** | ✅ | ❌ | ❌ Missing |
| **cooldown** | ✅ | ❌ | ❌ Missing |
| **delay** | ✅ | ❌ | ❌ Missing |
| **probability** | ✅ | ❌ | ❌ Missing |
| **group** | ✅ | ❌ | ❌ Missing |
| **group_weight** | ✅ | ❌ | ❌ Missing |
| **group_override** | ✅ | ❌ | ❌ Missing |
| **scan_depth** | ✅ | ❌ | ❌ Missing |
| **case_sensitive** | ✅ | ❌ | ❌ Missing |
| **match_whole_words** | ✅ | ❌ | ❌ Missing |
| **use_group_scoring** | ✅ | ❌ | ❌ Missing |
| **automation_id** | ✅ | ❌ | ❌ Missing |
| **character_filter** | ✅ | ❌ | ❌ Missing |
| **role** | ✅ | ❌ | ❌ Missing |
| **vectorized** | ✅ | ❌ | ❌ Missing |

**Gap Analysis:** World Info has many advanced features missing:
- Timed effects (sticky, cooldown, delay)
- Probability-based activation
- Group scoring system
- Character filtering
- Role assignment
- Vector storage integration

### 1.5 Chat/Message Model

| Field | SillyTavern | NativeTavern | Status |
|-------|-------------|--------------|--------|
| id | ✅ | ✅ | ✅ Aligned |
| name | ✅ | ✅ | ✅ Aligned |
| is_user | ✅ | ✅ | ✅ Aligned |
| mes | ✅ | ✅ | ✅ Aligned |
| send_date | ✅ | ✅ | ✅ Aligned |
| swipes | ✅ | ✅ | ✅ Aligned |
| swipe_id | ✅ | ✅ | ✅ Aligned |
| **is_system** | ✅ | ❌ | ⚠️ Partial |
| **force_avatar** | ✅ | ❌ | ❌ Missing |
| **original_avatar** | ✅ | ❌ | ❌ Missing |
| **extra.bias** | ✅ | ❌ | ❌ Missing |
| **extra.type** | ✅ (narrator) | ❌ | ❌ Missing |
| **extra.gen_id** | ✅ | ❌ | ❌ Missing |
| **extra.api** | ✅ | ❌ | ❌ Missing |
| **extra.model** | ✅ | ❌ | ❌ Missing |
| reasoning | ❌ | ✅ | ✅ Extra |
| attachments | ❌ | ✅ | ✅ Extra |

### 1.6 Instruct Template Model

| Field | SillyTavern | NativeTavern | Status |
|-------|-------------|--------------|--------|
| name | ✅ | ✅ | ✅ Aligned |
| enabled | ✅ | ✅ | ✅ Aligned |
| wrap | ✅ | ✅ | ✅ Aligned |
| input_sequence | ✅ | ✅ | ✅ Aligned |
| output_sequence | ✅ | ✅ | ✅ Aligned |
| system_sequence | ✅ | ✅ | ✅ Aligned |
| stop_sequence | ✅ | ✅ | ✅ Aligned |
| **first_output_sequence** | ✅ | ❌ | ❌ Missing |
| **last_output_sequence** | ✅ | ❌ | ❌ Missing |
| **first_input_sequence** | ✅ | ❌ | ❌ Missing |
| **last_input_sequence** | ✅ | ❌ | ❌ Missing |
| **last_system_sequence** | ✅ | ❌ | ❌ Missing |
| **input_suffix** | ✅ | ❌ | ❌ Missing |
| **output_suffix** | ✅ | ❌ | ❌ Missing |
| **system_suffix** | ✅ | ❌ | ❌ Missing |
| **story_string_prefix** | ✅ | ❌ | ❌ Missing |
| **story_string_suffix** | ✅ | ❌ | ❌ Missing |
| **user_alignment_message** | ✅ | ❌ | ❌ Missing |
| **activation_regex** | ✅ | ❌ | ❌ Missing |
| **bind_to_context** | ✅ | ❌ | ❌ Missing |
| **skip_examples** | ✅ | ❌ | ❌ Missing |
| **names_behavior** | ✅ (NONE/FORCE/ALWAYS) | ❌ | ❌ Missing |
| **system_same_as_user** | ✅ | ❌ | ❌ Missing |
| **sequences_as_stop_strings** | ✅ | ❌ | ❌ Missing |
| **macro** | ✅ | ❌ | ❌ Missing |

---

## 2. Feature Comparison

### 2.1 Core Features

| Feature | SillyTavern | NativeTavern | Status |
|---------|-------------|--------------|--------|
| Character Management | ✅ | ✅ | ✅ Complete |
| Character Import (PNG) | ✅ | ✅ | ✅ Complete |
| Character Export | ✅ | ✅ | ✅ Complete |
| Chat History | ✅ | ✅ | ✅ Complete |
| Message Swipes | ✅ | ✅ | ✅ Complete |
| Message Editing | ✅ | ✅ | ✅ Complete |
| Persona System | ✅ | ⚠️ Basic | ⚠️ Partial |
| Group Chats | ✅ | ✅ | ✅ Complete |
| World Info/Lorebook | ✅ | ⚠️ Basic | ⚠️ Partial |
| Tags | ✅ | ✅ | ✅ Complete |
| Bookmarks | ✅ | ✅ | ✅ Complete |

### 2.2 LLM Integration

| Feature | SillyTavern | NativeTavern | Status |
|---------|-------------|--------------|--------|
| OpenAI | ✅ | ✅ | ✅ Complete |
| Claude/Anthropic | ✅ | ✅ | ✅ Complete |
| OpenRouter | ✅ | ✅ | ✅ Complete |
| Google Gemini | ✅ | ✅ | ✅ Complete |
| Ollama | ✅ | ✅ | ✅ Complete |
| KoboldCpp | ✅ | ✅ | ✅ Complete |
| DeepSeek | ✅ | ✅ | ✅ Complete |
| Qwen | ✅ | ✅ | ✅ Complete |
| OpenAI Compatible | ✅ | ✅ | ✅ Complete |
| Streaming | ✅ | ✅ | ✅ Complete |
| Reasoning/Thinking | ✅ | ✅ | ✅ Complete |
| **NovelAI** | ✅ | ❌ | ❌ Missing |
| **Horde** | ✅ | ❌ | ❌ Missing |
| **TextGen WebUI** | ✅ | ❌ | ❌ Missing |

### 2.3 Advanced Features

| Feature | SillyTavern | NativeTavern | Status |
|---------|-------------|--------------|--------|
| Macro System | ✅ (extensive) | ✅ (basic) | ⚠️ Partial |
| Slash Commands | ✅ (100+ commands) | ⚠️ Basic | ⚠️ Partial |
| Regex Scripts | ✅ | ✅ | ✅ Complete |
| Quick Replies | ✅ | ✅ | ✅ Complete |
| Prompt Manager | ✅ | ✅ | ✅ Complete |
| Instruct Mode | ✅ (full) | ⚠️ Basic | ⚠️ Partial |
| CFG Scale | ✅ | ✅ | ✅ Complete |
| Logit Bias | ✅ | ✅ | ✅ Complete |
| Logprobs | ✅ | ✅ | ✅ Complete |
| **Extensions System** | ✅ | ❌ | ❌ Missing |
| **Script Injections** | ✅ | ❌ | ❌ Missing |
| **Context Templates** | ✅ | ❌ | ❌ Missing |

### 2.4 Multimedia Features

| Feature | SillyTavern | NativeTavern | Status |
|---------|-------------|--------------|--------|
| Image Generation | ✅ | ✅ | ✅ Complete |
| TTS (Text-to-Speech) | ✅ | ✅ | ✅ Complete |
| STT (Speech-to-Text) | ✅ | ✅ | ✅ Complete |
| Sprites/Expressions | ✅ | ✅ | ✅ Complete |
| Backgrounds | ✅ | ✅ | ✅ Complete |
| **Character Expressions** | ✅ (emotion detection) | ✅ | ✅ Complete |
| **Image Captioning** | ✅ | ❌ | ❌ Missing |
| **Multimodal (Vision)** | ✅ | ⚠️ | ⚠️ Partial |

### 2.5 Data Management

| Feature | SillyTavern | NativeTavern | Status |
|---------|-------------|--------------|--------|
| Backup/Restore | ✅ | ✅ | ✅ Complete |
| Chat Export | ✅ | ✅ | ✅ Complete |
| Vector Storage | ✅ | ✅ | ✅ Complete |
| Translation | ✅ | ✅ | ✅ Complete |
| Statistics | ✅ | ✅ | ✅ Complete |
| Variables | ✅ | ✅ | ✅ Complete |
| **Chat Metadata** | ✅ | ❌ | ❌ Missing |
| **Author's Note** | ✅ | ✅ | ✅ Complete |

---

## 3. Macro System Comparison

### 3.1 NativeTavern Macros (Implemented)

**User Macros:**
- `{{user}}`, `{{persona}}`, `{{user_description}}`

**Character Macros:**
- `{{char}}`, `{{description}}`, `{{personality}}`, `{{scenario}}`
- `{{first_message}}`, `{{example_dialogue}}`, `{{system_prompt}}`
- `{{post_history_instructions}}`, `{{creator_notes}}`

**Time/Date Macros:**
- `{{time}}`, `{{date}}`, `{{weekday}}`, `{{datetime}}`
- `{{time_12h}}`, `{{time_24h}}`, `{{month}}`, `{{year}}`
- `{{day}}`, `{{iso_date}}`, `{{unix_timestamp}}`

**Chat Macros:**
- `{{lastMessage}}`, `{{lastUserMessage}}`, `{{lastCharMessage}}`
- `{{messageCount}}`, `{{chatId}}`, `{{firstMessage}}`

**Random Macros:**
- `{{random}}`, `{{roll}}`, `{{pick}}`, `{{uuid}}`

**Conditional Macros:**
- `{{if::condition::then::else}}`

**Special Macros:**
- `{{newline}}`, `{{trim}}`, `{{input}}`, `{{model}}`

### 3.2 SillyTavern Macros (Missing in NativeTavern)

**Missing Macros:**
- `{{banned}}` - banned words list
- `{{timeDiff}}` - time difference calculation
- `{{outlet}}` - outlet position content
- `{{idle_duration}}` - time since last message
- `{{group}}` - group name
- `{{lastMessageId}}` - last message ID
- `{{getvar::name}}` - get variable
- `{{setvar::name::value}}` - set variable
- `{{addvar::name::value}}` - add to variable
- `{{incvar::name}}` - increment variable
- `{{decvar::name}}` - decrement variable
- `{{getglobalvar::name}}` - get global variable
- `{{setglobalvar::name::value}}` - set global variable
- `{{instructInput}}`, `{{instructOutput}}`, etc. - instruct macros
- `{{systemPrompt}}`, `{{defaultSystemPrompt}}` - system prompt macros
- `{{chatSeparator}}`, `{{chatStart}}` - context macros

---

## 4. Slash Command Comparison

### 4.1 NativeTavern Slash Commands (Implemented)

Based on `slash_command_service.dart`, basic commands are implemented.

### 4.2 SillyTavern Slash Commands (100+ commands)

**Chat Commands:**
- `/send`, `/sendas`, `/sys`, `/nar`, `/comment`
- `/continue`, `/trigger`, `/impersonate`
- `/hide`, `/unhide`, `/delname`
- `/messages`, `/setinput`

**Character Commands:**
- `/go`, `/char`, `/ask`, `/dupe`
- `/rename-char`, `/char-find`

**Group Commands:**
- `/member-add`, `/member-remove`, `/member-enable`, `/member-disable`
- `/member-up`, `/member-down`, `/member-peek`, `/member-count`

**Generation Commands:**
- `/gen`, `/genraw`, `/stop`, `/abort`
- `/addswipe`, `/delswipe`

**UI Commands:**
- `/popup`, `/input`, `/buttons`, `/echo`
- `/panels`, `/bg`, `/single`, `/bubble`, `/flat`

**Utility Commands:**
- `/pass`, `/delay`, `/run`, `/fuzzy`
- `/trimtokens`, `/trimstart`, `/trimend`
- `/upper`, `/lower`, `/substr`, `/replace`, `/test`, `/match`

**API Commands:**
- `/api`, `/api-url`, `/model`, `/tokenizer`
- `/instruct`, `/instruct-on`, `/instruct-off`, `/context`

**Injection Commands:**
- `/inject`, `/listinjects`, `/flushinject`

**Variable Commands:**
- `/let`, `/var`, `/getvar`, `/setvar`, `/addvar`
- `/getglobalvar`, `/setglobalvar`, `/addglobalvar`

---

## 5. Development Tasks

### 5.1 High Priority - Data Structure Alignment

- [ ] **Persona Enhancement**
  - Add persona connections (character/group binding)
  - Add lock types (chat, character, default)
  - Add description positioning (before/after char, at depth)
  - Add description role (system, user, assistant)
  - Add persona-specific lorebook support

- [ ] **World Info Enhancement**
  - Add timed effects (sticky, cooldown, delay)
  - Add probability-based activation
  - Add group scoring system
  - Add character filtering
  - Add role assignment
  - Add case sensitivity option
  - Add match whole words option
  - Add scan depth configuration
  - Add automation ID support

- [ ] **Instruct Template Enhancement**
  - Add first/last input/output sequences
  - Add suffix fields (input, output, system)
  - Add story string prefix/suffix
  - Add user alignment message
  - Add activation regex for auto-selection
  - Add bind to context option
  - Add skip examples option
  - Add names behavior (NONE/FORCE/ALWAYS)
  - Add system same as user option
  - Add sequences as stop strings option
  - Add macro substitution option

- [ ] **Group Enhancement**
  - Align activation strategy with SillyTavern (NATURAL/LIST/MANUAL/POOLED)
  - Add generation mode (SWAP/APPEND/APPEND_DISABLED)
  - Add per-member depth prompts
  - Add chat metadata support

### 5.2 High Priority - Feature Completion

- [ ] **Macro System Expansion**
  - Add `{{banned}}` macro
  - Add `{{timeDiff}}` macro
  - Add `{{outlet}}` macro
  - Add `{{idle_duration}}` macro
  - Add `{{group}}` macro
  - Add `{{lastMessageId}}` macro
  - Add variable manipulation macros (getvar, setvar, addvar, incvar, decvar)
  - Add global variable macros
  - Add instruct-related macros
  - Add context template macros

- [ ] **Slash Command Expansion**
  - Implement chat manipulation commands (/sendas, /sys, /nar, /comment)
  - Implement generation commands (/gen, /genraw, /continue)
  - Implement group member commands
  - Implement UI commands (/popup, /input, /buttons)
  - Implement utility commands (/fuzzy, /trim*, /replace, /match)
  - Implement injection commands (/inject, /listinjects, /flushinject)
  - Implement variable commands

- [ ] **Script Injection System**
  - Implement prompt injection mechanism
  - Add injection positions (before, after, chat, none)
  - Add injection depth control
  - Add injection role assignment
  - Add ephemeral injections
  - Add filter closures

### 5.3 Medium Priority - Advanced Features

- [ ] **Context Template System**
  - Create context template model
  - Implement context preset management
  - Add story string formatting
  - Add example message formatting
  - Add chat start/separator handling

- [ ] **Message Enhancement**
  - Add force_avatar support
  - Add original_avatar tracking
  - Add message bias (extra.bias)
  - Add message type (narrator, system)
  - Add generation metadata (gen_id, api, model)

- [ ] **Advanced World Info Features**
  - Implement recursive scanning
  - Implement group scoring algorithm
  - Implement timed effects (WorldInfoTimedEffects)
  - Add vector storage integration for semantic search

### 5.4 Medium Priority - LLM Providers

- [ ] **Add NovelAI Provider**
  - Implement NovelAI API integration
  - Add NovelAI-specific parameters

- [ ] **Add Horde Provider**
  - Implement KoboldAI Horde API
  - Add worker selection
  - Add queue management

- [ ] **Add TextGen WebUI Provider**
  - Implement oobabooga text-generation-webui API
  - Add model loading support

### 5.5 Low Priority - Nice to Have

- [ ] **Extension System**
  - Design plugin architecture for Flutter
  - Implement extension manifest loading
  - Add extension enable/disable
  - Add extension settings storage

- [ ] **Image Captioning**
  - Integrate image captioning API
  - Add caption to prompt injection

- [ ] **Chat Metadata System**
  - Implement chat-level metadata storage
  - Add script injection persistence
  - Add custom variables per chat

### 5.6 Bug Fixes and Optimizations

- [ ] **Performance Optimization**
  - Optimize large chat history loading
  - Implement message virtualization
  - Add lazy loading for character list

- [ ] **UI/UX Improvements**
  - Improve world info entry editor UI
  - Add bulk operations for world info
  - Improve group member management UI
  - Add drag-and-drop for group member ordering

- [ ] **Data Compatibility**
  - Ensure full SillyTavern character card import compatibility
  - Ensure full SillyTavern world info import compatibility
  - Add SillyTavern chat history import

---

## 6. Priority Matrix

| Priority | Category | Tasks |
|----------|----------|-------|
| P0 (Critical) | Data Alignment | Persona, World Info, Instruct Template enhancement |
| P1 (High) | Features | Macro expansion, Slash commands, Script injection |
| P2 (Medium) | Features | Context templates, Message enhancement, Advanced WI |
| P3 (Medium) | Providers | NovelAI, Horde, TextGen WebUI |
| P4 (Low) | Features | Extension system, Image captioning |
| P5 (Low) | Polish | Performance, UI/UX, Compatibility |

---

## 7. Recommended Development Order

### Phase 1: Data Structure Alignment (2-3 weeks)
1. Enhance Persona model with connections, locks, positioning
2. Enhance World Info model with timed effects, groups, filters
3. Enhance Instruct Template model with all sequences and options
4. Enhance Group model with activation strategies and generation modes

### Phase 2: Core Feature Completion (3-4 weeks)
1. Expand macro system with missing macros
2. Implement essential slash commands
3. Implement script injection system
4. Implement context template system

### Phase 3: Advanced Features (2-3 weeks)
1. Implement advanced World Info features (recursive scanning, group scoring)
2. Enhance message model with metadata
3. Add missing LLM providers

### Phase 4: Polish and Optimization (1-2 weeks)
1. Performance optimization
2. UI/UX improvements
3. Full SillyTavern compatibility testing

---

## 8. Conclusion

NativeTavern has made excellent progress as a native Flutter implementation of SillyTavern. The core chat functionality, LLM integration, and basic features are well-implemented. The main gaps are in:

1. **Advanced data structures** - Persona, World Info, and Instruct Template need significant enhancement
2. **Macro system** - Many macros are missing, especially variable manipulation
3. **Slash commands** - Only basic commands implemented, need 50+ more
4. **Script injection** - Not implemented, important for advanced users
5. **Context templates** - Not implemented, needed for proper prompt formatting

The recommended approach is to focus on data structure alignment first, as this forms the foundation for feature parity. Then expand the macro and slash command systems, which are heavily used by power users.
