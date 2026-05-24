import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/story.dart';
import '../../../domain/entities/chapter.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/reading_progress_provider.dart';
import '../../providers/stories_provider.dart';
import '../../widgets/chapter_list_tile.dart';

class StoryDetailScreen extends ConsumerWidget {
  final String storyId;

  const StoryDetailScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsync = ref.watch(storyByIdProvider(storyId));
    final chaptersAsync = ref.watch(chaptersForStoryProvider(storyId));

    return storyAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) =>
          const Scaffold(body: Center(child: Text('Story not found'))),
      data: (story) {
        if (story == null) {
          return const Scaffold(
              body: Center(child: Text('Story not found')));
        }
        return _DetailBody(
          story: story,
          chaptersAsync: chaptersAsync,
        );
      },
    );
  }
}

class _DetailBody extends ConsumerWidget {
  final Story story;
  final AsyncValue<List<Chapter>> chaptersAsync;

  const _DetailBody({required this.story, required this.chaptersAsync});

  Color _accent() {
    try {
      return Color(int.parse(story.accentColor.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).when(
          data: (list) => list.contains(story.id),
          loading: () => false,
          error: (_, __) => false,
        );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _SliverHeader(story: story, accent: _accent(), isFav: isFav),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MetaRow(story: story),
                  const SizedBox(height: 16),
                  _TagsRow(story: story),
                  const SizedBox(height: 16),
                  const Text(
                    'Synopsis',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    story.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Chapters',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          chaptersAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
            data: (chapters) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final chapter = chapters[i];
                    final progress = ref
                        .read(readingProgressProvider.notifier)
                        .getProgress(chapter.id);

                    return ChapterListTile(
                      chapter: chapter,
                      savedPage: progress,
                      onTap: () => context.push(
                          '/reader/${story.id}/${chapter.id}'),
                    ).animate(delay: (i * 50).ms).fadeIn().slideX(begin: 0.1);
                  },
                  childCount: chapters.length,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

}

class _SliverHeader extends ConsumerWidget {
  final Story story;
  final Color accent;
  final bool isFav;

  const _SliverHeader(
      {required this.story, required this.accent, required this.isFav});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black45,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 18),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? AppColors.error : Colors.white,
              size: 20,
            ),
          ),
          onPressed: () =>
              ref.read(favoritesProvider.notifier).toggle(story.id),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'cover_${story.id}',
              child: CachedNetworkImage(
                imageUrl: story.coverUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: AppColors.surface),
                errorWidget: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accent.withValues(alpha: 0.5), AppColors.background],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background,
                    ],
                    stops: [0.5, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Text(
                story.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Story story;

  const _MetaRow({required this.story});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetaItem(
          icon: Icons.star_rounded,
          value: story.rating.toStringAsFixed(1),
          color: AppColors.tertiary,
        ),
        const SizedBox(width: 16),
        _MetaItem(
          icon: Icons.remove_red_eye_outlined,
          value: story.formattedViews,
          color: AppColors.secondary,
        ),
        const SizedBox(width: 16),
        _MetaItem(
          icon: Icons.menu_book_rounded,
          value: '${story.chaptersCount} ch',
          color: AppColors.primary,
        ),
        const Spacer(),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: story.status == 'Completed'
                ? AppColors.secondary.withValues(alpha: 0.2)
                : AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: story.status == 'Completed'
                  ? AppColors.secondary
                  : AppColors.primary,
            ),
          ),
          child: Text(
            story.status,
            style: TextStyle(
              color: story.status == 'Completed'
                  ? AppColors.secondary
                  : AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _MetaItem(
      {required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(value,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }
}

class _TagsRow extends StatelessWidget {
  final Story story;

  const _TagsRow({required this.story});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ...story.genre.map((g) => _Tag(label: g, isPrimary: true)),
        ...story.tags.take(4).map((t) => _Tag(label: t, isPrimary: false)),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final bool isPrimary;

  const _Tag({required this.label, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.forGenre(label).withValues(alpha: 0.15)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPrimary
              ? AppColors.forGenre(label).withValues(alpha: 0.5)
              : AppColors.glassBorder,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary
              ? AppColors.forGenre(label)
              : AppColors.textSecondary,
          fontSize: 12,
          fontWeight:
              isPrimary ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
