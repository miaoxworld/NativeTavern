import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/variables_service.dart';

/// Provider for the variables service singleton
final variablesServiceProvider = Provider<VariablesService>((ref) {
  return VariablesService.instance;
});

/// Provider for global variables
final globalVariablesProvider = StateNotifierProvider<GlobalVariablesNotifier, Map<String, dynamic>>((ref) {
  return GlobalVariablesNotifier(ref.watch(variablesServiceProvider));
});

/// Notifier for managing global variables state
class GlobalVariablesNotifier extends StateNotifier<Map<String, dynamic>> {
  final VariablesService _service;
  
  GlobalVariablesNotifier(this._service) : super({}) {
    _loadVariables();
  }

  Future<void> _loadVariables() async {
    await _service.initialize();
    state = _service.getAllGlobalVariables();
  }

  void refresh() {
    state = _service.getAllGlobalVariables();
  }

  Future<void> setVariable(String name, dynamic value, {String? index}) async {
    await _service.setGlobalVariable(name, value, index: index);
    state = _service.getAllGlobalVariables();
  }

  Future<void> deleteVariable(String name) async {
    await _service.deleteGlobalVariable(name);
    state = _service.getAllGlobalVariables();
  }

  Future<void> clearAll() async {
    await _service.clearGlobalVariables();
    state = {};
  }

  Future<dynamic> increment(String name) async {
    final result = await _service.incrementGlobalVariable(name);
    state = _service.getAllGlobalVariables();
    return result;
  }

  Future<dynamic> decrement(String name) async {
    final result = await _service.decrementGlobalVariable(name);
    state = _service.getAllGlobalVariables();
    return result;
  }

  Future<dynamic> add(String name, dynamic value) async {
    final result = await _service.addGlobalVariable(name, value);
    state = _service.getAllGlobalVariables();
    return result;
  }
}

/// Provider for local variables (per-chat)
final localVariablesProvider = StateNotifierProvider.family<LocalVariablesNotifier, Map<String, dynamic>, String>((ref, chatId) {
  return LocalVariablesNotifier(ref.watch(variablesServiceProvider), chatId);
});

/// Notifier for managing local variables state for a specific chat
class LocalVariablesNotifier extends StateNotifier<Map<String, dynamic>> {
  final VariablesService _service;
  final String chatId;
  
  LocalVariablesNotifier(this._service, this.chatId) : super({}) {
    _loadVariables();
  }

  void _loadVariables() {
    state = _service.getAllLocalVariables(chatId);
  }

  void refresh() {
    state = _service.getAllLocalVariables(chatId);
  }

  void setVariable(String name, dynamic value, {String? index}) {
    _service.setLocalVariable(chatId, name, value, index: index);
    state = _service.getAllLocalVariables(chatId);
  }

  void deleteVariable(String name) {
    _service.deleteLocalVariable(chatId, name);
    state = _service.getAllLocalVariables(chatId);
  }

  void clearAll() {
    _service.clearLocalVariables(chatId);
    state = {};
  }

  dynamic increment(String name) {
    final result = _service.incrementLocalVariable(chatId, name);
    state = _service.getAllLocalVariables(chatId);
    return result;
  }

  dynamic decrement(String name) {
    final result = _service.decrementLocalVariable(chatId, name);
    state = _service.getAllLocalVariables(chatId);
    return result;
  }

  dynamic add(String name, dynamic value) {
    final result = _service.addLocalVariable(chatId, name, value);
    state = _service.getAllLocalVariables(chatId);
    return result;
  }

  /// Load variables from chat metadata
  void loadFromMetadata(Map<String, dynamic>? metadata) {
    _service.loadLocalVariablesFromMetadata(chatId, metadata);
    state = _service.getAllLocalVariables(chatId);
  }

  /// Export variables to chat metadata
  Map<String, dynamic>? exportToMetadata() {
    return _service.exportLocalVariablesToMetadata(chatId);
  }
}

/// Provider for combined variable info (for display)
final allVariablesInfoProvider = Provider.family<List<VariableInfo>, String?>((ref, chatId) {
  final globalVars = ref.watch(globalVariablesProvider);
  final localVars = chatId != null ? ref.watch(localVariablesProvider(chatId)) : <String, dynamic>{};

  final result = <VariableInfo>[];

  // Add global variables
  for (final entry in globalVars.entries) {
    result.add(VariableInfo(
      name: entry.key,
      value: entry.value,
      isGlobal: true,
    ));
  }

  // Add local variables
  for (final entry in localVars.entries) {
    result.add(VariableInfo(
      name: entry.key,
      value: entry.value,
      isGlobal: false,
      chatId: chatId,
    ));
  }

  // Sort by name
  result.sort((a, b) => a.name.compareTo(b.name));

  return result;
});

/// Provider for variable count
final variableCountProvider = Provider.family<int, String?>((ref, chatId) {
  final globalCount = ref.watch(globalVariablesProvider).length;
  final localCount = chatId != null ? ref.watch(localVariablesProvider(chatId)).length : 0;
  return globalCount + localCount;
});