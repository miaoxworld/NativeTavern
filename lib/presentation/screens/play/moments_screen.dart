import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:native_tavern/data/models/character.dart';
import 'package:native_tavern/data/models/moment/moment_post.dart';
import 'package:native_tavern/domain/services/moment_service.dart';
import 'package:native_tavern/l10n/generated/app_localizations.dart';
import 'package:native_tavern/data/models/persona.dart';
import 'package:native_tavern/presentation/providers/character_providers.dart';
import 'package:native_tavern/presentation/providers/moment_providers.dart';
import 'package:native_tavern/presentation/providers/persona_providers.dart';
import 'package:native_tavern/presentation/providers/settings_providers.dart';
import 'package:native_tavern/presentation/widgets/common/character_avatar_image.dart';

/// WeChat Moments-style public feed. Browsing only; posting is a full page.
class MomentsScreen extends ConsumerWidget {
  const MomentsScreen({super.key});

  static const _coverHeight = 286.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    final feed = ref.watch(pagedMomentFeedProvider);
    final characters =
        ref.watch(characterListProvider).asData?.value ?? const <Character>[];
    final persona = ref.watch(activePersonaProvider).asData?.value;
    final selfName = _personaName(persona, l10n.momentsAuthorMe);
    final palette = _MomentsPalette.of(context);
    final topInset = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: palette.page,
        body: !settings.momentsEnabled
            ? Column(
                children: [
                  _CoverHeader(
                    height: _coverHeight,
                    topInset: topInset,
                    selfName: selfName,
                    selfAvatarPath: persona?.avatarPath,
                    palette: palette,
                    onBack: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: _CenteredMessage(
                      l10n.momentsDisabledEmpty,
                      key: const Key('moments-disabled-empty'),
                      color: palette.time,
                    ),
                  ),
                ],
              )
            : feed.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _CenteredMessage(error.toString()),
                data: (items) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.extentAfter < 600) {
                        ref.read(pagedMomentFeedProvider.notifier).loadMore();
                      }
                      return false;
                    },
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          stretch: true,
                          elevation: 0,
                          scrolledUnderElevation: 0,
                          backgroundColor: palette.page,
                          surfaceTintColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          title: Text(l10n.moments),
                          expandedHeight: _coverHeight + topInset,
                          leading: IconButton(
                            icon:
                                const Icon(Icons.arrow_back_ios_new, size: 18),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          actions: [
                            IconButton(
                              key: const Key('moments-compose'),
                              tooltip: l10n.momentsCompose,
                              onPressed: () => _compose(context, ref, selfName),
                              icon: const Icon(Icons.camera_alt_outlined),
                            ),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: _CoverHeader(
                              height: _coverHeight + topInset,
                              topInset: topInset,
                              selfName: selfName,
                              selfAvatarPath: persona?.avatarPath,
                              palette: palette,
                              showChrome: false,
                            ),
                          ),
                        ),
                        if (items.isEmpty)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: _CenteredMessage(
                              l10n.momentsEmpty,
                              key: const Key('moments-empty'),
                              color: palette.time,
                            ),
                          )
                        else
                          SliverList.separated(
                            itemCount: items.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              thickness: 0.5,
                              color: palette.divider,
                            ),
                            itemBuilder: (context, index) => _MomentRow(
                              item: items[index],
                              character:
                                  _authorOf(characters, items[index].post),
                              persona: persona,
                              selfName: selfName,
                              palette: palette,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Character? _authorOf(List<Character> characters, MomentPost post) {
    if (post.origin != MomentPostOrigin.character) return null;
    for (final character in characters) {
      if (character.id == post.authorId) return character;
    }
    return null;
  }

  Future<void> _compose(
    BuildContext context,
    WidgetRef ref,
    String selfName,
  ) async {
    final draft = await Navigator.of(context).push<_ComposeDraft>(
      MaterialPageRoute(builder: (_) => const _MomentsComposePage()),
    );
    if (draft == null || !context.mounted) return;
    final service = ref.read(momentServiceProvider);
    final imagePath = draft.imagePath == null
        ? null
        : await service.importImage(draft.imagePath!);
    await service.publishPlayerPost(
      body: draft.body,
      imagePath: imagePath,
      authorName: selfName,
    );
    ref.invalidate(pagedMomentFeedProvider);
  }
}

class _CoverHeader extends StatelessWidget {
  const _CoverHeader({
    required this.height,
    required this.topInset,
    required this.selfName,
    this.selfAvatarPath,
    required this.palette,
    this.onBack,
    this.showChrome = true,
  });

  final double height;
  final double topInset;
  final String selfName;
  final String? selfAvatarPath;
  final _MomentsPalette palette;
  final VoidCallback? onBack;
  final bool showChrome;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 36,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2B3340),
                    Color(0xFF6B5344),
                    Color(0xFF8A6A4A),
                  ],
                ),
              ),
              child: CustomPaint(painter: _CoverGrainPainter()),
            ),
          ),
          if (showChrome)
            Positioned(
              top: topInset + 4,
              left: 4,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    size: 18, color: Colors.white),
                onPressed: onBack,
              ),
            ),
          Positioned(
            right: 16,
            bottom: 8,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 10),
                  child: Text(
                    selfName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(color: Colors.black54, blurRadius: 8),
                      ],
                    ),
                  ),
                ),
                _SquareAvatar(
                  name: selfName,
                  size: 72,
                  radius: 6,
                  imagePath: selfAvatarPath,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MomentRow extends ConsumerStatefulWidget {
  const _MomentRow({
    required this.item,
    required this.character,
    required this.persona,
    required this.selfName,
    required this.palette,
  });

  final MomentFeedItem item;
  final Character? character;
  final Persona? persona;
  final String selfName;
  final _MomentsPalette palette;

  @override
  ConsumerState<_MomentRow> createState() => _MomentRowState();
}

class _MomentRowState extends ConsumerState<_MomentRow> {
  final _pendingComments = <MomentComment>[];

  void _openAuthor() {
    final post = widget.item.post;
    if (post.origin != MomentPostOrigin.character) return;
    context.push('/characters/${post.authorId}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final post = widget.item.post;
    final isSelf = post.origin == MomentPostOrigin.user;
    final name = isSelf ? widget.selfName : post.authorName;
    final knownIds = {
      for (final comment in widget.item.comments) comment.id,
    };
    final comments = [
      ...widget.item.comments,
      ..._pendingComments.where((comment) => !knownIds.contains(comment.id)),
    ];
    final palette = widget.palette;
    return Material(
      color: palette.cell,
      child: Padding(
        key: Key('moment-card-${post.id}'),
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              key: isSelf ? null : Key('moment-author-${post.authorId}'),
              onTap: isSelf ? null : _openAuthor,
              child: _SquareAvatar(
                name: name,
                size: 42,
                radius: 4,
                imagePath: isSelf
                    ? widget.persona?.avatarPath
                    : widget.character?.assets?.avatarPath,
                imageUrl: isSelf ? null : widget.character?.assets?.avatarUrl,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: isSelf ? null : _openAuthor,
                    child: Text(
                      name,
                      style: TextStyle(
                        color: palette.name,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                  if (post.publicBody.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      post.publicBody,
                      style: TextStyle(
                        color: palette.text,
                        fontSize: 16,
                        height: 1.35,
                      ),
                    ),
                  ],
                  if (post.hasPhoto) ...[
                    const SizedBox(height: 8),
                    _MomentPhoto(
                      path: post.imagePath!,
                      photoKey: Key('moment-photo-${post.id}'),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        formatMomentTime(post.createdAt, l10n.localeName),
                        style: TextStyle(color: palette.time, fontSize: 13),
                      ),
                      const Spacer(),
                      _CommentButton(
                        post: post,
                        authorName: widget.selfName,
                        palette: palette,
                        onPosted: (comment) {
                          setState(() => _pendingComments.add(comment));
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        key: Key('moment-like-${post.id}'),
                        tooltip: 'Like',
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          widget.item.likedByViewer
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 18,
                          color: widget.item.likedByViewer
                              ? Colors.redAccent
                              : palette.time,
                        ),
                        onPressed: () async {
                          await ref
                              .read(momentServiceProvider)
                              .toggleLike(post.id);
                          ref.invalidate(pagedMomentFeedProvider);
                        },
                      ),
                      if (widget.item.likeCount > 0)
                        Text(
                          '${widget.item.likeCount}',
                          style: TextStyle(color: palette.time, fontSize: 13),
                        ),
                    ],
                  ),
                  if (comments.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _CommentBox(
                      postId: post.id,
                      comments: comments,
                      palette: palette,
                      onChanged: () {
                        ref.invalidate(pagedMomentFeedProvider);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentButton extends ConsumerWidget {
  const _CommentButton({
    required this.post,
    required this.authorName,
    required this.palette,
    required this.onPosted,
  });

  final MomentPost post;
  final String authorName;
  final _MomentsPalette palette;
  final ValueChanged<MomentComment> onPosted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: palette.commentBox,
      borderRadius: BorderRadius.circular(3),
      child: InkWell(
        key: Key('moment-comment-${post.id}'),
        borderRadius: BorderRadius.circular(3),
        onTap: () => _promptComment(context, ref, l10n),
        child: const SizedBox(
          width: 32,
          height: 20,
          child: Icon(Icons.more_horiz, size: 18, color: Color(0xFF576B95)),
        ),
      ),
    );
  }

  Future<void> _promptComment(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !context.mounted) return;
    final origin = box.localToGlobal(Offset.zero);
    final selected = await showMenu<String>(
      context: context,
      color: const Color(0xFF4C4C4C),
      position: RelativeRect.fromLTRB(
        origin.dx - 88,
        origin.dy - 6,
        origin.dx,
        origin.dy + 28,
      ),
      items: [
        PopupMenuItem(
          value: 'comment',
          height: 36,
          child: Text(
            l10n.momentsComment,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
    if (selected != 'comment' || !context.mounted) return;
    await _editComment(context, ref, l10n);
  }

  Future<void> _editComment(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final controller = TextEditingController();
    final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: palette.cell,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            12,
            10,
            12,
            10 + MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('moment-comment-body'),
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: l10n.momentsComment,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => Navigator.pop(sheetContext, true),
                child: Text(l10n.send),
              ),
            ],
          ),
        );
      },
    );
    final body = controller.text.trim();
    controller.dispose();
    if (submitted != true || body.isEmpty) return;
    final comment = await ref.read(momentServiceProvider).comment(
          postId: post.id,
          body: body,
          authorName: authorName,
        );
    onPosted(comment);
    ref.invalidate(pagedMomentFeedProvider);
  }
}

class _CommentBox extends StatelessWidget {
  const _CommentBox({
    required this.postId,
    required this.comments,
    required this.palette,
    required this.onChanged,
  });

  final String postId;
  final List<MomentComment> comments;
  final _MomentsPalette palette;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.commentBox,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final comment in comments)
              _CommentLine(
                postId: postId,
                comment: comment,
                palette: palette,
                onChanged: onChanged,
              ),
          ],
        ),
      ),
    );
  }
}

class _CommentLine extends StatelessWidget {
  const _CommentLine({
    required this.postId,
    required this.comment,
    required this.palette,
    required this.onChanged,
  });

  final String postId;
  final MomentComment comment;
  final _MomentsPalette palette;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _reply(context),
      onLongPress: comment.authorId == MomentService.userAuthorId
          ? () => _delete(context)
          : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Text.rich(
          TextSpan(
            children: [
              if (comment.parentCommentId != null) const TextSpan(text: '↳ '),
              TextSpan(
                text: comment.authorName,
                style: TextStyle(
                  color: palette.name,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: '：${comment.body}',
                style: TextStyle(color: palette.text, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _reply(BuildContext context) async {
    final controller = TextEditingController();
    final submit = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          12,
          10,
          12,
          10 + MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Reply to ${comment.authorName}',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(sheetContext, true),
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
    final body = controller.text.trim();
    controller.dispose();
    if (submit != true || body.isEmpty || !context.mounted) return;
    await ProviderScope.containerOf(context, listen: false)
        .read(momentServiceProvider)
        .reply(postId: postId, parentCommentId: comment.id, body: body);
    onChanged();
  }

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: const Text('Delete your comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ProviderScope.containerOf(context, listen: false)
        .read(momentServiceProvider)
        .deleteComment(comment.id, authorId: MomentService.userAuthorId);
    onChanged();
  }
}

class _MomentPhoto extends StatelessWidget {
  const _MomentPhoto({required this.path, required this.photoKey});

  final String path;
  final Key photoKey;

  @override
  Widget build(BuildContext context) {
    final image = File(path);
    if (!image.existsSync()) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () => _openPreview(context, image),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 184, maxHeight: 184),
          child: Image.file(image, key: photoKey, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Future<void> _openPreview(BuildContext context, File image) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (_) => _MomentPhotoPreview(image: image),
    );
  }
}

class _MomentPhotoPreview extends StatefulWidget {
  const _MomentPhotoPreview({required this.image});

  final File image;

  @override
  State<_MomentPhotoPreview> createState() => _MomentPhotoPreviewState();
}

class _MomentPhotoPreviewState extends State<_MomentPhotoPreview> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          onLongPress: () => _showActions(context, l10n),
          child: Center(
            child: InteractiveViewer(
              child: Image.file(widget.image, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showActions(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final save = await showModalBottomSheet<bool>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListTile(
          key: const Key('moment-photo-save'),
          leading: const Icon(Icons.download_outlined),
          title: Text(l10n.momentsSavePhoto),
          onTap: () => Navigator.pop(sheetContext, true),
        ),
      ),
    );
    if (save != true || !context.mounted) return;
    try {
      final hasAccess = await Gal.hasAccess(toAlbum: true).timeout(
        const Duration(seconds: 8),
      );
      if (!hasAccess) {
        final granted = await Gal.requestAccess(toAlbum: true).timeout(
          const Duration(seconds: 8),
        );
        if (!granted) {
          if (context.mounted) {
            _showFeedback(l10n.momentsPhotoSaveFailed);
          }
          return;
        }
      }
      await Gal.putImage(widget.image.path, album: 'NativeTavern').timeout(
        const Duration(seconds: 15),
      );
      if (context.mounted) {
        _showFeedback(l10n.momentsPhotoSaved);
      }
    } catch (_) {
      if (context.mounted) {
        _showFeedback(l10n.momentsPhotoSaveFailed);
      }
    }
  }

  void _showFeedback(String message) {
    final messenger = _messengerKey.currentState;
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          content: Text(message),
        ),
      );
  }
}

class _SquareAvatar extends StatelessWidget {
  const _SquareAvatar({
    required this.name,
    required this.size,
    required this.radius,
    this.imagePath,
    this.imageUrl,
    this.border,
  });

  final String name;
  final double size;
  final double radius;
  final String? imagePath;
  final String? imageUrl;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim().characters.first;
    Widget child;
    final path = imagePath?.trim();
    final url = imageUrl?.trim();
    if (path != null && path.isNotEmpty) {
      child = CharacterAvatarImage(
        imagePath: path,
        errorBuilder: (_, __, ___) => _Initial(initial),
      );
    } else if (url != null && url.isNotEmpty) {
      child = Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _Initial(initial),
      );
    } else {
      child = _Initial(initial);
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: border,
        color: const Color(0xFFB7C4D6),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF8FA4C2),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class _ComposeDraft {
  const _ComposeDraft({required this.body, this.imagePath});

  final String body;
  final String? imagePath;
}

class _MomentsComposePage extends StatefulWidget {
  const _MomentsComposePage();

  @override
  State<_MomentsComposePage> createState() => _MomentsComposePageState();
}

class _MomentsComposePageState extends State<_MomentsComposePage> {
  final _controller = TextEditingController();
  String? _imagePath;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSend => _controller.text.trim().isNotEmpty || _imagePath != null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = _MomentsPalette.of(context);
    return Scaffold(
      backgroundColor: palette.cell,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        l10n.cancel,
                        style: TextStyle(color: palette.text),
                      ),
                    ),
                    const Spacer(),
                    FilledButton(
                      key: const Key('moments-compose-send'),
                      onPressed: _canSend ? _submit : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF07C160),
                        disabledBackgroundColor: const Color(0xFFB5E5C8),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(64, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(l10n.momentsCompose),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                TextField(
                  key: const Key('moments-compose-body'),
                  controller: _controller,
                  maxLines: 6,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.momentsComposeHint,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _imagePath == null
                      ? InkWell(
                          key: const Key('moments-compose-photo'),
                          onTap: _pickPhoto,
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              border: Border.all(color: palette.divider),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child:
                                Icon(Icons.add, size: 36, color: palette.time),
                          ),
                        )
                      : GestureDetector(
                          key: const Key('moments-compose-photo'),
                          onTap: _pickPhoto,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: Image.file(
                              File(_imagePath!),
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_canSend) return;
    Navigator.pop(
      context,
      _ComposeDraft(body: _controller.text.trim(), imagePath: _imagePath),
    );
  }

  Future<void> _pickPhoto() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) return;
    setState(() => _imagePath = image.path);
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: 14),
        ),
      ),
    );
  }
}

class _MomentsPalette {
  const _MomentsPalette._({required this.dark});

  factory _MomentsPalette.of(BuildContext context) {
    return _MomentsPalette._(
      dark: Theme.of(context).brightness == Brightness.dark,
    );
  }

  final bool dark;

  Color get page => dark ? const Color(0xFF111111) : const Color(0xFFEDEDED);
  Color get cell => dark ? const Color(0xFF191919) : Colors.white;
  Color get name => const Color(0xFF576B95);
  Color get text => dark ? const Color(0xFFEDEDED) : const Color(0xFF111111);
  Color get time => const Color(0xFF888888);
  Color get commentBox =>
      dark ? const Color(0xFF2A2A2A) : const Color(0xFFF7F7F7);
  Color get divider => dark ? const Color(0xFF2C2C2C) : const Color(0xFFE5E5E5);
}

class _CoverGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(7);
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.08);
    for (var i = 0; i < 80; i++) {
      canvas.drawCircle(
        Offset(random.nextDouble() * size.width,
            random.nextDouble() * size.height),
        random.nextDouble() * 18 + 4,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String _personaName(Persona? persona, String fallback) {
  final name = persona?.name.trim();
  if (name == null || name.isEmpty) return fallback;
  return name;
}

@visibleForTesting
String formatMomentTime(DateTime createdAt, String localeName) {
  final now = DateTime.now();
  final local = createdAt.toLocal();
  final delta = now.difference(local);
  final zh = localeName.startsWith('zh');
  if (delta.inMinutes < 1) return zh ? '刚刚' : 'Just now';
  if (delta.inHours < 1) {
    return zh ? '${delta.inMinutes}分钟前' : '${delta.inMinutes}m ago';
  }
  if (now.year == local.year &&
      now.month == local.month &&
      now.day == local.day) {
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
  final yesterday = now.subtract(const Duration(days: 1));
  if (yesterday.year == local.year &&
      yesterday.month == local.month &&
      yesterday.day == local.day) {
    return zh ? '昨天' : 'Yesterday';
  }
  return '${local.month}/${local.day}';
}
