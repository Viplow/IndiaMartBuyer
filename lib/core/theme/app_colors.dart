import 'package:flutter/material.dart';

/// Neutral, professional B2B palette with subtle brand accents.
abstract class AppColors {
  // Primary
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Neutrals
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFE5E7EB);

  // Brand accent (blue – professional, trust)
  static const Color accent = Color(0xFF2563EB);
  static const Color accentLight = Color(0xFFEFF6FF);
  static const Color accentDark = Color(0xFF1D4ED8);

  // Secondary accent (green – verified, success)
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color verified = Color(0xFF059669);

  // Cards & shadows
  static const Color cardBackground = Colors.white;
  static const Color chipBackground = Color(0xFFF3F4F6);
  static const Color chipSelected = Color(0xFFEFF6FF);

  // Home screen (image design)
  static const Color headerBlue = Color(0xFF1E3A5F);
  static const Color headerBlueDark = Color(0xFF152942);
  /// IndiaMART header background (#1d8480)
  static const Color headerTeal = Color(0xFF1D8480);
  static const Color ctaOrange = Color(0xFFE85D04);
  static const Color ctaOrangeDark = Color(0xFFD54D02);
}
