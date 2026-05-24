import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/chapter.dart';

class ChapterListTile extends StatelessWidget {
  final Chapter chapter;
  final int? savedPage;
  final VoidCallback onTap;
  final VoidCallback? onUnlock;

  const ChapterListTile({
    super.key,
    required this.chapter,
    required this.onTap,
    this.savedPage,
    this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    final hasProgress = savedPage != null && savedPage! > 0;

    return GestureDetector(
      onTap: chapter.isLocked ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${chapter.number}',
                  style: TextStyle(
                    color: chapter.isLocked
                        ? AppColors.textMuted
                        : AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
                    chapter.title,
                    style: TextStyle(
                      color: chapter.isLocked
                          ? AppColors.textMuted
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${chapter.pagesCount} pages  ·  ${chapter.publishedAt}',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12),
                  ),
                  if (hasProgress) ...[
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: savedPage! / chapter.pagesCount,
                        backgroundColor: AppColors.surface,
                        color: AppColors.primary,
                        minHeight: 3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (chapter.isLocked)
              GestureDetector(
                onTap: onUnlock,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.tertiary, Color(0xFFFF8C00)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_circle_fill,
                          color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Unlock',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Icon(
                hasProgress ? Icons.replay_rounded : Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}
