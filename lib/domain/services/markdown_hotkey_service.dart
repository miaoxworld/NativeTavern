import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Service for handling markdown formatting hotkeys in text input
class MarkdownHotkeyService {
  /// Apply markdown formatting to the selected text or insert at cursor
  /// 
  /// Returns the new text and selection after applying the format
  static TextEditingValue applyFormat({
    required TextEditingValue value,
    required MarkdownFormat format,
  }) {
    final text = value.text;
    final selection = value.selection;
    
    // Get the selected text
    final selectedText = selection.textInside(text);
    
    // Get the format markers
    final (prefix, suffix) = format.markers;
    
    String newText;
    TextSelection newSelection;
    
    if (selection.isCollapsed) {
      // No selection - insert markers and place cursor between them
      final insertPosition = selection.baseOffset;
      newText = text.substring(0, insertPosition) +
          prefix +
          suffix +
          text.substring(insertPosition);
      newSelection = TextSelection.collapsed(
        offset: insertPosition + prefix.length,
      );
    } else {
      // Has selection - wrap selected text with markers
      final start = selection.start;
      final end = selection.end;
      
      // Check if already formatted - if so, remove formatting
      final beforeSelection = text.substring(0, start);
      final afterSelection = text.substring(end);
      
      if (beforeSelection.endsWith(prefix) && afterSelection.startsWith(suffix)) {
        // Remove existing formatting
        newText = beforeSelection.substring(0, beforeSelection.length - prefix.length) +
            selectedText +
            afterSelection.substring(suffix.length);
        newSelection = TextSelection(
          baseOffset: start - prefix.length,
          extentOffset: end - prefix.length,
        );
      } else {
        // Add formatting
        newText = text.substring(0, start) +
            prefix +
            selectedText +
            suffix +
            text.substring(end);
        newSelection = TextSelection(
          baseOffset: start + prefix.length,
          extentOffset: end + prefix.length,
        );
      }
    }
    
    return TextEditingValue(
      text: newText,
      selection: newSelection,
    );
  }
  
  /// Insert a markdown element at the cursor position
  static TextEditingValue insertElement({
    required TextEditingValue value,
    required String element,
    int cursorOffset = 0,
  }) {
    final text = value.text;
    final selection = value.selection;
    final insertPosition = selection.baseOffset;
    
    final newText = text.substring(0, insertPosition) +
        element +
        text.substring(insertPosition);
    
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: insertPosition + element.length + cursorOffset,
      ),
    );
  }
  
  /// Check if a keyboard event matches a markdown hotkey
  static MarkdownFormat? getFormatFromKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return null;
    
    final isCtrlOrCmd = HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;
    final isShift = HardwareKeyboard.instance.isShiftPressed;
    
    if (!isCtrlOrCmd) return null;
    
    // Ctrl/Cmd + B = Bold
    if (event.logicalKey == LogicalKeyboardKey.keyB && !isShift) {
      return MarkdownFormat.bold;
    }
    
    // Ctrl/Cmd + I = Italic
    if (event.logicalKey == LogicalKeyboardKey.keyI && !isShift) {
      return MarkdownFormat.italic;
    }
    
    // Ctrl/Cmd + U = Underline (using HTML since markdown doesn't have native underline)
    if (event.logicalKey == LogicalKeyboardKey.keyU && !isShift) {
      return MarkdownFormat.underline;
    }
    
    // Ctrl/Cmd + Shift + S = Strikethrough
    if (event.logicalKey == LogicalKeyboardKey.keyS && isShift) {
      return MarkdownFormat.strikethrough;
    }
    
    // Ctrl/Cmd + ` = Inline code
    if (event.logicalKey == LogicalKeyboardKey.backquote && !isShift) {
      return MarkdownFormat.inlineCode;
    }
    
    // Ctrl/Cmd + Shift + ` = Code block
    if (event.logicalKey == LogicalKeyboardKey.backquote && isShift) {
      return MarkdownFormat.codeBlock;
    }
    
    // Ctrl/Cmd + K = Link
    if (event.logicalKey == LogicalKeyboardKey.keyK && !isShift) {
      return MarkdownFormat.link;
    }
    
    // Ctrl/Cmd + Shift + Q = Quote
    if (event.logicalKey == LogicalKeyboardKey.keyQ && isShift) {
      return MarkdownFormat.quote;
    }
    
    return null;
  }
}

/// Markdown formatting types
enum MarkdownFormat {
  bold,
  italic,
  underline,
  strikethrough,
  inlineCode,
  codeBlock,
  link,
  quote,
  heading1,
  heading2,
  heading3,
  bulletList,
  numberedList,
  horizontalRule,
}

extension MarkdownFormatExtension on MarkdownFormat {
  /// Get the prefix and suffix markers for this format
  (String prefix, String suffix) get markers {
    switch (this) {
      case MarkdownFormat.bold:
        return ('**', '**');
      case MarkdownFormat.italic:
        return ('*', '*');
      case MarkdownFormat.underline:
        return ('<u>', '</u>');
      case MarkdownFormat.strikethrough:
        return ('~~', '~~');
      case MarkdownFormat.inlineCode:
        return ('`', '`');
      case MarkdownFormat.codeBlock:
        return ('```\n', '\n```');
      case MarkdownFormat.link:
        return ('[', '](url)');
      case MarkdownFormat.quote:
        return ('> ', '');
      case MarkdownFormat.heading1:
        return ('# ', '');
      case MarkdownFormat.heading2:
        return ('## ', '');
      case MarkdownFormat.heading3:
        return ('### ', '');
      case MarkdownFormat.bulletList:
        return ('- ', '');
      case MarkdownFormat.numberedList:
        return ('1. ', '');
      case MarkdownFormat.horizontalRule:
        return ('---\n', '');
    }
  }
  
  /// Get the display name for this format
  String get displayName {
    switch (this) {
      case MarkdownFormat.bold:
        return 'Bold';
      case MarkdownFormat.italic:
        return 'Italic';
      case MarkdownFormat.underline:
        return 'Underline';
      case MarkdownFormat.strikethrough:
        return 'Strikethrough';
      case MarkdownFormat.inlineCode:
        return 'Inline Code';
      case MarkdownFormat.codeBlock:
        return 'Code Block';
      case MarkdownFormat.link:
        return 'Link';
      case MarkdownFormat.quote:
        return 'Quote';
      case MarkdownFormat.heading1:
        return 'Heading 1';
      case MarkdownFormat.heading2:
        return 'Heading 2';
      case MarkdownFormat.heading3:
        return 'Heading 3';
      case MarkdownFormat.bulletList:
        return 'Bullet List';
      case MarkdownFormat.numberedList:
        return 'Numbered List';
      case MarkdownFormat.horizontalRule:
        return 'Horizontal Rule';
    }
  }
  
  /// Get the keyboard shortcut hint for this format
  String? get shortcutHint {
    switch (this) {
      case MarkdownFormat.bold:
        return '⌘B';
      case MarkdownFormat.italic:
        return '⌘I';
      case MarkdownFormat.underline:
        return '⌘U';
      case MarkdownFormat.strikethrough:
        return '⌘⇧S';
      case MarkdownFormat.inlineCode:
        return '⌘`';
      case MarkdownFormat.codeBlock:
        return '⌘⇧`';
      case MarkdownFormat.link:
        return '⌘K';
      case MarkdownFormat.quote:
        return '⌘⇧Q';
      default:
        return null;
    }
  }
  
  /// Get the icon for this format
  IconData get icon {
    switch (this) {
      case MarkdownFormat.bold:
        return Icons.format_bold;
      case MarkdownFormat.italic:
        return Icons.format_italic;
      case MarkdownFormat.underline:
        return Icons.format_underline;
      case MarkdownFormat.strikethrough:
        return Icons.format_strikethrough;
      case MarkdownFormat.inlineCode:
        return Icons.code;
      case MarkdownFormat.codeBlock:
        return Icons.integration_instructions;
      case MarkdownFormat.link:
        return Icons.link;
      case MarkdownFormat.quote:
        return Icons.format_quote;
      case MarkdownFormat.heading1:
        return Icons.title;
      case MarkdownFormat.heading2:
        return Icons.title;
      case MarkdownFormat.heading3:
        return Icons.title;
      case MarkdownFormat.bulletList:
        return Icons.format_list_bulleted;
      case MarkdownFormat.numberedList:
        return Icons.format_list_numbered;
      case MarkdownFormat.horizontalRule:
        return Icons.horizontal_rule;
    }
  }
}