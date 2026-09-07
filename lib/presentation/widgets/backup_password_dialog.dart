import 'package:flutter/material.dart';
import 'package:native_tavern/domain/services/backup_password_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/cloud_backup_providers.dart';

/// `null` password means export without protection.
class BackupPasswordProtectChoice {
  const BackupPasswordProtectChoice(this.password);

  final String? password;

  static const skipped = BackupPasswordProtectChoice(null);
}

Future<BackupPasswordProtectChoice?> showBackupPasswordProtectDialog(
  BuildContext context,
) {
  return showDialog<BackupPasswordProtectChoice>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _BackupPasswordProtectDialog(),
  );
}

Future<String?> showBackupPasswordUnlockDialog(
  BuildContext context, {
  required bool incorrect,
}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _BackupPasswordUnlockDialog(incorrect: incorrect),
  );
}

class _BackupPasswordProtectDialog extends StatefulWidget {
  const _BackupPasswordProtectDialog();

  @override
  State<_BackupPasswordProtectDialog> createState() =>
      _BackupPasswordProtectDialogState();
}

class _BackupPasswordProtectDialogState
    extends State<_BackupPasswordProtectDialog> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _obscurePassword = true;
  var _obscureConfirm = true;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submitProtected() {
    final l10n = AppLocalizations.of(context);
    final password = _password.text;
    final confirm = _confirm.text;
    if (password != confirm) {
      setState(() => _error = l10n.backupPasswordMismatch);
      return;
    }
    if (password.length < BackupPasswordService.minPasswordLength) {
      setState(
        () => _error = l10n.backupPasswordTooShort(
          BackupPasswordService.minPasswordLength,
        ),
      );
      return;
    }
    Navigator.of(context).pop(BackupPasswordProtectChoice(password));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.backupPasswordTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.backupPasswordWarning),
            const SizedBox(height: 16),
            TextField(
              controller: _password,
              obscureText: _obscurePassword,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.backupPasswordField,
                suffixIcon: IconButton(
                  tooltip: l10n.backupPasswordField,
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => setState(
                    () => _obscurePassword = !_obscurePassword,
                  ),
                ),
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirm,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                labelText: l10n.backupPasswordConfirmField,
                suffixIcon: IconButton(
                  tooltip: l10n.backupPasswordConfirmField,
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () => setState(
                    () => _obscureConfirm = !_obscureConfirm,
                  ),
                ),
              ),
              onSubmitted: (_) => _submitProtected(),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(BackupPasswordProtectChoice.skipped),
          child: Text(l10n.backupPasswordSkip),
        ),
        FilledButton(
          onPressed: _submitProtected,
          child: Text(l10n.backupPasswordProtect),
        ),
      ],
    );
  }
}

class _BackupPasswordUnlockDialog extends StatefulWidget {
  const _BackupPasswordUnlockDialog({required this.incorrect});

  final bool incorrect;

  @override
  State<_BackupPasswordUnlockDialog> createState() =>
      _BackupPasswordUnlockDialogState();
}

class _BackupPasswordUnlockDialogState
    extends State<_BackupPasswordUnlockDialog> {
  final _password = TextEditingController();
  var _obscure = true;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _password.text;
    if (password.isEmpty) return;
    Navigator.of(context).pop(password);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.backupPasswordUnlockTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.backupPasswordUnlockBody),
            const SizedBox(height: 16),
            TextField(
              controller: _password,
              obscureText: _obscure,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.backupPasswordField,
                errorText:
                    widget.incorrect ? l10n.backupPasswordIncorrect : null,
                suffixIcon: IconButton(
                  tooltip: l10n.backupPasswordField,
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.backupPasswordUnlockAction),
        ),
      ],
    );
  }
}

/// Shared prompt used by backup import operations.
BackupPasswordPrompt backupPasswordPromptFor(BuildContext context) {
  return ({required bool incorrect}) async {
    if (!context.mounted) return null;
    return showBackupPasswordUnlockDialog(context, incorrect: incorrect);
  };
}
