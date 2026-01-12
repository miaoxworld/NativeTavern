import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';

/// A widget that displays text with long-press to copy functionality.
/// Shows a snackbar when text is copied to clipboard.
class CopyableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool selectable;
  final String? copyMessage;

  const CopyableText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.selectable = false,
    this.copyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (selectable) {
      return SelectableText(
        text,
        style: style,
        maxLines: maxLines,
        onTap: () {},
      );
    }

    return GestureDetector(
      onLongPress: () => _copyToClipboard(context),
      child: Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    if (text.isEmpty) return;
    
    Clipboard.setData(ClipboardData(text: text));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(copyMessage ?? 'Copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// A ListTile with copyable subtitle text.
/// Long-press on the tile to copy the subtitle text.
class CopyableListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;
  final String? copyMessage;

  const CopyableListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.copyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: AppTheme.textSecondary,
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      enabled: enabled,
      onLongPress: subtitle != null && subtitle!.isNotEmpty
          ? () => _copyToClipboard(context)
          : null,
    );
  }

  void _copyToClipboard(BuildContext context) {
    if (subtitle == null || subtitle!.isEmpty) return;
    
    Clipboard.setData(ClipboardData(text: subtitle!));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(copyMessage ?? 'Copied: $subtitle'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// A SwitchListTile with copyable title/subtitle.
class CopyableSwitchListTile extends StatelessWidget {
  final Widget? secondary;
  final Widget? title;
  final String? titleText;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? copyMessage;

  const CopyableSwitchListTile({
    super.key,
    this.secondary,
    this.title,
    this.titleText,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.copyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _copyToClipboard(context),
      child: SwitchListTile(
        secondary: secondary,
        title: title ?? (titleText != null ? Text(titleText!) : null),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    final textToCopy = subtitle ?? titleText ?? '';
    if (textToCopy.isEmpty) return;
    
    Clipboard.setData(ClipboardData(text: textToCopy));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(copyMessage ?? 'Copied: $textToCopy'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}