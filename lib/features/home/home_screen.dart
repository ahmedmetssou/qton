import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../../core/widgets/error_view.dart';
import '../../shared/providers/history_provider.dart';
import 'providers/home_provider.dart';
import 'widgets/hero_carousel.dart';
import 'widgets/manga_card.dart';
import 'widgets/section_header.dart';
import 'widgets/continue_reading_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeProvider);
    final history = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      body: RefreshIndicator(
        color: AppConstants.accentRed,
        backgroundColor: AppConstants.cardColor,
        onRefresh: () => ref.read(homeProvider.notifier).refresh(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App bar
            SliverAppBar(
              floating: true,
              backgroundColor: AppConstants.bgColor,
              title: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: AppConstants.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'T',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('TOOM',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 3)),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () => context.go('/search'),
                ),
                const SizedBox(width: 4),
              ],
            ),

            homeAsync.when(
              loading: () => SliverList(
                delegate: SliverChildListDelegate([
                  const HeroShimmer(),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(width: 100, height: 14),
                        ShimmerBox(width: 60, height: 12),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: List.generate(
                        4,
                        (_) => const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: MangaCardShimmer(),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              error: (e, _) => SliverFillRemaining(
                child: ErrorView(
                  message: 'Failed to load content.\nPlease try again.',
                  onRetry: () => ref.read(homeProvider.notifier).refresh(),
                ),
              ),
              data: (data) => SliverList(
                delegate: SliverChildListDelegate([
                  // Hero carousel
                  HeroCarousel(items: data.trending),

                  const SizedBox(height: 24),

                  // Continue Reading
                  if (history.isNotEmpty) ...[
                    SectionHeader(
                      title: 'Continue Reading',
                      actionLabel: 'History',
                      onAction: () => context.go('/history'),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 88,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: history.take(5).length,
                        itemBuilder: (context, i) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ContinueReadingCard(
                            progress: history.elementAt(i),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 24),
                  ],

                  // Trending
                  SectionHeader(
                    title: '🔥 Trending Now',
                    actionLabel: 'See all',
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: data.trending.length,
                      itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: MangaCard(manga: data.trending[i]),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // New arrivals
                  if (data.newArrivals.isNotEmpty) ...[
                    SectionHeader(
                      title: '✨ New Arrivals',
                      actionLabel: 'See all',
                      onAction: () {},
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: data.newArrivals.length,
                        itemBuilder: (context, i) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: MangaCard(manga: data.newArrivals[i]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Latest Updates
                  SectionHeader(
                    title: '🕒 Latest Updates',
                    actionLabel: 'See all',
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: data.latest.length,
                      itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: MangaCard(manga: data.latest[i]),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // All Manga grid
                  SectionHeader(
                    title: '📚 Browse All',
                    actionLabel: null,
                    onAction: null,
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.55,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: data.allManga.length,
                      itemBuilder: (context, i) =>
                          MangaGridCard(manga: data.allManga[i]),
                    ),
                  ),

                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
