import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// IndiaMART logo: uses asset when available, else text fallback.
/// Place your logo at assets/images/indiamart_logo.png (white/transparent bg for header).
const String kIndiamartLogoAsset = 'assets/images/indiamart_logo.png';

class IndiamartLogo extends StatelessWidget {
  /// Height of the logo. Width scales to preserve aspect ratio.
  final double height;
  /// For use on dark/teal background (e.g. header). When true, no background tint.
  final bool forDarkBackground;
  /// When true, show compact version (icon only, smaller).
  final bool compact;

  const IndiamartLogo({
    super.key,
    this.height = 40,
    this.forDarkBackground = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      kIndiamartLogoAsset,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _buildTextFallback(context),
    );
  }

  Widget _buildTextFallback(BuildContext context) {
    if (compact) {
      return Container(
        width: height,
        height: height,
        decoration: BoxDecoration(
          color: forDarkBackground ? Colors.white.withValues(alpha: 0.2) : AppColors.headerTeal,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'IM',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: height * 0.9,
          height: height,
          decoration: BoxDecoration(
            color: forDarkBackground ? Colors.white.withValues(alpha: 0.2) : AppColors.headerTeal,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'IM',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(width: height * 0.25),
        RichText(
          text: TextSpan(
            style: (AppTypography.textTheme.headlineSmall ?? const TextStyle()).copyWith(
              color: forDarkBackground ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            children: const [
              TextSpan(text: 'india'),
              TextSpan(text: 'm', style: TextStyle(fontWeight: FontWeight.w800)),
              TextSpan(text: 'a', style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.w800)),
              TextSpan(text: 'rt'),
              TextSpan(text: '®', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}
