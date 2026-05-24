import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../../../shared/models/manga.dart';

class HeroCarousel extends StatefulWidget {
  final List<Manga> items;

  const HeroCarousel({super.key, required this.items});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  late final PageController _pageController;
  int _current = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_current + 1) % widget.items.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const HeroShimmer();
    return SizedBox(
      height: 260,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, i) => _HeroItem(manga: widget.items[i]),
          ),
          // Page indicator
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: widget.items.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: AppConstants.accentRed,
                  dotColor: Colors.white.withValues(alpha: 0.35),
                  dotHeight: 6,
                  dotWidth: 6,
                  expansionFactor: 2.5,
                  spacing: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroItem extends StatelessWidget {
  final Manga manga;

  const _HeroItem({required this.manga});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/manga/${manga.id}'),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: manga.coverUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => const HeroShimmer(),
            errorWidget: (_, __, ___) => Container(
              color: AppConstants.cardColor,
              child: const Icon(
                Icons.image_rounded,
                size: 48,
                color: AppConstants.textSecondary,
              ),
            ),
          ),
          // Gradient overlay
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppConstants.bgColor.withValues(alpha: 0.3),
                  AppConstants.bgColor.withValues(alpha: 0.85),
                  AppConstants.bgColor,
                ],
                stops: const [0.0, 0.4, 0.75, 1.0],
              ),
            ),
          ),
          // Side gradient for dark look
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppConstants.bgColor.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Info
          Positioned(
            bottom: 30,
            left: 20,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Genre chips
                Wrap(
                  spacing: 4,
                  children: manga.genres
                      .take(2)
                      .map(
                        (g) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.accentRed.withValues(
                              alpha: 0.85,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            g,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                Text(
                  manga.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: AppConstants.accentGold,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      manga.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppConstants.accentGold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${manga.formattedViews} views',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Read button
          Positioned(
            bottom: 36,
            right: 20,
            child: GestureDetector(
              onTap: () => context.push('/manga/${manga.id}'),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppConstants.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.accentRed.withValues(alpha: 0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
