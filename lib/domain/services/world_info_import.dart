import 'package:native_tavern/data/models/world_info.dart';

/// Parses SillyTavern (and NativeTavern) world info JSON into full
/// [WorldInfoEntry] objects, preserving behavioral fields: constant,
/// position, order, probability, timed effects, recursion flags, role, etc.
///
/// Pure functions - no I/O - so import fidelity is unit-testable.
class WorldInfoImport {
  /// Parse all entries from a world info book JSON.
  /// [worldInfoId] is stamped on every entry.
  static List<WorldInfoEntry> parseEntries(
    Map<String, dynamic> json,
    String worldInfoId, {
    String Function()? idGenerator,
  }) {
    final rawEntries = <Map<String, dynamic>>[];

    final entriesValue = json['entries'];
    if (entriesValue is Map) {
      // SillyTavern format: entries is {uid: entry}
      for (final value in entriesValue.values) {
        if (value is Map<String, dynamic>) rawEntries.add(value);
      }
    } else if (entriesValue is List) {
      // NativeTavern/V2-card format: entries is a list
      for (final value in entriesValue) {
        if (value is Map<String, dynamic>) rawEntries.add(value);
      }
    }

    var counter = 0;
    return rawEntries.map((raw) {
      counter++;
      final id = idGenerator?.call() ??
          '${DateTime.now().millisecondsSinceEpoch}_$counter';
      return parseEntry(raw, worldInfoId, id);
    }).toList();
  }

  /// Parse a single ST/NT entry into a full [WorldInfoEntry]
  static WorldInfoEntry parseEntry(
    Map<String, dynamic> data,
    String worldInfoId,
    String id,
  ) {
    final position = _parsePosition(data['position']);
    return WorldInfoEntry(
      id: id,
      worldInfoId: worldInfoId,
      keys: _stringList(data['keys'] ?? data['key']),
      secondaryKeys: _stringList(data['secondaryKeys'] ??
          data['secondary_keys'] ??
          data['keysecondary']),
      content: data['content']?.toString() ?? '',
      comment: data['comment']?.toString() ?? '',
      enabled: !(_boolOf(data['disable']) ?? false) &&
          (_boolOf(data['enabled']) ?? true),
      constant: _boolOf(data['constant']) ?? false,
      selective: _boolOf(data['selective']) ?? false,
      insertionOrder: _intOf(data['insertionOrder'] ?? data['order']) ?? 100,
      caseSensitive: _boolOf(data['caseSensitive']) ?? false,
      matchWholeWords: _boolOf(data['matchWholeWords']) ?? false,
      useGroupScoring: _boolOf(data['useGroupScoring']) ?? false,
      probability: _intOf(data['probability']) ?? 100,
      useProbability: _boolOf(data['useProbability']) ??
          ((_intOf(data['probability']) ?? 100) < 100),
      position: position,
      depth: _intOf(data['depth']) ?? 4,
      group: (data['group']?.toString().isNotEmpty ?? false)
          ? data['group'].toString()
          : null,
      groupWeight: _intOf(data['groupWeight']) ?? 100,
      groupOverride: _boolOf(data['groupOverride']) == true ? 1 : 0,
      preventRecursion: _boolOf(data['preventRecursion']) ?? false,
      delayUntilRecursion: _boolOf(data['delayUntilRecursion']) ?? false,
      excludeRecursion: _boolOf(data['excludeRecursion']) ?? false,
      scanDepth: _intOf(data['scanDepth']) ?? 0,
      role: _parseRole(data['role']),
      timedEffects: WorldInfoTimedEffects(
        sticky: _intOf(data['sticky']) ?? 0,
        cooldown: _intOf(data['cooldown']) ?? 0,
        delay: _intOf(data['delay']) ?? 0,
      ),
      displayIndex: _intOf(data['displayIndex']) ?? 0,
      extensions: data['extensions'] is Map<String, dynamic>
          ? data['extensions'] as Map<String, dynamic>
          : const {},
    );
  }

  static WorldInfoPosition _parsePosition(dynamic value) {
    final index = _intOf(value) ?? 0;
    if (index >= 0 && index < WorldInfoPosition.values.length) {
      return WorldInfoPosition.values[index];
    }
    return WorldInfoPosition.before;
  }

  static WorldInfoRole _parseRole(dynamic value) {
    final index = _intOf(value);
    if (index != null && index >= 0 && index < WorldInfoRole.values.length) {
      return WorldInfoRole.values[index];
    }
    return WorldInfoRole.system;
  }

  static List<String> _stringList(dynamic value) {
    if (value == null) return const [];
    if (value is List) {
      return value
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    if (value is String) {
      return value
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return const [];
  }

  static bool? _boolOf(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true' || lower == '1') return true;
      if (lower == 'false' || lower == '0') return false;
    }
    return null;
  }

  static int? _intOf(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
