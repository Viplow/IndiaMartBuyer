import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_network_image.dart';

/// Product detail page (image 2): large image, specs, description, Call Now / Get Price.
class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String price;
  final String supplierName;
  final String description;
  final List<MapEntry<String, String>>? specifications;

  const ProductPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.supplierName,
    this.description = '',
    this.specifications,
  });

  @override
  Widget build(BuildContext context) {
    final specs = specifications ?? _defaultSpecs();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 18, color: AppColors.textTertiary),
                  const SizedBox(width: 8),
                  Text('Search IndiaMART', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
              IconButton(icon: const Icon(Icons.mic_none), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImageSection(context),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(price, style: AppTypography.textTheme.headlineSmall?.copyWith(color: AppColors.accent)),
                      const SizedBox(height: 24),
                      _buildSection('Product Specifications', Icons.remove, specs, _buildSpecTable(specs)),
                      const SizedBox(height: 16),
                      _buildSection('Product Description', Icons.remove, null, _buildDescription()),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  List<MapEntry<String, String>> _defaultSpecs() => const [
        MapEntry('Automation Grade', 'Automatic'),
        MapEntry('Item Condition', 'New'),
        MapEntry('Power Consumption', '7KW'),
        MapEntry('Brand', 'Prakash Offset'),
        MapEntry('Country of Origin', 'Made in India'),
      ];

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1.1,
          child: AppNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == 0 ? AppColors.headerTeal : AppColors.textTertiary.withValues(alpha: 0.5),
              ),
            )),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 12,
          child: Icon(Icons.videocam_outlined, color: Colors.white, size: 28),
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, List<MapEntry<String, String>>? specs, Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 16),
        title: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(title, style: AppTypography.textTheme.titleMedium),
          ],
        ),
        children: [child],
      ),
    );
  }

  Widget _buildSpecTable(List<MapEntry<String, String>> specs) {
    return Table(
      columnWidths: const {0: FlexColumnWidth(0.45), 1: FlexColumnWidth(0.55)},
      children: specs.map((e) => TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(e.key, style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(e.value, style: AppTypography.textTheme.bodySmall),
          ),
        ],
      )).toList(),
    );
  }

  Widget _buildDescription() {
    final text = description.isEmpty
        ? 'PC-950 paper cup machine is improved based on the normal chain driving type. In this machine paper-feeding, cup-fan-wall sealing, oiling, bottom punching, heating, rolling, rimming, rounding and finishing are fully automated for high output.'
        : description;
    return Text(text, style: AppTypography.textTheme.bodyMedium);
  }

  Widget _buildBottomActions(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone, size: 20),
                label: const Text('Call Now'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.chat_bubble_outline, size: 20, color: AppColors.accent),
                label: Text('Get Price', style: TextStyle(color: AppColors.accent)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.accent),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
