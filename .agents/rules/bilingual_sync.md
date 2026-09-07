# Bidirectional Bilingual Synchronization (English <-> Chinese)

NativeTavern is co-maintained by native Chinese and English speakers. All AI agents (Cursor, Windsurf, Gemini, Claude, Copilot, Antigravity, etc.) and human contributors must uphold bidirectional translation parity across all strings, localization files, and documentation.

---

## 1. Localization Strings (`lib/l10n/`)

Whenever user-facing strings are added, updated, or deprecated:

1. **Bidirectional Parity**:
   - If added in English (`lib/l10n/app_en.arb`): Immediately translate and add matching entries to `lib/l10n/app_zh.arb` (Simplified Chinese) and `lib/l10n/app_zh_TW.arb` (Traditional Chinese), along with other supported locales (`ja`, `ko`, `es`, `fr`, `de`, `ru`, etc.).
   - If added in Chinese (`lib/l10n/app_zh.arb`): Immediately translate and add the entry to `lib/l10n/app_en.arb` with complete `@key` metadata (description, placeholders, and type definitions).
2. **Key Consistency**:
   - The JSON key name and placeholder variables must match exactly across all `.arb` files.
3. **Regeneration**:
   - Always run `flutter gen-l10n` to regenerate localization classes in `lib/l10n/generated/`.

---

## 2. Documentation & Guides

Whenever repository documentation is created or modified:

1. **Paired Files**:
   - `README.md` (Simplified Chinese) <---> `README.en.md` (English)
   - `CONTRIBUTING.md` (Simplified Chinese) <---> `CONTRIBUTING.en.md` (English)
   - Any update to one file must be reflected in its counterpart.
2. **Feature Specs & Architecture Docs**:
   - For technical documentation in `docs/` and `.agents/docs/`, ensure key concepts, terms, and tables are clearly explained in both English and Chinese or provided as paired documents when appropriate.

---

## 3. Pull Requests, Commits & Code Comments

1. **PR Summaries**: Include clear descriptions in English, accompanied by Chinese summaries or key points when communicating significant architectural changes or releases.
2. **Code Comments**: Keep code comments clean, concise, and accessible to both English and Chinese readers.
