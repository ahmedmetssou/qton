import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Toom';
  static const String appVersion = '1.0.0';

  // SharedPreferences keys
  static const String keyOnboardingSeen = 'onboarding_seen';
  static const String keyFavorites = 'favorites';
  static const String keyHistory = 'history';
  static const String keyReadingProgress = 'reading_progress';

  // Design
  static const double cardRadius = 16.0;
  static const double pageHPadding = 16.0;

  // Colors (dark cinematic palette)
  static const Color bgColor = Color(0xFF09090F);
  static const Color surfaceColor = Color(0xFF111120);
  static const Color cardColor = Color(0xFF1A1A2E);
  static const Color accentRed = Color(0xFFE94560);
  static const Color accentPurple = Color(0xFF7B2FBE);
  static const Color accentGold = Color(0xFFFFD060);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A8A9A);
  static const Color dividerColor = Color(0xFF2A2A3E);

  static const Gradient primaryGradient = LinearGradient(
    colors: [accentRed, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF0D0D1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
