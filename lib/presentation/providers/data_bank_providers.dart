import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:native_tavern/data/models/data_bank_context.dart';
import 'package:native_tavern/data/repositories/drift_data_bank_repository.dart';
import 'package:native_tavern/domain/repositories/data_bank_repository.dart';
import 'package:native_tavern/domain/services/chat_generation_pipeline.dart';
import 'package:native_tavern/domain/services/data_bank_context_service.dart';
import 'package:native_tavern/domain/services/data_bank_library_service.dart';
import 'package:native_tavern/presentation/providers/chat_extension_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/providers/vector_storage_providers.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

final dataBankRepositoryProvider = Provider<DataBankRepository>((ref) {
  return DriftDataBankRepository(ref.watch(databaseProvider));
});

final dataBankManagedFileStoreProvider = Provider<DataBankManagedFileStore>((
  ref,
) {
  return FileDataBankManagedFileStore(
    root: Directory(path.join(ref.watch(dataPathProvider), 'data_bank')),
  );
});

final dataBankLibraryServiceProvider = Provider<DataBankLibraryOperations>((
  ref,
) {
  return DataBankLibraryService(
    repository: ref.watch(dataBankRepositoryProvider),
    files: ref.watch(dataBankManagedFileStoreProvider),
  );
});

final dataBankContextSettingsProvider = StateNotifierProvider<
    DataBankContextSettingsNotifier, DataBankContextSettings>((ref) {
  return DataBankContextSettingsNotifier(
    ref.watch(sharedPreferencesProvider),
  );
});

final lastDataBankContextProvider = StateProvider<DataBankContextSnapshot?>(
  (ref) => null,
);

final dataBankContextServiceProvider = Provider<DataBankContextService>((ref) {
  final embedder = ref.watch(embeddingServiceProvider);
  return DataBankContextService(
    repository: ref.watch(dataBankRepositoryProvider),
    embedBatch: embedder.embedBatch,
  );
});

final dataBankContextContributorProvider = Provider<DataBankContextContributor>(
  (ref) {
    return DataBankContextContributor(
      service: ref.watch(dataBankContextServiceProvider),
      settings: () => ref.read(dataBankContextSettingsProvider),
      embeddingSettings: () => ref.read(vectorStorageSettingsProvider),
      onRetrieved: (snapshot) {
        ref.read(lastDataBankContextProvider.notifier).state = snapshot;
      },
    );
  },
);

final dataBankContextRegistrationProvider = Provider<ChatExtensionRegistration>(
  (ref) {
    final registration = ref
        .watch(chatExtensionRegistryProvider)
        .registerContributor(ref.watch(dataBankContextContributorProvider));
    ref.onDispose(registration.dispose);
    return registration;
  },
);

final class DataBankContextSettingsNotifier
    extends StateNotifier<DataBankContextSettings> {
  static const _storageKey = 'data_bank_context_settings';
  final SharedPreferences _preferences;

  DataBankContextSettingsNotifier(this._preferences)
      : super(_load(_preferences));

  void setEnabled(bool enabled) => _update(state.copyWith(enabled: enabled));

  void setQueryRewriteEnabled(bool enabled) =>
      _update(state.copyWith(queryRewriteEnabled: enabled));

  void setSemanticRerankingEnabled(bool enabled) =>
      _update(state.copyWith(semanticRerankingEnabled: enabled));

  void setTopK(int topK) => _update(state.copyWith(topK: topK));

  void setMaxTokens(int maxTokens) =>
      _update(state.copyWith(maxTokens: maxTokens));

  void setMaxChunksPerDocument(int maximum) =>
      _update(state.copyWith(maxChunksPerDocument: maximum));

  void _update(DataBankContextSettings next) {
    state = next;
    unawaited(_preferences.setString(_storageKey, jsonEncode(next.toJson())));
  }

  static DataBankContextSettings _load(SharedPreferences preferences) {
    final encoded = preferences.getString(_storageKey);
    if (encoded == null) return const DataBankContextSettings();
    try {
      return DataBankContextSettings.fromJson(
        Map<String, dynamic>.from(jsonDecode(encoded) as Map),
      );
    } catch (_) {
      return const DataBankContextSettings();
    }
  }
}
