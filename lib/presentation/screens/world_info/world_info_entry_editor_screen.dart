import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/data/models/world_info.dart';
import 'package:native_tavern/presentation/providers/world_info_providers.dart';
import 'package:native_tavern/presentation/providers/character_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Enhanced World Info Entry Editor Screen with all new fields
class WorldInfoEntryEditorScreen extends ConsumerStatefulWidget {
  final String worldInfoId;
  final WorldInfoEntry? entry; // null for creating new entry

  const WorldInfoEntryEditorScreen({
    super.key,
    required this.worldInfoId,
    this.entry,
  });

  @override
  ConsumerState<WorldInfoEntryEditorScreen> createState() => _WorldInfoEntryEditorScreenState();
}

class _WorldInfoEntryEditorScreenState extends ConsumerState<WorldInfoEntryEditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _keysController;
  late TextEditingController _secondaryKeysController;
  late TextEditingController _contentController;
  late TextEditingController _commentController;
  late TextEditingController _groupController;
  
  // Settings
  WorldInfoPosition _position = WorldInfoPosition.before;
  int _depth = 4;
  int _insertionOrder = 0;
  int _scanDepth = 0;
  bool _enabled = true;
  bool _constant = true;
  bool _selective = false;
  bool _caseSensitive = false;
  bool _matchWholeWords = false;
  bool _preventRecursion = false;
  bool _excludeRecursion = false;
  bool _delayUntilRecursion = false;
  bool _useGroupScoring = false;
  int _groupWeight = 0;
  int _groupOverride = 0;
  bool _useProbability = false;
  int _probability = 100;
  bool _isFavorite = false;
  
  // Advanced fields
  WorldInfoRole _role = WorldInfoRole.system;
  WorldInfoTimedEffects _timedEffects = const WorldInfoTimedEffects();
  WorldInfoCharacterFilter _characterFilter = const WorldInfoCharacterFilter();
  
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // Initialize controllers with existing data
    final entry = widget.entry;
    _keysController = TextEditingController(text: entry?.keys.join(', ') ?? '');
    _secondaryKeysController = TextEditingController(text: entry?.secondaryKeys.join(', ') ?? '');
    _contentController = TextEditingController(text: entry?.content ?? '');
    _commentController = TextEditingController(text: entry?.comment ?? '');
    _groupController = TextEditingController(text: entry?.group ?? '');
    
    if (entry != null) {
      _position = entry.position;
      _depth = entry.depth;
      _insertionOrder = entry.insertionOrder;
      _scanDepth = entry.scanDepth;
      _enabled = entry.enabled;
      _constant = entry.constant;
      _selective = entry.selective;
      _caseSensitive = entry.caseSensitive;
      _matchWholeWords = entry.matchWholeWords;
      _preventRecursion = entry.preventRecursion;
      _excludeRecursion = entry.excludeRecursion;
      _delayUntilRecursion = entry.delayUntilRecursion;
      _useGroupScoring = entry.useGroupScoring;
      _groupWeight = entry.groupWeight;
      _groupOverride = entry.groupOverride;
      _useProbability = entry.useProbability;
      _probability = entry.probability;
      _isFavorite = entry.isFavorite;
      _role = entry.role;
      _timedEffects = entry.timedEffects;
      _characterFilter = entry.characterFilter;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _keysController.dispose();
    _secondaryKeysController.dispose();
    _contentController.dispose();
    _commentController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Create Entry' : 'Edit Entry'),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.star : Icons.star_border),
            tooltip: 'Favorite',
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          Switch(
            value: _enabled,
            onChanged: (value) => setState(() => _enabled = value),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save',
            onPressed: _isSaving ? null : _save,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Basic', icon: Icon(Icons.edit)),
            Tab(text: 'Insertion', icon: Icon(Icons.settings)),
            Tab(text: 'Filters', icon: Icon(Icons.filter_list)),
            Tab(text: 'Advanced', icon: Icon(Icons.tune)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBasicTab(),
          _buildInsertionTab(),
          _buildFiltersTab(),
          _buildAdvancedTab(),
        ],
      ),
    );
  }

  Widget _buildBasicTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _keysController,
            decoration: const InputDecoration(
              labelText: 'Keywords (comma-separated)',
              hintText: 'dragon, magic, sword',
              border: OutlineInputBorder(),
              helperText: 'Entry activates when these keywords are found',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _secondaryKeysController,
            decoration: const InputDecoration(
              labelText: 'Secondary Keys (optional)',
              hintText: 'fire, ice',
              border: OutlineInputBorder(),
              helperText: 'Both primary and secondary must match for selective',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Comment (optional)',
              hintText: 'Note for this entry',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Content',
              hintText: 'Context to inject when matches',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 10,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Constant'),
            subtitle: const Text('Always include in prompt'),
            value: _constant,
            onChanged: (v) => setState(() => _constant = v),
          ),
          SwitchListTile(
            title: const Text('Selective'),
            subtitle: const Text('Requires secondary key'),
            value: _selective,
            onChanged: (v) => setState(() => _selective = v),
          ),
        ],
      ),
    );
  }

  Widget _buildInsertionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<WorldInfoPosition>(
            value: _position,
            decoration: const InputDecoration(
              labelText: 'Position',
              border: OutlineInputBorder(),
            ),
            items: WorldInfoPosition.values.map((pos) {
              return DropdownMenuItem(
                value: pos,
                child: Text(_formatEnumName(pos.name)),
              );
            }).toList(),
            onChanged: (v) => setState(() => _position = v!),
          ),
          const SizedBox(height: 16),
          if (_position == WorldInfoPosition.atDepth) ...[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Depth',
                border: OutlineInputBorder(),
                helperText: 'Depth in chat history',
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: _depth.toString()),
              onChanged: (v) => _depth = int.tryParse(v) ?? 4,
            ),
            const SizedBox(height: 16),
          ],
          TextField(
            decoration: const InputDecoration(
              labelText: 'Insertion Order',
              border: OutlineInputBorder(),
              helperText: 'Lower values insert first',
            ),
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: _insertionOrder.toString()),
            onChanged: (v) => _insertionOrder = int.tryParse(v) ?? 0,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Scan Depth',
              border: OutlineInputBorder(),
              helperText: 'How many messages to scan (0 = use default)',
            ),
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: _scanDepth.toString()),
            onChanged: (v) => _scanDepth = int.tryParse(v) ?? 0,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<WorldInfoRole>(
            value: _role,
            decoration: const InputDecoration(
              labelText: 'Message Role',
              border: OutlineInputBorder(),
              helperText: 'Role for the injected content',
            ),
            items: WorldInfoRole.values.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Text(_formatEnumName(role.name)),
              );
            }).toList(),
            onChanged: (v) => setState(() => _role = v!),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text('Case Sensitive'),
            subtitle: const Text('Match keywords with exact case'),
            value: _caseSensitive,
            onChanged: (v) => setState(() => _caseSensitive = v),
          ),
          SwitchListTile(
            title: const Text('Match Whole Words'),
            subtitle: const Text('Only match complete words'),
            value: _matchWholeWords,
            onChanged: (v) => setState(() => _matchWholeWords = v),
          ),
          const Divider(height: 32),
          const Text(
            'Recursion Control',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Prevent Recursion'),
            subtitle: const Text("Don't scan this entry's content"),
            value: _preventRecursion,
            onChanged: (v) => setState(() => _preventRecursion = v),
          ),
          SwitchListTile(
            title: const Text('Exclude Recursion'),
            subtitle: const Text("Don't trigger from other entries"),
            value: _excludeRecursion,
            onChanged: (v) => setState(() => _excludeRecursion = v),
          ),
          SwitchListTile(
            title: const Text('Delay Until Recursion'),
            subtitle: const Text('Only activate after recursive scan'),
            value: _delayUntilRecursion,
            onChanged: (v) => setState(() => _delayUntilRecursion = v),
          ),
          const Divider(height: 32),
          const Text(
            'Character Filter',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildCharacterFilterSection(),
        ],
      ),
    );
  }

  Widget _buildAdvancedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Group Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _groupController,
            decoration: const InputDecoration(
              labelText: 'Group Name',
              border: OutlineInputBorder(),
              helperText: 'Entries with same group are mutually exclusive',
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Use Group Scoring'),
            value: _useGroupScoring,
            onChanged: (v) => setState(() => _useGroupScoring = v),
          ),
          if (_useGroupScoring) ...[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Group Weight',
                border: OutlineInputBorder(),
                helperText: 'Weight for group selection',
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: _groupWeight.toString()),
              onChanged: (v) => _groupWeight = int.tryParse(v) ?? 0,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Group Override',
                border: OutlineInputBorder(),
                helperText: 'Priority within group (higher = more priority)',
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: _groupOverride.toString()),
              onChanged: (v) => _groupOverride = int.tryParse(v) ?? 0,
            ),
          ],
          const Divider(height: 32),
          const Text(
            'Probability',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Use Probability'),
            subtitle: const Text('Randomly activate based on probability'),
            value: _useProbability,
            onChanged: (v) => setState(() => _useProbability = v),
          ),
          if (_useProbability) ...[
            Slider(
              value: _probability.toDouble(),
              min: 0,
              max: 100,
              divisions: 20,
              label: '$_probability%',
              onChanged: (v) => setState(() => _probability = v.toInt()),
            ),
            Text(
              'Probability: $_probability%',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
          const Divider(height: 32),
          const Text(
            'Timed Effects',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildTimedEffectsSection(),
        ],
      ),
    );
  }

  Widget _buildCharacterFilterSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<WorldInfoCharacterFilterType>(
              value: _characterFilter.type,
              decoration: const InputDecoration(
                labelText: 'Filter Type',
                border: OutlineInputBorder(),
              ),
              items: WorldInfoCharacterFilterType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_formatEnumName(type.name)),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  _characterFilter = _characterFilter.copyWith(type: v!);
                });
              },
            ),
            if (_characterFilter.type != WorldInfoCharacterFilterType.none) ...[
              const SizedBox(height: 16),
              const Text(
                'Character IDs (comma-separated):',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'char_123, char_456',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: _characterFilter.characterIds.join(', '),
                ),
                onChanged: (v) {
                  final ids = v.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
                  setState(() {
                    _characterFilter = _characterFilter.copyWith(characterIds: ids);
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimedEffectsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Sticky Duration',
                border: OutlineInputBorder(),
                helperText: 'Messages to stay active after trigger (0 = not sticky)',
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: _timedEffects.sticky.toString()),
              onChanged: (v) {
                setState(() {
                  _timedEffects = _timedEffects.copyWith(sticky: int.tryParse(v) ?? 0);
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Cooldown',
                border: OutlineInputBorder(),
                helperText: 'Messages to wait before can trigger again (0 = no cooldown)',
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: _timedEffects.cooldown.toString()),
              onChanged: (v) {
                setState(() {
                  _timedEffects = _timedEffects.copyWith(cooldown: int.tryParse(v) ?? 0);
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Delay',
                border: OutlineInputBorder(),
                helperText: 'Messages before entry can trigger (0 = no delay)',
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: _timedEffects.delay.toString()),
              onChanged: (v) {
                setState(() {
                  _timedEffects = _timedEffects.copyWith(delay: int.tryParse(v) ?? 0);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final keys = _keysController.text
        .split(',')
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty)
        .toList();

    final content = _contentController.text.trim();
    if (content.isEmpty) {
      _showError('Please enter content');
      return;
    }

    final secondaryKeys = _secondaryKeysController.text
        .split(',')
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty)
        .toList();

    final group = _groupController.text.trim();

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final entry = WorldInfoEntry(
        id: widget.entry?.id ?? now.millisecondsSinceEpoch.toString(),
        worldInfoId: widget.worldInfoId,
        keys: keys,
        secondaryKeys: secondaryKeys,
        content: content,
        comment: _commentController.text.trim(),
        enabled: _enabled,
        constant: keys.isEmpty ? true : _constant,
        selective: _selective,
        insertionOrder: _insertionOrder,
        caseSensitive: _caseSensitive,
        matchWholeWords: _matchWholeWords,
        useGroupScoring: _useGroupScoring,
        automationId: false,
        probability: _probability,
        position: _position,
        depth: _depth,
        group: group.isEmpty ? null : group,
        groupWeight: _groupWeight,
        preventRecursion: _preventRecursion,
        delayUntilRecursion: _delayUntilRecursion,
        scanDepth: _scanDepth,
        role: _role,
        timedEffects: _timedEffects,
        characterFilter: _characterFilter,
        groupOverride: _groupOverride,
        excludeRecursion: _excludeRecursion,
        useProbability: _useProbability,
        vectorized: null,
        displayIndex: widget.entry?.displayIndex ?? 0,
        isFavorite: _isFavorite,
      );

      if (widget.entry == null) {
        await ref.read(worldInfoNotifierProvider.notifier).addEntry(
          worldInfoId: widget.worldInfoId,
          keys: entry.keys,
          content: entry.content,
          comment: entry.comment,
          secondaryKeys: entry.secondaryKeys,
          position: entry.position,
          constant: entry.constant,
          selective: entry.selective,
          insertionOrder: entry.insertionOrder,
        );
      } else {
        await ref.read(worldInfoNotifierProvider.notifier).updateEntry(entry);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showError('Failed to save: $e');
      setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  String _formatEnumName(String name) {
    return name
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim()
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
