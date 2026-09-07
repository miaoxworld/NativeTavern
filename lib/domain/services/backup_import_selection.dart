/// Per-collection choices when resolving a cross-device restore conflict.
class BackupImportSelection {
  final bool characters;
  final bool chats;
  final bool lorebooks;
  final bool moments;
  final bool story;
  final bool settings;
  final bool secrets;

  const BackupImportSelection({
    this.characters = true,
    this.chats = true,
    this.lorebooks = true,
    this.moments = true,
    this.story = true,
    this.settings = true,
    this.secrets = true,
  });

  static const all = BackupImportSelection();

  static const none = BackupImportSelection(
    characters: false,
    chats: false,
    lorebooks: false,
    moments: false,
    story: false,
    settings: false,
    secrets: false,
  );

  bool get importsAnything =>
      characters ||
      chats ||
      lorebooks ||
      moments ||
      story ||
      settings ||
      secrets;

  /// Drops collections the user chose to keep locally.
  Map<String, dynamic> filterData(Map<String, dynamic> data) {
    final filtered = Map<String, dynamic>.from(data);
    if (!characters) {
      filtered.remove('characters');
      filtered.remove('characterTags');
    }
    if (!chats) {
      filtered.remove('chats');
      filtered.remove('messages');
      filtered.remove('bookmarks');
    }
    if (!lorebooks) {
      filtered.remove('worldInfos');
      filtered.remove('worldInfoEntries');
    }
    if (!moments) {
      filtered.remove('momentPosts');
      filtered.remove('momentComments');
      filtered.remove('momentPostLikes');
    }
    if (!story) {
      filtered.remove('storyChapters');
    }
    if (!settings) {
      filtered
        ..remove('llmConfigs')
        ..remove('personas')
        ..remove('groups')
        ..remove('tags')
        ..remove('globalStates')
        ..remove('longTermMemories')
        ..remove('longTermMemorySourceMessages')
        ..remove('rpgScenarios')
        ..remove('rpgStateSnapshots')
        ..remove('rpgChatStates')
        ..remove('dataBankDocuments')
        ..remove('dataBankDocumentVersions')
        ..remove('dataBankSections')
        ..remove('dataBankTextChunks')
        ..remove('dataBankBindings');
    }
    return filtered;
  }
}
