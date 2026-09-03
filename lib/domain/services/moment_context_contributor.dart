import 'package:native_tavern/domain/services/chat_generation_pipeline.dart';
import 'package:native_tavern/domain/services/moment_service.dart';

/// Injects only the moments this character can know: friends, the player,
/// and comments on those posts.
final class MomentContextContributor extends ContextContributor {
  MomentContextContributor({
    required MomentService moments,
    required bool Function() enabled,
    Future<bool> Function(String chatId)? chatEnabled,
    this.limit = 6,
  })  : _moments = moments,
        _enabled = enabled,
        _chatEnabled = chatEnabled ?? ((_) async => false);

  static const contributorId = 'moments.friends_circle';

  final MomentService _moments;
  final bool Function() _enabled;
  final Future<bool> Function(String chatId) _chatEnabled;
  final int limit;

  @override
  String get id => contributorId;

  @override
  int get order => 680;

  @override
  int get maxTokens => 700;

  @override
  Future<bool> isEnabled(ChatContextRequest request) async {
    if (!_enabled() ||
        request.characterId == null ||
        request.characterId!.trim().isEmpty) {
      return false;
    }
    return _chatEnabled(request.chatId);
  }

  @override
  Future<ContextContribution> contribute(ChatContextRequest request) async {
    request.cancellationToken.throwIfCancelled();
    final characterId = request.characterId?.trim() ?? '';
    if (characterId.isEmpty) {
      return ContextContribution(messages: const []);
    }
    final items = await _moments.visibleFeedFor(characterId, limit: limit);
    request.cancellationToken.throwIfCancelled();
    final body = MomentService.formatVisibleMoments(items);
    if (body.trim().isEmpty) {
      return ContextContribution(messages: const []);
    }
    return ContextContribution(
      placement: ContextContributionPlacement.beforeConversation,
      messages: [
        {
          'role': 'system',
          'content': 'Moments this character can see (friends, the player, and '
              'comments on those posts only). Do not invent strangers\' posts.\n'
              '$body',
        },
      ],
    );
  }
}
