import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_constants.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppConstants.cardColor,
      highlightColor: const Color(0xFF2A2A4A),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppConstants.cardColor,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class MangaCardShimmer extends StatelessWidget {
  const MangaCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(
          width: 130,
          height: 190,
          radius: AppConstants.cardRadius,
        ),
        const SizedBox(height: 8),
        const ShimmerBox(width: 110, height: 12),
        const SizedBox(height: 4),
        const ShimmerBox(width: 70, height: 10),
      ],
    );
  }
}

class HeroShimmer extends StatelessWidget {
  const HeroShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return ShimmerBox(
      width: w,
      height: 260,
      radius: 0,
    );
  }
}

class ChapterListShimmer extends StatelessWidget {
  const ChapterListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        6,
        (i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              const ShimmerBox(width: 50, height: 50, radius: 8),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: 160, height: 12),
                  SizedBox(height: 6),
                  ShimmerBox(width: 100, height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
