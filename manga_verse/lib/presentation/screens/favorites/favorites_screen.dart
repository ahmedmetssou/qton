import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/stories_provider.dart';
import '../../widgets/story_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favsAsync = ref.watch(favoritesProvider);
    final storiesAsync = ref.watch(storiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          favsAsync.when(
            data: (favs) => favs.isNotEmpty
                ? TextButton(
                    onPressed: () => _confirmClear(context, ref),
                    child: const Text('Clear all',
                        style: TextStyle(color: AppColors.error)),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: favsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: Text('Error loading favorites',
              style: TextStyle(color: AppColors.textMuted)),
        ),
        data: (favoriteIds) {
          if (favoriteIds.isEmpty) return _EmptyState();

          final allStories = storiesAsync.valueOrNull ?? [];
          final favStories = allStories
              .where((s) => favoriteIds.contains(s.id))
              .toList();

          if (favStories.isEmpty) return _EmptyState();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: favStories.length,
            itemBuilder: (context, i) => StoryGridCard(
              story: favStories[i],
              onTap: () => context.push('/story/${favStories[i].id}'),
            ).animate(delay: (i * 50).ms).fadeIn().slideY(begin: 0.1),
          );
        },
      ),
    );
  }

  void _confirmClear(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Clear Favorites',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text('Remove all favorites?',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // clear all favorites one by one
              final favs =
                  ref.read(favoritesProvider).valueOrNull ?? [];
              for (final id in [...favs]) {
                ref.read(favoritesProvider.notifier).toggle(id);
              }
            },
            child: const Text('Clear',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded,
              color: AppColors.textMuted, size: 72),
          SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the heart icon on any story\nto save it here.',
            style:
                TextStyle(color: AppColors.textMuted, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .scale(begin: const Offset(0.9, 0.9)),
    );
  }
}
