import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF050712);
  static const Color card = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceVariant = Color(0xFF1C2333);

  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF9B4DFF);
  static const Color secondary = Color(0xFF06B6D4);
  static const Color tertiary = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color hot = Color(0xFFFF4757);

  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static const Color glassBackground = Color(0x0DFFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);

  static const Map<String, Color> genreColors = {
    'Action': Color(0xFFEF4444),
    'Romance': Color(0xFFEC4899),
    'Fantasy': Color(0xFF7C3AED),
    'Horror': Color(0xFF1C1C2E),
    'Comedy': Color(0xFFF59E0B),
    'Sci-Fi': Color(0xFF06B6D4),
    'Sports': Color(0xFF10B981),
    'Supernatural': Color(0xFF8B5CF6),
    'Mystery': Color(0xFF6366F1),
    'Slice of Life': Color(0xFFFB923C),
  };

  static Color forGenre(String genre) =>
      genreColors[genre] ?? primary;
}
