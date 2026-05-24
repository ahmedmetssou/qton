import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../shared/models/chapter.dart';

class ContinueReadingCard extends StatelessWidget {
  final ReadingProgress progress;

  const ContinueReadingCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push('/reader/${progress.mangaId}/${progress.chapterId}'),
      child: Container(
        width: 280,
        height: 88,
        decoration: BoxDecoration(
          color: AppConstants.cardColor,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          border: Border.all(
            color: AppConstants.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Cover
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.cardRadius),
                bottomLeft: Radius.circular(AppConstants.cardRadius),
              ),
              child: CachedNetworkImage(
                imageUrl: progress.mangaCover,
                width: 64,
                height: 88,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    const ShimmerBox(width: 64, height: 88, radius: 0),
                errorWidget: (_, __, ___) => Container(
                  width: 64,
                  height: 88,
                  color: AppConstants.surfaceColor,
                  child: const Icon(Icons.image_rounded,
                      color: AppConstants.textSecondary, size: 20),
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      progress.mangaTitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Chapter ${progress.chapterNumber}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                    // Progress bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress.progress,
                            backgroundColor:
                                AppConstants.dividerColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppConstants.accentRed),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${(progress.progress * 100).round()}% complete',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Arrow
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppConstants.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
