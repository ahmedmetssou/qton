import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/story.dart';
import 'skeleton_loader.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;
  final double width;
  final double height;

  const StoryCard({
    super.key,
    required this.story,
    required this.onTap,
    this.width = 140,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Cover(story: story, width: width, height: height),
            const SizedBox(height: 8),
            Text(
              story.title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: AppColors.tertiary, size: 12),
                const SizedBox(width: 2),
                Text(
                  story.rating.toStringAsFixed(1),
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11),
                ),
                const SizedBox(width: 6),
                Text(
                  story.genre.first,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, duration: 300.ms, curve: Curves.easeOut);
  }
}

class _Cover extends StatelessWidget {
  final Story story;
  final double width;
  final double height;

  const _Cover(
      {required this.story, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'cover_${story.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: story.coverUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholder: (_, __) => SkeletonBox(
            width: width,
            height: height,
            borderRadius: 12,
          ),
          errorWidget: (_, __, ___) => _FallbackCover(story: story),
        ),
      ),
    );
  }
}

class _FallbackCover extends StatelessWidget {
  final Story story;

  const _FallbackCover({required this.story});

  Color _parseColor() {
    try {
      return Color(
        int.parse(story.accentColor.replaceFirst('#', '0xFF')),
      );
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor();
    return Container(
      color: color.withValues(alpha: 0.3),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.6),
                    color.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Icon(Icons.auto_stories_rounded,
                color: Colors.white.withValues(alpha: 0.3), size: 48),
          ),
        ],
      ),
    );
  }
}

// ─── Wide card (for "all stories" grid) ──────────────────────────────────────

class StoryGridCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;

  const StoryGridCard({super.key, required this.story, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'cover_grid_${story.id}',
                child: CachedNetworkImage(
                  imageUrl: story.coverUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      const SkeletonBox(width: double.infinity, height: 160),
                  errorWidget: (_, __, ___) =>
                      _FallbackCover(story: story),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.tertiary, size: 10),
                      const SizedBox(width: 2),
                      Text(
                        story.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 10),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.forGenre(story.genre.first)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          story.genre.first,
                          style: TextStyle(
                            color: AppColors.forGenre(story.genre.first),
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.95, 0.95), duration: 300.ms);
  }
}
