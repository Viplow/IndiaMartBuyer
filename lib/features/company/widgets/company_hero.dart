import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/company.dart';

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
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 280,
          child: CachedNetworkImage(
            imageUrl: profile.bannerUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: AppColors.surfaceVariant),
            errorWidget: (context, url, error) => Container(color: AppColors.surfaceVariant, child: const Icon(Icons.business_center, size: 64)),
          ),
        ),
        Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: profile.logoUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Icon(Icons.business),
                    ),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                profile.name,
                                style: AppTypography.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (profile.verified) ...[
                              const SizedBox(width: 6),
                              Icon(Icons.verified, color: AppColors.verified, size: 22),
                            ],
                          ],
                        ),
                        if (profile.tagline != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            profile.tagline!,
                            style: AppTypography.textTheme.bodySmall?.copyWith(color: Colors.white70),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _chip(Icons.schedule, profile.yearsInBusiness),
                            if (profile.rating != null) _chip(Icons.star_rounded, profile.rating!),
                            ...profile.certifications.take(2).map((c) => _chip(Icons.verified_user_outlined, c)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onContact,
                      icon: const Icon(Icons.mail_outline, size: 18),
                      label: const Text('Contact Company'),
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  ),
                  AppSpacing.gapSm,
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onGetBestPrice,
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white70), padding: const EdgeInsets.symmetric(vertical: 12)),
                      icon: const Icon(Icons.request_quote, size: 18),
                      label: const Text('Get Best Price'),
                    ),
                  ),
                  AppSpacing.gapSm,
                  IconButton.filled(
                    onPressed: onFollow,
                    style: IconButton.styleFrom(backgroundColor: Colors.white24, foregroundColor: Colors.white),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: AppTypography.textTheme.bodySmall?.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
