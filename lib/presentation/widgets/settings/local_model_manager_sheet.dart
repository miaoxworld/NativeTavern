import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/llm_service.dart';
import 'package:native_tavern/domain/services/local_model_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

class LocalModelManagerSheet extends ConsumerStatefulWidget {
  final LLMConfig config;

  const LocalModelManagerSheet({super.key, required this.config});

  @override
  ConsumerState<LocalModelManagerSheet> createState() =>
      _LocalModelManagerSheetState();
}

class _LocalModelManagerSheetState
    extends ConsumerState<LocalModelManagerSheet> {
  final LocalModelService _service = LocalModelService();
  bool _isLoading = false;
  String? _progressStatus;
  OllamaPullProgress? _pullProgress;

  final TextEditingController _pullModelController = TextEditingController();

  final TextEditingController _createNameController = TextEditingController();
  final TextEditingController _createBaseController = TextEditingController();
  final TextEditingController _createSystemController = TextEditingController();
  final TextEditingController _createContextController =
      TextEditingController();

  @override
  void dispose() {
    _pullModelController.dispose();
    _createNameController.dispose();
    _createBaseController.dispose();
    _createSystemController.dispose();
    _createContextController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _pullModel() async {
    final modelName = _pullModelController.text.trim();
    if (modelName.isEmpty) return;

    final successMsg = AppLocalizations.of(context).localModelPullSuccess;

    setState(() {
      _isLoading = true;
      _pullProgress = null;
    });

    try {
      await _service.pullModel(
        widget.config,
        modelName,
        onProgress: (progress) {
          if (!mounted) return;
          setState(() {
            _pullProgress = progress;
          });
        },
      );
      _showSuccess(successMsg);
      _pullModelController.clear();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createModel() async {
    final newModel = _createNameController.text.trim();
    final baseModel = _createBaseController.text.trim();

    if (newModel.isEmpty || baseModel.isEmpty) return;

    final successMsg = AppLocalizations.of(context).localModelCreateSuccess;

    setState(() {
      _isLoading = true;
      _progressStatus = 'Creating...';
    });

    try {
      final ctxLen = int.tryParse(_createContextController.text.trim());
      await _service.createDerivativeModel(
        widget.config,
        newModel: newModel,
        baseModel: baseModel,
        systemPrompt: _createSystemController.text.trim().isNotEmpty
            ? _createSystemController.text.trim()
            : null,
        contextLength: ctxLen,
        onProgress: (status) {
          if (!mounted) return;
          setState(() {
            _progressStatus = status;
          });
        },
      );
      _showSuccess(successMsg);
      _createNameController.clear();
      _createBaseController.clear();
      _createSystemController.clear();
      _createContextController.clear();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _progressStatus = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.localModelManagerTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TabBar(
              tabs: [
                Tab(text: l10n.localModelPullTab),
                Tab(text: l10n.localModelCreateTab),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: TabBarView(
                children: [
                  // PULL TAB
                  ListView(
                    children: [
                      TextField(
                        controller: _pullModelController,
                        decoration: InputDecoration(
                          labelText: l10n.localModelNameHint,
                          helperText: l10n.localModelNameHelper,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_isLoading && _pullProgress != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(_pullProgress!.status),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _pullProgress!.percent,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(_pullProgress!.completed / 1024 / 1024).toStringAsFixed(1)} MB / ${(_pullProgress!.total / 1024 / 1024).toStringAsFixed(1)} MB',
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _pullModel,
                        child: Text(l10n.localModelPullButton),
                      ),
                    ],
                  ),
                  // CREATE TAB
                  ListView(
                    children: [
                      TextField(
                        controller: _createNameController,
                        decoration: InputDecoration(
                          labelText: l10n.localModelNewName,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _createBaseController,
                        decoration: InputDecoration(
                          labelText: l10n.localModelBaseName,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _createSystemController,
                        decoration: InputDecoration(
                          labelText: l10n.localModelSystemPrompt,
                        ),
                        maxLines: 3,
                        minLines: 1,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _createContextController,
                        decoration: InputDecoration(
                          labelText: l10n.localModelContextLimit,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      if (_isLoading && _progressStatus != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(_progressStatus!),
                        ),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _createModel,
                        child: Text(l10n.localModelCreateButton),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
