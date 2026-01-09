import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/group.dart';
import 'package:native_tavern/data/repositories/group_repository.dart';

/// All groups list provider
final allGroupsProvider = FutureProvider<List<Group>>((ref) async {
  final repo = ref.watch(groupRepositoryProvider);
  return repo.getAllGroups();
});

/// Single group provider
final groupProvider = FutureProvider.family<Group?, String>((ref, groupId) async {
  final repo = ref.watch(groupRepositoryProvider);
  return repo.getGroup(groupId);
});

/// Group list notifier for managing groups
class GroupListNotifier extends StateNotifier<AsyncValue<List<Group>>> {
  final GroupRepository _repository;
  final Ref _ref;

  GroupListNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    state = const AsyncValue.loading();
    try {
      final groups = await _repository.getAllGroups();
      state = AsyncValue.data(groups);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => _loadGroups();

  Future<Group> createGroup({
    required String name,
    String? description,
    List<String> characterIds = const [],
  }) async {
    final group = await _repository.createGroup(
      name: name,
      description: description,
      characterIds: characterIds,
    );
    await _loadGroups();
    return group;
  }

  Future<void> updateGroup(Group group) async {
    await _repository.updateGroup(group);
    await _loadGroups();
  }

  Future<void> deleteGroup(String id) async {
    await _repository.deleteGroup(id);
    await _loadGroups();
  }

  Future<void> addMember(String groupId, String characterId) async {
    await _repository.addMember(groupId, characterId);
    await _loadGroups();
  }

  /// Alias for addMember to match usage in UI
  Future<void> addMemberToGroup(String groupId, String characterId) async {
    await addMember(groupId, characterId);
  }

  Future<void> removeMember(String groupId, String characterId) async {
    await _repository.removeMember(groupId, characterId);
    await _loadGroups();
  }

  /// Alias for removeMember to match usage in UI
  Future<void> removeMemberFromGroup(String groupId, String characterId) async {
    await removeMember(groupId, characterId);
  }

  Future<void> toggleMemberMute(String groupId, String characterId) async {
    await _repository.toggleMemberMute(groupId, characterId);
    await _loadGroups();
  }

  Future<void> updateSettings(String groupId, GroupSettings settings) async {
    await _repository.updateSettings(groupId, settings);
    await _loadGroups();
  }

  /// Update a specific member's settings
  Future<void> updateMember(String groupId, GroupMember member) async {
    await _repository.updateMember(groupId, member);
    await _loadGroups();
  }
}

/// Provider for group list notifier
final groupListProvider = StateNotifierProvider<GroupListNotifier, AsyncValue<List<Group>>>((ref) {
  final repo = ref.watch(groupRepositoryProvider);
  return GroupListNotifier(repo, ref);
});

/// Active group for group chat
final activeGroupIdProvider = StateProvider<String?>((ref) => null);

/// Currently selected character in a group chat (for manual mode)
final selectedGroupCharacterIdProvider = StateProvider<String?>((ref) => null);