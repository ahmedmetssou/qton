import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../../shared/models/chapter.dart';
import '../../shared/models/manga.dart';
import '../../shared/providers/favorites_provider.dart';
import '../../shared/providers/history_provider.dart';
import 'providers/manga_detail_provider.dart';

class MangaDetailScreen extends ConsumerStatefulWidget {
  final String mangaId;

  const MangaDetailScreen({super.key, required this.mangaId});

  @override
  ConsumerState<MangaDetailScreen> createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends ConsumerState<MangaDetailScreen> {
  bool _sortAscending = false;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(mangaDetailProvider(widget.mangaId));
    final isFav = ref.watch(
        favoritesProvider.select((list) => list.any((m) => m.id == widget.mangaId)));
    final history = ref.watch(historyProvider);
    final progress = history.where((h) => h.mangaId == widget.mangaId).firstOrNull;

    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      body: detailAsync.when(
        loading: () => const _LoadingView(),
        error: (e, _) => ErrorView(message: e.toString()),
        data: (data) => _buildContent(context, data, isFav, progress),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    MangaDetailState data,
    bool isFav,
    ReadingProgress? progress,
  ) {
    final manga = data.manga;
    final chapters = _sortAscending
        ? [...data.chapters].reversed.toList()
        : data.chapters;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Collapsible app bar with cover
        SliverAppBar(
          expandedHeight: 340,
          pinned: true,
          backgroundColor: AppConstants.bgColor,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () =>
                  ref.read(favoritesProvider.notifier).toggle(manga),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFav ? AppConstants.accentRed : Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: _CoverHeader(manga: manga),
          ),
        ),

        // Manga info
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Author
                Text(manga.title,
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 4),
                Text('by ${manga.author}',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),

                // Stats row
                Row(
                  children: [
                    _StatChip(
                        icon: Icons.star_rounded,
                        value: manga.rating.toStringAsFixed(1),
                        color: AppConstants.accentGold),
                    const SizedBox(width: 8),
                    _StatChip(
                        icon: Icons.visibility_rounded,
                        value: manga.formattedViews,
                        color: AppConstants.accentPurple),
                    const SizedBox(width: 8),
                    _StatChip(
                        icon: Icons.menu_book_rounded,
                        value: '${manga.chapterCount} ch',
                        color: AppConstants.accentRed),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: manga.status == 'Ongoing'
                            ? AppConstants.accentRed.withOpacity(0.15)
                            : Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        manga.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: manga.status == 'Ongoing'
                              ? AppConstants.accentRed
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Genres
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: manga.genres.map((g) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppConstants.cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppConstants.dividerColor, width: 1),
                    ),
                    child: Text(g,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppConstants.textSecondary)),
                  )).toList(),
                ),

                const SizedBox(height: 16),

                // Description
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        manga.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppConstants.textSecondary,
                          height: 1.6,
                        ),
                        maxLines: _expanded ? null : 3,
                        overflow: _expanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _expanded ? 'Show less' : 'Read more',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppConstants.accentRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Continue / Start button
                if (progress != null) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () => context.push(
                          '/reader/${manga.id}/${progress.chapterId}'),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(
                        'Continue Ch.${progress.chapterNumber} · ${(progress.progress * 100).round()}%',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppConstants.accentRed,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final first = data.chapters.last;
                        context.push('/reader/${manga.id}/${first.id}');
                      },
                      icon: const Icon(Icons.restart_alt_rounded, size: 18),
                      label: const Text('Start from Ch.1'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: AppConstants.dividerColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ] else
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () {
                        final first = data.chapters.last;
                        context.push('/reader/${manga.id}/${first.id}');
                      },
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Start Reading'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppConstants.accentRed,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Chapter list header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Chapters (${manga.chapterCount})',
                        style: Theme.of(context).textTheme.titleMedium),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _sortAscending = !_sortAscending),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppConstants.cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _sortAscending
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 14,
                              color: AppConstants.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _sortAscending ? 'Oldest' : 'Newest',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppConstants.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),
        ),

        // Chapter list
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => _ChapterItem(
              chapter: chapters[i],
              mangaId: manga.id,
              progress: progress,
            ),
            childCount: chapters.length,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _CoverHeader extends StatelessWidget {
  final Manga manga;

  const _CoverHeader({required this.manga});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: manga.coverUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: AppConstants.cardColor),
          errorWidget: (_, __, ___) =>
              Container(color: AppConstants.cardColor),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                AppConstants.bgColor,
              ],
              stops: const [0.4, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _StatChip({required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterItem extends StatelessWidget {
  final Chapter chapter;
  final String mangaId;
  final ReadingProgress? progress;

  const _ChapterItem({
    required this.chapter,
    required this.mangaId,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentChapter = progress?.chapterId == chapter.id;

    return InkWell(
      onTap: () => context.push('/reader/$mangaId/${chapter.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isCurrentChapter
              ? AppConstants.accentRed.withOpacity(0.07)
              : Colors.transparent,
          border: const Border(
            bottom: BorderSide(color: AppConstants.dividerColor, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCurrentChapter
                    ? AppConstants.accentRed.withOpacity(0.15)
                    : AppConstants.cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${chapter.number}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isCurrentChapter
                        ? AppConstants.accentRed
                        : AppConstants.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.displayTitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isCurrentChapter
                          ? AppConstants.accentRed
                          : Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormat('MMM d, yyyy').format(chapter.uploadedAt),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isCurrentChapter)
              const Icon(Icons.play_circle_rounded,
                  color: AppConstants.accentRed, size: 22)
            else
              const Icon(Icons.chevron_right_rounded,
                  color: AppConstants.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 340,
          flexibleSpace: FlexibleSpaceBar(
            background: ShimmerBox(
              width: double.infinity,
              height: 340,
              radius: 0,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 260, height: 24),
                SizedBox(height: 8),
                ShimmerBox(width: 140, height: 14),
                SizedBox(height: 20),
                ChapterListShimmer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
