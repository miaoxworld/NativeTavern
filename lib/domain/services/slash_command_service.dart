import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents a slash command
class SlashCommand {
  final String name;
  final String description;
  final List<String> aliases;
  final String usage;
  final bool requiresArgument;

  const SlashCommand({
    required this.name,
    required this.description,
    this.aliases = const [],
    this.usage = '',
    this.requiresArgument = false,
  });
}

/// Result of parsing a slash command
class SlashCommandResult {
  final SlashCommand? command;
  final String? argument;
  final bool isCommand;
  final String? error;

  const SlashCommandResult({
    this.command,
    this.argument,
    this.isCommand = false,
    this.error,
  });

  factory SlashCommandResult.notACommand() {
    return const SlashCommandResult(isCommand: false);
  }

  factory SlashCommandResult.success(SlashCommand command, [String? argument]) {
    return SlashCommandResult(
      command: command,
      argument: argument,
      isCommand: true,
    );
  }

  factory SlashCommandResult.error(String error) {
    return SlashCommandResult(
      isCommand: true,
      error: error,
    );
  }
}

/// Available slash commands
class SlashCommands {
  static const continue_ = SlashCommand(
    name: 'continue',
    description: 'Continue the conversation without sending a message',
    aliases: ['cont', 'c'],
    usage: '/continue',
  );

  static const regenerate = SlashCommand(
    name: 'regenerate',
    description: 'Regenerate the last AI response',
    aliases: ['regen', 'r'],
    usage: '/regenerate',
  );

  static const swipe = SlashCommand(
    name: 'swipe',
    description: 'Swipe to a different response variant',
    aliases: ['sw'],
    usage: '/swipe [left|right|<number>]',
  );

  static const persona = SlashCommand(
    name: 'persona',
    description: 'Switch to a different persona',
    aliases: ['p'],
    usage: '/persona [name]',
    requiresArgument: false,
  );

  static const sys = SlashCommand(
    name: 'sys',
    description: 'Send a system message (narrator/instruction)',
    aliases: ['system', 'narrator'],
    usage: '/sys <message>',
    requiresArgument: true,
  );

  static const bg = SlashCommand(
    name: 'bg',
    description: 'Change the chat background',
    aliases: ['background'],
    usage: '/bg [url|clear]',
    requiresArgument: false,
  );

  static const help = SlashCommand(
    name: 'help',
    description: 'Show available commands',
    aliases: ['?', 'commands'],
    usage: '/help [command]',
  );

  static const clear = SlashCommand(
    name: 'clear',
    description: 'Clear all messages in the chat',
    aliases: ['cls'],
    usage: '/clear',
  );

  static const edit = SlashCommand(
    name: 'edit',
    description: 'Edit the last message',
    aliases: ['e'],
    usage: '/edit <new content>',
    requiresArgument: true,
  );

  static const delete = SlashCommand(
    name: 'delete',
    description: 'Delete the last message',
    aliases: ['del', 'd'],
    usage: '/delete [count]',
  );

  static const bookmark = SlashCommand(
    name: 'bookmark',
    description: 'Create a bookmark at the current point',
    aliases: ['bm', 'save'],
    usage: '/bookmark [name]',
  );

  static const note = SlashCommand(
    name: 'note',
    description: 'Set or view the author\'s note',
    aliases: ['an', 'authornote'],
    usage: '/note [content]',
  );

  static const List<SlashCommand> all = [
    continue_,
    regenerate,
    swipe,
    persona,
    sys,
    bg,
    help,
    clear,
    edit,
    delete,
    bookmark,
    note,
  ];
}

/// Service for parsing and handling slash commands
class SlashCommandService {
  /// Parse a message to check if it's a slash command
  SlashCommandResult parse(String input) {
    final trimmed = input.trim();
    
    // Check if it starts with /
    if (!trimmed.startsWith('/')) {
      return SlashCommandResult.notACommand();
    }

    // Extract command and argument
    final parts = trimmed.substring(1).split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) {
      return SlashCommandResult.error('Empty command');
    }

    final commandName = parts[0].toLowerCase();
    final argument = parts.length > 1 ? parts.sublist(1).join(' ') : null;

    // Find matching command
    for (final command in SlashCommands.all) {
      if (command.name == commandName || command.aliases.contains(commandName)) {
        // Check if argument is required
        if (command.requiresArgument && (argument == null || argument.isEmpty)) {
          return SlashCommandResult.error(
            'Command /${command.name} requires an argument.\nUsage: ${command.usage}',
          );
        }
        return SlashCommandResult.success(command, argument);
      }
    }

    return SlashCommandResult.error('Unknown command: /$commandName\nType /help for available commands.');
  }

  /// Get command suggestions based on partial input
  List<SlashCommand> getSuggestions(String input) {
    final trimmed = input.trim().toLowerCase();
    
    if (!trimmed.startsWith('/')) {
      return [];
    }

    final partial = trimmed.substring(1);
    if (partial.isEmpty) {
      return SlashCommands.all;
    }

    // Filter commands that match the partial input
    return SlashCommands.all.where((command) {
      if (command.name.startsWith(partial)) return true;
      return command.aliases.any((alias) => alias.startsWith(partial));
    }).toList();
  }

  /// Get help text for all commands
  String getHelpText() {
    final buffer = StringBuffer();
    buffer.writeln('Available Commands:');
    buffer.writeln();
    
    for (final command in SlashCommands.all) {
      buffer.writeln('/${command.name}');
      buffer.writeln('  ${command.description}');
      if (command.aliases.isNotEmpty) {
        buffer.writeln('  Aliases: ${command.aliases.map((a) => '/$a').join(', ')}');
      }
      buffer.writeln('  Usage: ${command.usage}');
      buffer.writeln();
    }
    
    return buffer.toString();
  }

  /// Get help text for a specific command
  String getCommandHelp(String commandName) {
    final name = commandName.toLowerCase();
    
    for (final command in SlashCommands.all) {
      if (command.name == name || command.aliases.contains(name)) {
        final buffer = StringBuffer();
        buffer.writeln('/${command.name}');
        buffer.writeln(command.description);
        if (command.aliases.isNotEmpty) {
          buffer.writeln('Aliases: ${command.aliases.map((a) => '/$a').join(', ')}');
        }
        buffer.writeln('Usage: ${command.usage}');
        return buffer.toString();
      }
    }
    
    return 'Unknown command: $commandName';
  }
}

/// Provider for slash command service
final slashCommandServiceProvider = Provider<SlashCommandService>((ref) {
  return SlashCommandService();
});