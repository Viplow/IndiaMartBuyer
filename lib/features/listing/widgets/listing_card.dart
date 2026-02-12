import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/listing_item.dart';

class ListingCard extends StatelessWidget {
  final ListingItem item;
  final VoidCallback? onGetBestPrice;
  final VoidCallback? onContactSupplier;
  final VoidCallback? onTap;

  const ListingCard({
    super.key,
    required this.item,
    this.onGetBestPrice,
    this.onContactSupplier,
    this.onTap,
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
              _buildImage(),
              Padding(
                padding: AppSpacing.paddingCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapSm,
                    Text(
                      item.priceRange,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapXs,
                    Text(
                      item.moq,
                      style: AppTypography.textTheme.bodySmall,
                      maxLines: 1,
                    ),
                    AppSpacing.gapMd,
                    _buildSupplierRow(context),
                    AppSpacing.gapLg,
                    _buildActions(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 1.15,
      child: CachedNetworkImage(
        imageUrl: item.imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.surfaceVariant,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.surfaceVariant,
          child: const Icon(Icons.image_not_supported_outlined, size: 48, color: AppColors.textTertiary),
        ),
      ),
    );
  }

  Widget _buildSupplierRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  item.supplierName,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (item.verified) ...[
                const SizedBox(width: 4),
                Icon(Icons.verified, size: 14, color: AppColors.verified),
              ],
            ],
          ),
        ),
        Icon(Icons.location_on_outlined, size: 14, color: AppColors.textTertiary),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            item.location.split(',').first,
            style: AppTypography.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onContactSupplier,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              minimumSize: Size.zero,
            ),
            child: const Text('Contact Supplier'),
          ),
        ),
        AppSpacing.gapSm,
        Expanded(
          child: FilledButton(
            onPressed: onGetBestPrice,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              minimumSize: Size.zero,
            ),
            child: const Text('Get Best Price'),
          ),
        ),
      ],
    );
  }
}
