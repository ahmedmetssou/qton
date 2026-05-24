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
import '../../shared/providers/history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      appBar: AppBar(
        title: const Text('Reading History'),
        actions: [
          if (history.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, ref),
              child: const Text(
                'Clear',
                style: TextStyle(color: AppConstants.textSecondary),
              ),
            ),
        ],
      ),
      body: history.isEmpty
          ? const EmptyView(
              title: 'No reading history',
              subtitle:
                  'Start reading any manga and\nyour progress will appear here.',
              icon: Icons.history_rounded,
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: history.length,
              itemBuilder: (context, i) =>
                  _HistoryItem(progress: history[i], index: i),
            ).animate().fadeIn(duration: 300.ms),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardColor,
        title: const Text('Clear history?'),
        content: const Text(
          'This will remove all reading history and progress.',
          style: TextStyle(color: AppConstants.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
                backgroundColor: AppConstants.accentRed),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(historyProvider.notifier).clearAll();
    }
  }
}

class _HistoryItem extends StatelessWidget {
  final ReadingProgress progress;
  final int index;

  const _HistoryItem({required this.progress, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push('/reader/${progress.mangaId}/${progress.chapterId}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppConstants.cardColor,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          border: Border.all(color: AppConstants.dividerColor, width: 1),
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
                width: 70,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    const ShimmerBox(width: 70, height: 100, radius: 0),
                errorWidget: (_, __, ___) => Container(
                  width: 70,
                  height: 100,
                  color: AppConstants.surfaceColor,
                  child: const Icon(Icons.image_rounded,
                      color: AppConstants.textSecondary, size: 20),
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      progress.mangaTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chapter ${progress.chapterNumber}: ${progress.chapterTitle}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.progress,
                        backgroundColor: AppConstants.dividerColor,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppConstants.accentRed),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(progress.progress * 100).round()}% read',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                        Text(
                          _formatTime(progress.timestamp),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.play_circle_rounded,
                  color: AppConstants.accentRed, size: 28),
            ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: index * 60))
          .fadeIn(duration: 300.ms)
          .slideX(begin: 0.1, end: 0),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dt);
  }
}
