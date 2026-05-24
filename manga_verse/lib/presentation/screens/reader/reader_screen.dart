import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/chapter.dart';
import '../../../domain/entities/story.dart';
import '../../providers/history_provider.dart';
import '../../providers/reading_progress_provider.dart';
import '../../providers/stories_provider.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final String storyId;
  final String chapterId;

  const ReaderScreen(
      {super.key, required this.storyId, required this.chapterId});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  late ScrollController _scrollController;
  bool _showControls = true;
  Timer? _controlsTimer;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreProgress());
  }

  void _restoreProgress() {
    final page =
        ref.read(readingProgressProvider.notifier).getProgress(widget.chapterId);
    if (page > 0 && _scrollController.hasClients) {
      final h = MediaQuery.of(context).size.width * 1.4;
      _scrollController.jumpTo(page * h);
    }
  }

  void _onScroll() {
    final chapter = ref.read(chapterByIdProvider(widget.chapterId)).valueOrNull;
    if (chapter == null) return;

    final pageH = MediaQuery.of(context).size.width * 1.4;
    final page = (_scrollController.offset / pageH).floor().clamp(
        0, chapter.pagesCount - 1);

    if (page != _currentPage) {
      setState(() => _currentPage = page);
      ref
          .read(readingProgressProvider.notifier)
          .saveProgress(widget.chapterId, page);
      _updateHistory(chapter, page);
    }

    // hide controls while scrolling
    if (_showControls) setState(() => _showControls = false);
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = true);
    });

  }

  void _updateHistory(Chapter chapter, int page) {
    final story =
        ref.read(storyByIdProvider(widget.storyId)).valueOrNull;
    if (story == null) return;
    ref.read(historyProvider.notifier).record(
          storyId: story.id,
          storyTitle: story.title,
          coverSeed: story.coverSeed,
          chapterNumber: chapter.number,
          pageIndex: page,
          totalChapters: story.chaptersCount,
        );
  }

  void _tapHandler() => setState(() => _showControls = !_showControls);

  void _navigateChapter(int delta, Story story, Chapter chapter,
      List<Chapter> chapters) {
    final idx = chapters.indexWhere((c) => c.id == chapter.id);
    final next = idx + delta;
    if (next >= 0 && next < chapters.length) {
      context.pushReplacement(
          '/reader/${story.id}/${chapters[next].id}');
    } else if (delta > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No more chapters')),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controlsTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chapterAsync = ref.watch(chapterByIdProvider(widget.chapterId));
    final storyAsync = ref.watch(storyByIdProvider(widget.storyId));
    final chaptersAsync = ref.watch(chaptersForStoryProvider(widget.storyId));

    return chapterAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) =>
          const Scaffold(body: Center(child: Text('Chapter not found'))),
      data: (chapter) {
        if (chapter == null) {
          return const Scaffold(
              body: Center(child: Text('Chapter not found')));
        }
        final story = storyAsync.valueOrNull;
        final chapters = chaptersAsync.valueOrNull ?? [];

        return Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: _tapHandler,
            child: Stack(
              children: [
                // Pages
                ListView.builder(
                  controller: _scrollController,
                  itemCount: chapter.pagesCount,
                  itemBuilder: (context, i) => _PageImage(
                    url: chapter.pageUrl(i + 1),
                  ),
                ),
                // Tap zones: left = prev, right = next
                if (story != null)
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => _navigateChapter(
                                -1, story, chapter, chapters),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                        Expanded(flex: 3, child: Container(color: Colors.transparent)),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => _navigateChapter(
                                1, story, chapter, chapters),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Top bar
                AnimatedOpacity(
                  opacity: _showControls ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: _TopBar(
                    story: story,
                    chapter: chapter,
                    currentPage: _currentPage,
                  ),
                ),
                // Bottom bar
                AnimatedOpacity(
                  opacity: _showControls ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: _BottomBar(
                    story: story,
                    chapter: chapter,
                    chapters: chapters,
                    currentPage: _currentPage,
                    onPrev: () => story != null
                        ? _navigateChapter(-1, story, chapter, chapters)
                        : null,
                    onNext: () => story != null
                        ? _navigateChapter(1, story, chapter, chapters)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PageImage extends StatelessWidget {
  final String url;

  const _PageImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      width: double.infinity,
      fit: BoxFit.fitWidth,
      placeholder: (_, __) => AspectRatio(
        aspectRatio: 0.7,
        child: Container(
          color: const Color(0xFF111111),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
      errorWidget: (_, __, ___) => AspectRatio(
        aspectRatio: 0.7,
        child: Container(
          color: const Color(0xFF111111),
          child: const Center(
            child: Icon(Icons.broken_image_outlined,
                color: Colors.white24, size: 48),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final Story? story;
  final Chapter chapter;
  final int currentPage;

  const _TopBar(
      {required this.story,
      required this.chapter,
      required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (story != null)
                        Text(
                          story!.title,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      Text(
                        'Ch.${chapter.number}: ${chapter.title}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${currentPage + 1}/${chapter.pagesCount}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final Story? story;
  final Chapter chapter;
  final List<Chapter> chapters;
  final int currentPage;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _BottomBar({
    required this.story,
    required this.chapter,
    required this.chapters,
    required this.currentPage,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final idx =
        chapters.indexWhere((c) => c.id == chapter.id);
    final hasPrev = idx > 0;
    final hasNext = idx < chapters.length - 1;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavButton(
                  icon: Icons.skip_previous_rounded,
                  label: 'Prev Ch',
                  enabled: hasPrev,
                  onTap: onPrev,
                ),
                LinearProgressIndicator(
                  value: chapter.pagesCount > 0
                      ? (currentPage + 1) / chapter.pagesCount
                      : 0,
                  backgroundColor: Colors.white24,
                  color: AppColors.primary,
                  minHeight: 3,
                ).expand(),
                _NavButton(
                  icon: Icons.skip_next_rounded,
                  label: 'Next Ch',
                  enabled: hasNext,
                  onTap: onNext,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback? onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: enabled ? Colors.white : Colors.white30, size: 22),
          Text(
            label,
            style: TextStyle(
              color: enabled ? Colors.white70 : Colors.white24,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

extension on Widget {
  Widget expand() => Expanded(child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12), child: this));
}
