import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/error_view.dart';
import 'providers/reader_provider.dart';
import 'widgets/reader_controls.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final String mangaId;
  final String chapterId;

  const ReaderScreen({
    super.key,
    required this.mangaId,
    required this.chapterId,
  });

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final _scrollController = ScrollController();
  late final String _key;

  @override
  void initState() {
    super.initState();
    _key = readerKey(widget.mangaId, widget.chapterId);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;
    if (max <= 0) return;
    final progress = (_scrollController.offset / max).clamp(0.0, 1.0);
    ref.read(readerProvider(_key).notifier).updateProgress(progress);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final readerAsync = ref.watch(readerProvider(_key));

    return Scaffold(
      backgroundColor: Colors.black,
      body: readerAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppConstants.accentRed),
        ),
        error: (e, _) => ErrorView(message: e.toString()),
        data: (data) => GestureDetector(
          onTap: () =>
              ref.read(readerProvider(_key).notifier).toggleControls(),
          child: Stack(
            children: [
              // Page content
              ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: data.chapter.pageUrls.length,
                itemBuilder: (context, i) => _PageImage(
                  url: data.chapter.pageUrls[i],
                  pageNumber: i + 1,
                ),
              ),

              // End of chapter overlay
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: data.scrollProgress > 0.95 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppConstants.cardColor.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '🎉 End of Chapter',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Controls overlay
              AnimatedOpacity(
                opacity: data.showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !data.showControls,
                  child: Stack(
                    children: [
                      // Top bar
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: ReaderTopBar(
                          mangaTitle: data.manga.title,
                          chapterTitle: data.chapter.displayTitle,
                        ),
                      ),
                      // Bottom bar
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ReaderBottomBar(
                          progress: data.scrollProgress,
                          prevChapter: data.prevChapter,
                          nextChapter: data.nextChapter,
                          onPrev: data.prevChapter != null
                              ? () => ref
                                  .read(readerProvider(_key).notifier)
                                  .goToChapter(data.prevChapter!)
                              : null,
                          onNext: data.nextChapter != null
                              ? () {
                                  ref
                                      .read(readerProvider(_key).notifier)
                                      .goToChapter(data.nextChapter!);
                                  _scrollController.jumpTo(0);
                                }
                              : null,
                        ),
                      ),
                    ],
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

class _PageImage extends StatelessWidget {
  final String url;
  final int pageNumber;

  const _PageImage({required this.url, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return CachedNetworkImage(
      imageUrl: url,
      width: w,
      fit: BoxFit.fitWidth,
      placeholder: (_, __) => Container(
        width: w,
        height: w * 1.5,
        color: const Color(0xFF111111),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppConstants.accentRed,
                strokeWidth: 2,
              ),
              const SizedBox(height: 8),
              Text(
                'Page $pageNumber',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        width: w,
        height: w * 1.5,
        color: const Color(0xFF111111),
        child: const Center(
          child: Icon(Icons.broken_image_rounded,
              size: 48, color: AppConstants.textSecondary),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
