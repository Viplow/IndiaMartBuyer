import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/company.dart';

class CompanyProductCard extends StatelessWidget {
  final CompanyProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onGetPrice;

  const CompanyProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onGetPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: AppDecorations.card(),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: AppColors.surfaceVariant),
                  errorWidget: (context, url, error) => Container(color: AppColors.surfaceVariant, child: const Icon(Icons.image)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTypography.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapXs,
                    Text(
                      product.priceRange,
                      style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
                    ),
                    if (product.moq != null) ...[
                      AppSpacing.gapXs,
                      Text('MOQ: ${product.moq}', style: AppTypography.textTheme.bodySmall),
                    ],
                    AppSpacing.gapSm,
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: onGetPrice,
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 6), foregroundColor: AppColors.accent),
                        child: const Text('Get Best Price'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
