# NativeTavern Coding Standards

## 1. Dart 3 Language Standards

- **Dart Version**: `>=3.2.0 <4.0.0` (Flutter `>=3.44.9`).
- **Switch Expressions & Pattern Matching**:
  Prefer modern switch expressions for exhaustiveness checks on sealed classes and enums.

  ```dart
  final icon = switch (providerType) {
    AiProviderType.xai => Icons.bolt,
    AiProviderType.openai => Icons.smart_toy,
    AiProviderType.anthropic => Icons.psychology,
    _ => Icons.extension,
  };
  ```

- **Null Safety**: Avoid force unwrap `!` unless preceded by an explicit null check or assertion. Do not introduce redundant `!` on non-nullable receivers.
- **Immutability**: Data transfer objects, character models, and domain events should be immutable using `@freezed` or `Equatable`.

---

## 2. User-Facing UI, Localization & Bilingual Sync (MANDATORY)

- **Zero Hardcoded Strings**: NEVER hardcode user-visible strings in widgets, dialogs, snackbars, or screens.
- **AppLocalizations**: Always retrieve strings through `AppLocalizations.of(context)!` or `l10n`.
- **Bidirectional Parity (English <-> Chinese)**:
  - When keys are added/updated in English (`app_en.arb`), immediately provide Chinese translations (`app_zh.arb`, `app_zh_TW.arb`), and propagate to other locales.
  - When keys are added/updated in Chinese, immediately provide English translations in `app_en.arb` with complete `@key` metadata.
  - Paired docs (`README.md` / `README.en.md`, `CONTRIBUTING.md` / `CONTRIBUTING.en.md`) must be kept in sync. See [.agents/rules/bilingual_sync.md](file:///Users/themoddersden/Developer/Projects/App-Dev/NativeTavern-xAI-Fix/.agents/rules/bilingual_sync.md).
- **Adding New Keys**:
  1. Add new translation key and `@key` metadata to `lib/l10n/app_en.arb`.
  2. Add translations across target locales (`app_zh.arb`, `app_zh_TW.arb`, `app_ja.arb`, `app_de.arb`, `app_fr.arb`, `app_es.arb`, etc.).
  3. Run `flutter gen-l10n` to regenerate classes in `lib/l10n/generated/`.
- **Consent Lists & UI Providers**: Keep AI data sharing consent lists (`aiDataSharingRecipients`) synchronized when new AI providers are added.

---

## 3. UI Aesthetics & Theming

- Follow `AppTheme` tokens in `lib/presentation/theme/app_theme.dart`.
- Support both Light and Dark themes dynamically.
- Use smooth transitions and responsive layouts (`LayoutBuilder`, `MediaQuery`).
- Tap targets must be at least 44x44pt on mobile platforms.
