import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/error_view.dart';
import '../../shared/providers/favorites_provider.dart';
import '../home/widgets/manga_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      appBar: AppBar(
        title: const Text('Saved'),
        actions: [
          if (favorites.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, ref),
              child: const Text(
                'Clear all',
                style: TextStyle(color: AppConstants.textSecondary),
              ),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? const EmptyView(
              title: 'No saved manga yet',
              subtitle:
                  'Tap the heart icon on any manga\nto save it here for later.',
              icon: Icons.favorite_border_rounded,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Text(
                    '${favorites.length} manga saved',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, i) =>
                        MangaGridCard(manga: favorites[i]),
                  ).animate().fadeIn(duration: 300.ms),
                ),
              ],
            ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardColor,
        title: const Text('Clear favorites?'),
        content: const Text(
          'This will remove all saved manga from your list.',
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
      // Toggle each favorite off
      final fav = ref.read(favoritesProvider);
      for (final m in fav) {
        ref.read(favoritesProvider.notifier).toggle(m);
      }
    }
  }
}
