import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/company.dart';

/// Company header (image 3): name, circular logo, metrics, TrustSEAL, Contact Supplier.
class CompanyHero extends StatelessWidget {
  final CompanyProfile profile;
  final VoidCallback? onContact;
  final VoidCallback? onGetBestPrice;
  final VoidCallback? onFollow;

  const CompanyHero({
    super.key,
    required this.profile,
    this.onContact,
    this.onGetBestPrice,
    this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.name,
            style: AppTypography.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: profile.logoUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => const Icon(Icons.business, size: 48),
                  ),
                ),
                if (profile.tagline != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    profile.tagline!,
                    style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (profile.responseRate != null)
                _metricChip('${profile.responseRate} Response rate'),
              if (profile.rating != null)
                _metricChip('${profile.rating} (${profile.ratingCount ?? "0"}) Ratings'),
              _metricChip('${profile.yearsInBusiness} Member since'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(profile.location, style: AppTypography.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.check_circle, size: 18, color: AppColors.verified),
              const SizedBox(width: 6),
              Text('Mobile', style: AppTypography.textTheme.bodySmall),
              const SizedBox(width: 16),
              Icon(Icons.check_circle, size: 18, color: AppColors.verified),
              const SizedBox(width: 6),
              Text('Email', style: AppTypography.textTheme.bodySmall),
            ],
          ),
          if (profile.gstNumber != null) ...[
            const SizedBox(height: 8),
            Text(profile.gstNumber!, style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade700),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 18, color: Colors.amber.shade800),
                const SizedBox(width: 6),
                Text('TrustSEAL', style: AppTypography.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onContact,
                  icon: Icon(Icons.call_outlined, size: 18, color: AppColors.headerTeal),
                  label: Text('Call Now', style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.headerTeal, fontWeight: FontWeight.w600)),
                  style: AppDecorations.ctaOutlinedStyle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onGetBestPrice,
                  icon: Icon(Icons.local_offer_outlined, size: 18, color: AppColors.headerTeal),
                  label: Text('Get Best Price', style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.headerTeal, fontWeight: FontWeight.w600)),
                  style: AppDecorations.ctaOutlinedStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricChip(String text) {
    return Text(
      text,
      style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
