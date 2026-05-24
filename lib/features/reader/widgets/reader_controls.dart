import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/chapter.dart';

class ReaderTopBar extends StatelessWidget {
  final String mangaTitle;
  final String chapterTitle;

  const ReaderTopBar({
    super.key,
    required this.mangaTitle,
    required this.chapterTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.85),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    Text(
                      mangaTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      chapterTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReaderBottomBar extends StatelessWidget {
  final double progress;
  final Chapter? prevChapter;
  final Chapter? nextChapter;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const ReaderBottomBar({
    super.key,
    required this.progress,
    this.prevChapter,
    this.nextChapter,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.9),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar
              Row(
                children: [
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                        fontSize: 11, color: AppConstants.textSecondary),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor:
                            Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppConstants.accentRed),
                        minHeight: 4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Chapter navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavButton(
                    label: 'Previous',
                    icon: Icons.skip_previous_rounded,
                    enabled: prevChapter != null,
                    onTap: onPrev,
                  ),
                  Text(
                    'Ch.${prevChapter != null ? prevChapter!.number + 1 : nextChapter != null ? nextChapter!.number - 1 : "?"}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  _NavButton(
                    label: 'Next',
                    icon: Icons.skip_next_rounded,
                    enabled: nextChapter != null,
                    onTap: onNext,
                    isNext: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;
  final bool isNext;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.enabled,
    this.onTap,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: enabled
              ? AppConstants.accentRed.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled
                ? AppConstants.accentRed.withOpacity(0.4)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: isNext
              ? [
                  Text(label,
                      style: TextStyle(
                          fontSize: 13,
                          color:
                              enabled ? Colors.white : AppConstants.textSecondary,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  Icon(icon, size: 18,
                      color:
                          enabled ? Colors.white : AppConstants.textSecondary),
                ]
              : [
                  Icon(icon, size: 18,
                      color:
                          enabled ? Colors.white : AppConstants.textSecondary),
                  const SizedBox(width: 4),
                  Text(label,
                      style: TextStyle(
                          fontSize: 13,
                          color:
                              enabled ? Colors.white : AppConstants.textSecondary,
                          fontWeight: FontWeight.w600)),
                ],
        ),
      ),
    );
  }
}
