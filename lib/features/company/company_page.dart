import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_network_image.dart';
import '../../data/models/company.dart';
import 'widgets/company_gallery.dart';
import 'widgets/company_hero.dart';
import 'widgets/company_tabs.dart';

class CompanyPage extends StatefulWidget {
  final CompanyProfile profile;
  final bool showSkeleton;

  const CompanyPage({
    super.key,
    required this.profile,
    this.showSkeleton = false,
  });

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.showSkeleton) {
      return Scaffold(
        appBar: AppBar(title: const Text('Company')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final profile = widget.profile;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CompanyHero(
              profile: profile,
              onContact: () => _snack('Contact Company'),
              onGetBestPrice: () => _snack('Get Best Price'),
              onFollow: () => _snack('Following ${profile.name}'),
            ),
          ),
          SliverToBoxAdapter(
            child: CompanyTabs(
              selectedIndex: _tabIndex,
              onTap: (i) => setState(() => _tabIndex = i),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildTabContent(profile),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(CompanyProfile profile) {
    switch (_tabIndex) {
      case 0:
        return _buildProducts(profile);
      case 1:
        return _buildAbout(profile);
      case 2:
        return _buildCategoriesPlaceholder();
      case 3:
        return CompanyGallery(
          imageUrls: profile.galleryUrls,
          onImageTap: (i) => _snack('Gallery image $i'),
        );
      case 4:
        return _buildVideoPlaceholder();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildProducts(CompanyProfile profile) {
    if (profile.products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text('No products yet', style: AppTypography.textTheme.bodyLarge),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: profile.products.length,
        itemBuilder: (context, i) {
          final p = profile.products[i];
          return _companyProductListCard(p);
        },
      ),
    );
  }

  Widget _companyProductListCard(CompanyProduct p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppNetworkImage(
                    imageUrl: p.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: AppTypography.textTheme.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.priceRange,
                        style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
                      ),
                      if (p.specifications != null && p.specifications!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        ...p.specifications!.take(3).map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            '${e.key}: ${e.value}',
                            style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _snack('Call Now: ${p.name}'),
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Call Now'),
                    style: FilledButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 10)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _snack('Get Price: ${p.name}'),
                    icon: Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.accent),
                    label: Text('Get Price', style: TextStyle(color: AppColors.accent)),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.accent), padding: const EdgeInsets.symmetric(vertical: 10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesPlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(child: Text('Categories', style: AppTypography.textTheme.bodyLarge)),
    );
  }

  Widget _buildVideoPlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(child: Text('Video', style: AppTypography.textTheme.bodyLarge)),
    );
  }

  Widget _buildAbout(CompanyProfile profile) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.about ?? 'No description available.',
            style: AppTypography.textTheme.bodyMedium,
          ),
          AppSpacing.gapXl,
          Text('Location', style: AppTypography.textTheme.titleSmall),
          AppSpacing.gapSm,
          Text(profile.location, style: AppTypography.textTheme.bodyMedium),
        ],
      ),
    );
  }


  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}
