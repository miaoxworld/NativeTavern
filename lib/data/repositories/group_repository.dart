import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/database/database.dart' hide Group;
import 'package:native_tavern/data/database/database.dart' as db;
import 'package:native_tavern/data/models/group.dart';
import 'package:native_tavern/core/services/initialization_service.dart';
import 'package:uuid/uuid.dart';

/// Provider for group repository
final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return GroupRepository(database);
});

/// Repository for managing group data
class GroupRepository {
  final AppDatabase _db;
  static const _uuid = Uuid();

  GroupRepository(this._db);

  /// Get all groups
  Future<List<Group>> getAllGroups() async {
    final rows = await _db.select(_db.groups).get();
    return rows.map(_groupFromRow).toList();
  }

  /// Get group by ID
  Future<Group?> getGroup(String id) async {
    final row = await (_db.select(_db.groups)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _groupFromRow(row) : null;
  }

  /// Create a new group
  Future<Group> createGroup({
    required String name,
    String? description,
    List<String> characterIds = const [],
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    final members = characterIds.asMap().entries.map((e) {
      return GroupMember(
        characterId: e.value,
        insertionOrder: e.key,
      );
    }).toList();

    final group = Group(
      id: id,
      name: name,
      description: description,
      members: members,
      createdAt: now,
      modifiedAt: now,
    );

    await _db.into(_db.groups).insert(_groupToCompanion(group));
    return group;
  }

  /// Update an existing group
  Future<Group> updateGroup(Group group) async {
    final updatedGroup = group.copyWith(modifiedAt: DateTime.now());
    await (_db.update(_db.groups)..where((t) => t.id.equals(group.id)))
        .write(_groupToCompanion(updatedGroup));
    return updatedGroup;
  }

  /// Delete a group
  Future<void> deleteGroup(String id) async {
    // Delete associated chats first
    await (_db.delete(_db.chats)..where((t) => t.groupId.equals(id))).go();
    // Delete the group
    await (_db.delete(_db.groups)..where((t) => t.id.equals(id))).go();
  }

  /// Add a character to a group
  Future<Group> addMember(String groupId, String characterId) async {
    final group = await getGroup(groupId);
    if (group == null) throw Exception('Group not found');

    if (group.members.any((m) => m.characterId == characterId)) {
      return group; // Already a member
    }

    final newMember = GroupMember(
      characterId: characterId,
      insertionOrder: group.members.length,
    );

    return updateGroup(group.copyWith(
      members: [...group.members, newMember],
    ));
  }

  /// Remove a character from a group
  Future<Group> removeMember(String groupId, String characterId) async {
    final group = await getGroup(groupId);
    if (group == null) throw Exception('Group not found');

    return updateGroup(group.copyWith(
      members: group.members.where((m) => m.characterId != characterId).toList(),
    ));
  }

  /// Update a member's settings
  Future<Group> updateMember(String groupId, GroupMember member) async {
    final group = await getGroup(groupId);
    if (group == null) throw Exception('Group not found');

    final members = group.members.map((m) {
      if (m.characterId == member.characterId) {
        return member;
      }
      return m;
    }).toList();

    return updateGroup(group.copyWith(members: members));
  }

  /// Mute/unmute a member
  Future<Group> toggleMemberMute(String groupId, String characterId) async {
    final group = await getGroup(groupId);
    if (group == null) throw Exception('Group not found');

    final members = group.members.map((m) {
      if (m.characterId == characterId) {
        return m.copyWith(isMuted: !m.isMuted);
      }
      return m;
    }).toList();

    return updateGroup(group.copyWith(members: members));
  }

  /// Update group settings
  Future<Group> updateSettings(String groupId, GroupSettings settings) async {
    final group = await getGroup(groupId);
    if (group == null) throw Exception('Group not found');

    return updateGroup(group.copyWith(settings: settings));
  }

  /// Reorder members
  Future<Group> reorderMembers(String groupId, List<String> orderedCharacterIds) async {
    final group = await getGroup(groupId);
    if (group == null) throw Exception('Group not found');

    final members = orderedCharacterIds.asMap().entries.map((e) {
      final existing = group.members.firstWhere(
        (m) => m.characterId == e.value,
        orElse: () => GroupMember(characterId: e.value),
      );
      return existing.copyWith(insertionOrder: e.key);
    }).toList();

    return updateGroup(group.copyWith(members: members));
  }

  // Private helpers

  Group _groupFromRow(db.Group row) {
    return Group(
      id: row.id,
      name: row.name,
      description: row.description,
      members: _parseMembersJson(row.membersJson),
      settings: _parseSettingsJson(row.settingsJson),
      avatarPath: row.avatarPath,
      createdAt: row.createdAt,
      modifiedAt: row.modifiedAt,
    );
  }

  GroupsCompanion _groupToCompanion(Group group) {
    return GroupsCompanion(
      id: Value(group.id),
      name: Value(group.name),
      description: Value(group.description),
      membersJson: Value(jsonEncode(group.members.map((m) => m.toJson()).toList())),
      settingsJson: Value(jsonEncode(group.settings.toJson())),
      avatarPath: Value(group.avatarPath),
      createdAt: Value(group.createdAt),
      modifiedAt: Value(group.modifiedAt),
    );
  }

  List<GroupMember> _parseMembersJson(String json) {
    try {
      final list = jsonDecode(json) as List;
      return list.map((m) => GroupMember.fromJson(m as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  GroupSettings _parseSettingsJson(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return GroupSettings.fromJson(map);
    } catch (_) {
      return const GroupSettings();
    }
  }
}