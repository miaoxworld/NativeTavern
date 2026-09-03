## Summary

Provide a concise description of the changes introduced in this PR and the problem/feature they address.

Fixes #(issue number, if applicable)

## Type of Change

- [ ] 🐛 Bug fix (non-breaking change fixing an issue)
- [ ] ✨ New feature (non-breaking change adding functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to change)
- [ ] 🌐 Localization / Internationalization update
- [ ] 🔧 Refactoring / Code cleanup
- [ ] 📝 Documentation update

## Changes Made

- Detailed bullet point list of changes made across components/files

## User-Facing UI & Localization Checklist

If this PR contains user-facing UI changes:

- [ ] No hardcoded user-facing strings were added; all visible text uses `AppLocalizations.of(context)!` / `l10n`.
- [ ] New translation keys and descriptions were added to `lib/l10n/app_en.arb` with proper `@key` metadata.
- [ ] Translation entries were propagated across target `.arb` files in `lib/l10n/`.
- [ ] Ran `flutter gen-l10n` to regenerate `lib/l10n/generated/` classes.
- [ ] Associated provider sources and consent lists (such as `aiDataSharingRecipients`) are updated and synchronized.

## Verification & Testing

- [ ] Automated tests run and pass (`flutter test`).
- [ ] Static analysis passes with no new warnings (`flutter analyze`).
- [ ] Tested manually on target platform(s) (iOS / Android / macOS / Desktop).
- [ ] Verified UI layouts and localized text display correctly.
