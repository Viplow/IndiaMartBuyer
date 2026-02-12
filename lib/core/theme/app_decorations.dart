import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppDecorations {
  static BoxDecoration card({
    Color? color,
    double borderRadius = 16,
    List<BoxShadow>? shadow,
  }) =>
      BoxDecoration(
        color: color ?? AppColors.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadow ?? cardShadow,
      );

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get cardShadowHover => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
          spreadRadius: 0,
        ),
      ];

  static BoxDecoration chip({bool selected = false}) => BoxDecoration(
        color: selected ? AppColors.chipSelected : AppColors.chipBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? AppColors.accent : Colors.transparent,
          width: 1,
        ),
      );

  static RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );
}
