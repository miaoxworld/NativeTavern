import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/domain/services/debug_log_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';

/// Floating debug ball widget that can be dragged around
class DebugFloatingBall extends StatefulWidget {
  final VoidCallback onTap;
  final int logCount;

  const DebugFloatingBall({
    super.key,
    required this.onTap,
    required this.logCount,
  });

  @override
  State<DebugFloatingBall> createState() => _DebugFloatingBallState();
}

class _DebugFloatingBallState extends State<DebugFloatingBall> {
  Offset _position = const Offset(20, 100);
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanStart: (_) => setState(() => _isDragging = true),
        onPanUpdate: (details) {
          setState(() {
            _position = Offset(
              _position.dx + details.delta.dx,
              _position.dy + details.delta.dy,
            );
          });
        },
        onPanEnd: (_) => setState(() => _isDragging = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: _isDragging
                ? Colors.orange.shade700
                : Colors.orange.shade600,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: _isDragging ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.bug_report,
                color: Colors.white,
                size: 28,
              ),
              if (widget.logCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      widget.logCount > 99 ? '99+' : '${widget.logCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Log viewer dialog/panel
class DebugLogViewer extends ConsumerStatefulWidget {
  const DebugLogViewer({super.key});

  @override
  ConsumerState<DebugLogViewer> createState() => _DebugLogViewerState();
}

class _DebugLogViewerState extends ConsumerState<DebugLogViewer> {
  final ScrollController _scrollController = ScrollController();
  bool _autoScroll = true;
  String _filterLevel = 'ALL';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_autoScroll && _scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    }
  }

  List<LogEntry> _filterLogs(List<LogEntry> logs) {
    return logs.where((log) {
      // Filter by level
      if (_filterLevel != 'ALL' && log.level != _filterLevel) {
        return false;
      }
      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return log.message.toLowerCase().contains(query) ||
            (log.source?.toLowerCase().contains(query) ?? false) ||
            (log.error?.toLowerCase().contains(query) ?? false);
      }
      return true;
    }).toList();
  }

  Color _getLevelColor(String level) {
    switch (level.toUpperCase()) {
      case 'ERROR':
        return Colors.red;
      case 'WARNING':
        return Colors.orange;
      case 'INFO':
        return Colors.blue;
      case 'DEBUG':
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final logs = ref.watch(currentLogsProvider);
    final filteredLogs = _filterLogs(logs);

    // Auto-scroll when new logs arrive
    ref.listen(logEntriesStreamProvider, (_, __) {
      _scrollToBottom();
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.bug_report, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      l10n.debugLog,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Auto-scroll toggle
                    IconButton(
                      icon: Icon(
                        _autoScroll ? Icons.vertical_align_bottom : Icons.vertical_align_center,
                        color: _autoScroll ? Colors.orange : Colors.grey,
                      ),
                      tooltip: l10n.autoScroll,
                      onPressed: () {
                        setState(() => _autoScroll = !_autoScroll);
                      },
                    ),
                    // Copy all logs
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.white70),
                      tooltip: l10n.copyAll,
                      onPressed: () {
                        final service = ref.read(debugLogServiceProvider);
                        Clipboard.setData(ClipboardData(text: service.exportLogs()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.copiedToClipboard)),
                        );
                      },
                    ),
                    // Clear logs
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white70),
                      tooltip: l10n.clearLogs,
                      onPressed: () {
                        ref.read(debugLogServiceProvider).clearLogs();
                        setState(() {});
                      },
                    ),
                    // Close
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      tooltip: l10n.close,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Filter bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey.shade800,
            child: Row(
              children: [
                // Level filter
                DropdownButton<String>(
                  value: _filterLevel,
                  dropdownColor: Colors.grey.shade800,
                  style: const TextStyle(color: Colors.white),
                  underline: const SizedBox(),
                  items: ['ALL', 'DEBUG', 'INFO', 'WARNING', 'ERROR']
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(
                              level,
                              style: TextStyle(
                                color: level == 'ALL'
                                    ? Colors.white
                                    : _getLevelColor(level),
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _filterLevel = value);
                    }
                  },
                ),
                const SizedBox(width: 12),
                // Search field
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: l10n.searchLogs,
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey.shade800,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Log count
                Text(
                  '${filteredLogs.length}/${logs.length}',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          // Log list
          Expanded(
            child: filteredLogs.isEmpty
                ? Center(
                    child: Text(
                      l10n.noLogsYet,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      return _LogEntryTile(log: log);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _LogEntryTile extends StatelessWidget {
  final LogEntry log;

  const _LogEntryTile({required this.log});

  Color _getLevelColor(String level) {
    switch (level.toUpperCase()) {
      case 'ERROR':
        return Colors.red;
      case 'WARNING':
        return Colors.orange;
      case 'INFO':
        return Colors.blue;
      case 'DEBUG':
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = _getLevelColor(log.level);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
        border: Border(
          left: BorderSide(color: levelColor, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                log.formattedTime,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: levelColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  log.level,
                  style: TextStyle(
                    color: levelColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (log.source != null) ...[
                const SizedBox(width: 8),
                Text(
                  log.source!,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 11,
                  ),
                ),
              ],
              const Spacer(),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: log.toString()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).copiedToClipboard),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Icon(
                  Icons.copy,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SelectableText(
            log.message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
          if (log.error != null) ...[
            const SizedBox(height: 4),
            SelectableText(
              'Error: ${log.error}',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ],
          if (log.stackTrace != null) ...[
            const SizedBox(height: 4),
            ExpansionTile(
              title: Text(
                'Stack Trace',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                ),
              ),
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(top: 4),
              children: [
                SelectableText(
                  log.stackTrace.toString(),
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Inline version of the debug log viewer (doesn't require Navigator)
class DebugLogViewerInline extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  
  const DebugLogViewerInline({super.key, required this.onClose});

  @override
  ConsumerState<DebugLogViewerInline> createState() => _DebugLogViewerInlineState();
}

class _DebugLogViewerInlineState extends ConsumerState<DebugLogViewerInline> {
  final ScrollController _scrollController = ScrollController();
  bool _autoScroll = true;
  String _filterLevel = 'ALL';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_autoScroll && _scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  List<LogEntry> _filterLogs(List<LogEntry> logs) {
    return logs.where((log) {
      if (_filterLevel != 'ALL' && log.level != _filterLevel) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return log.message.toLowerCase().contains(query) ||
            (log.source?.toLowerCase().contains(query) ?? false) ||
            (log.error?.toLowerCase().contains(query) ?? false);
      }
      return true;
    }).toList();
  }

  Color _getLevelColor(String level) {
    switch (level.toUpperCase()) {
      case 'ERROR':
        return Colors.red;
      case 'WARNING':
        return Colors.orange;
      case 'INFO':
        return Colors.blue;
      case 'DEBUG':
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final logs = ref.watch(currentLogsProvider);
    final filteredLogs = _filterLogs(logs);

    ref.listen(logEntriesStreamProvider, (_, __) {
      _scrollToBottom();
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bug_report, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  l10n.debugLog,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    _autoScroll ? Icons.vertical_align_bottom : Icons.vertical_align_center,
                    color: _autoScroll ? Colors.orange : Colors.grey,
                  ),
                  tooltip: l10n.autoScroll,
                  onPressed: () {
                    setState(() => _autoScroll = !_autoScroll);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.white70),
                  tooltip: l10n.copyAll,
                  onPressed: () {
                    final service = ref.read(debugLogServiceProvider);
                    Clipboard.setData(ClipboardData(text: service.exportLogs()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.copiedToClipboard)),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white70),
                  tooltip: l10n.clearLogs,
                  onPressed: () {
                    ref.read(debugLogServiceProvider).clearLogs();
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  tooltip: l10n.close,
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),
          // Filter bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey.shade800,
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _filterLevel,
                  dropdownColor: Colors.grey.shade800,
                  style: const TextStyle(color: Colors.white),
                  underline: const SizedBox(),
                  items: ['ALL', 'DEBUG', 'INFO', 'WARNING', 'ERROR']
                      .map((level) => DropdownMenuItem(
                            value: level,
                            child: Text(
                              level,
                              style: TextStyle(
                                color: level == 'ALL'
                                    ? Colors.white
                                    : _getLevelColor(level),
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _filterLevel = value);
                    }
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: l10n.searchLogs,
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey.shade700,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${filteredLogs.length}/${logs.length}',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          // Log list
          Expanded(
            child: filteredLogs.isEmpty
                ? Center(
                    child: Text(
                      l10n.noLogsYet,
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      return _LogEntryTile(log: log);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Shows the debug log viewer as a bottom sheet
void showDebugLogViewer(BuildContext context) {
  // Use rootNavigator to find the root navigator since we're in MaterialApp.builder
  final navigator = Navigator.maybeOf(context, rootNavigator: true);
  if (navigator == null) {
    // Fallback: try to show as an overlay dialog
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: const DebugLogViewer(),
          ),
        ),
      ),
    );
    return;
  }
  
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) => const DebugLogViewer(),
    ),
  );
}
