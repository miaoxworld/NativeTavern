import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// View mode for character list display
enum CharacterViewMode {
  /// List view
  list,

  /// Grid view with 2 columns (medium size)
  grid,

  /// Compact grid view with 3 columns (small size)
  compactGrid,
}

extension CharacterViewModeExtension on CharacterViewMode {
  /// Get the next view mode when cycling through modes
  CharacterViewMode get next {
    switch (this) {
      case CharacterViewMode.list:
        return CharacterViewMode.grid;
      case CharacterViewMode.grid:
        return CharacterViewMode.compactGrid;
      case CharacterViewMode.compactGrid:
        return CharacterViewMode.list;
    }
  }

  /// Get the icon for this view mode
  String get iconName {
    switch (this) {
      case CharacterViewMode.list:
        return 'list';
      case CharacterViewMode.grid:
        return 'grid_view';
      case CharacterViewMode.compactGrid:
        return 'view_compact';
    }
  }

  /// Get display name for this view mode
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case CharacterViewMode.list:
        return l10n.listView;
      case CharacterViewMode.grid:
        return l10n.gridView;
      case CharacterViewMode.compactGrid:
        return l10n.compactGridView;
    }
  }
}
