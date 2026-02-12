import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/company.dart';
import 'widgets/company_gallery.dart';
import 'widgets/company_hero.dart';
import 'widgets/company_product_card.dart';
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
        return CompanyGallery(
          imageUrls: profile.galleryUrls,
          onImageTap: (i) => _snack('Gallery image $i'),
        );
      case 2:
        return _buildAbout(profile);
      case 3:
        return _buildReviews();
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
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.78,
        ),
        itemCount: profile.products.length,
        itemBuilder: (context, i) {
          final p = profile.products[i];
          return CompanyProductCard(
            product: p,
            onTap: () => _snack(p.name),
            onGetPrice: () => _snack('Get Best Price: ${p.name}'),
          );
        },
      ),
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

  Widget _buildReviews() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Center(
        child: Text('Reviews coming soon', style: AppTypography.textTheme.bodyLarge),
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}
