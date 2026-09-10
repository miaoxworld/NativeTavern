import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/secret_vault_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/providers/cloud_backup_providers.dart';

/// Asks which API key to keep when this device and the cloud both have one.
class ApiKeyConflictGate extends ConsumerWidget {
  final Widget child;

  const ApiKeyConflictGate({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<List<SecretKeyConflict>>(pendingApiKeyConflictsProvider,
        (previous, next) {
      if (next.isEmpty || !context.mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => ApiKeyConflictDialog(conflicts: next),
      );
    });
    return child;
  }
}

class ApiKeyConflictDialog extends ConsumerStatefulWidget {
  final List<SecretKeyConflict> conflicts;

  const ApiKeyConflictDialog({super.key, required this.conflicts});

  @override
  ConsumerState<ApiKeyConflictDialog> createState() =>
      _ApiKeyConflictDialogState();
}

class _ApiKeyConflictDialogState extends ConsumerState<ApiKeyConflictDialog> {
  late final Set<String> _useRemote;

  @override
  void initState() {
    super.initState();
    _useRemote = {};
  }

  String _labelFor(SecretKeyConflict conflict, AppLocalizations l10n) {
    final id = conflict.id;
    if (id == SecretVaultService.llmConfigPreferenceKey) {
      return l10n.apiKeyConflictActiveProvider;
    }
    if (id.startsWith(SecretVaultService.llmProviderConfigPrefix)) {
      return id.substring(SecretVaultService.llmProviderConfigPrefix.length);
    }
    return id;
  }

  String _masked(String value) {
    final trimmed = value.trim();
    if (trimmed.length <= 4) return '••••';
    return '••••${trimmed.substring(trimmed.length - 4)}';
  }

  Future<void> _apply() async {
    final chosen = widget.conflicts.where((conflict) {
      return _useRemote.contains('${conflict.store.name}:${conflict.id}');
    });
    await ref
        .read(cloudBackupOperationProvider.notifier)
        .resolveApiKeyConflicts(useRemote: chosen);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.apiKeySyncConflictTitle),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.apiKeySyncConflictBody),
              const SizedBox(height: 12),
              for (final conflict in widget.conflicts)
                CheckboxListTile(
                  value: _useRemote
                      .contains('${conflict.store.name}:${conflict.id}'),
                  title: Text(_labelFor(conflict, l10n)),
                  subtitle: Text(
                    l10n.apiKeySyncConflictChoice(
                      _masked(conflict.localValue),
                      _masked(conflict.remoteValue),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      final key = '${conflict.store.name}:${conflict.id}';
                      if (value == true) {
                        _useRemote.add(key);
                      } else {
                        _useRemote.remove(key);
                      }
                    });
                  },
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await ref
                .read(cloudBackupOperationProvider.notifier)
                .resolveApiKeyConflicts(useRemote: const []);
            if (mounted) Navigator.of(context).pop();
          },
          child: Text(l10n.keepThisDevice),
        ),
        TextButton(
          onPressed: () async {
            await ref
                .read(cloudBackupOperationProvider.notifier)
                .resolveApiKeyConflicts(useRemote: widget.conflicts);
            if (mounted) Navigator.of(context).pop();
          },
          child: Text(l10n.keepOtherDevice),
        ),
        FilledButton(
          onPressed: _apply,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
