import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tavern/presentation/providers/tts_providers.dart';
import 'package:native_tavern/presentation/theme/app_theme.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/presentation/widgets/common/app_viewport.dart';

class ChatTTSMessageButton extends ConsumerWidget {
  const ChatTTSMessageButton({
    super.key,
    required this.text,
    required this.ownerId,
    required this.sourceId,
    this.characterId,
    this.size = 18,
  });

  final String text;
  final String ownerId;
  final String sourceId;
  final String? characterId;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      ttsSettingsProvider.select((settings) => settings.enabled),
    );
    if (!enabled || text.trim().isEmpty) return const SizedBox.shrink();

    final playback = ref.watch(ttsPlaybackStateProvider);
    final ownsPlayback = playback.ownerId == ownerId &&
        playback.sourceId == sourceId &&
        playback.isActive;
    final paused = ownsPlayback && playback.isPaused;

    return IconButton(
      icon: Icon(
        paused
            ? Icons.play_arrow
            : ownsPlayback
                ? Icons.pause
                : Icons.volume_up_outlined,
        size: size,
      ),
      tooltip: paused
          ? 'Resume reading'
          : ownsPlayback
              ? 'Pause reading'
              : 'Read aloud',
      onPressed: () {
        if (paused) {
          unawaited(ref.read(ttsResumeProvider)());
        } else if (ownsPlayback) {
          unawaited(ref.read(ttsPauseProvider)());
        } else {
          unawaited(
            ref.read(ttsSpeakProvider)(
              text,
              characterId: characterId,
              ownerId: ownerId,
              sourceId: sourceId,
            ),
          );
        }
      },
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      color: ownsPlayback ? AppTheme.accentColor : AppTheme.textMuted,
    );
  }
}

class ChatTTSPlaybackControls extends ConsumerWidget {
  const ChatTTSPlaybackControls({
    super.key,
    required this.ownerId,
  });

  final String ownerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      ttsSettingsProvider.select((settings) => settings.enabled),
    );
    final playback = ref.watch(ttsPlaybackStateProvider);
    if (!enabled || playback.ownerId != ownerId || !playback.isActive) {
      return const SizedBox.shrink();
    }

    return Flex(
      direction: WindowLayoutScope.maybeOf(context)?.verticalBarEdge == null
          ? Axis.horizontal
          : Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            playback.isPaused ? Icons.play_arrow : Icons.pause,
          ),
          tooltip: playback.isPaused
              ? AppLocalizations.of(context).resumeReading
              : AppLocalizations.of(context).pauseReading,
          onPressed: () {
            unawaited(
              playback.isPaused
                  ? ref.read(ttsResumeProvider)()
                  : ref.read(ttsPauseProvider)(),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          tooltip: AppLocalizations.of(context).stopReading,
          onPressed: () {
            unawaited(ref.read(ttsStopProvider)(ownerId: ownerId));
          },
        ),
      ],
    );
  }
}
