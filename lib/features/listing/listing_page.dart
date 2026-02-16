import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/indiamart_logo.dart';
import '../../data/mock_data.dart';
import '../../data/models/listing_item.dart';
import 'widgets/empty_state.dart';
import 'widgets/listing_card.dart';
import 'widgets/listing_skeleton.dart';
import '../company/company_page.dart';

class ListingPage extends StatefulWidget {
  /// Optional SDUI payload: if provided, listings are built from JSON.
  final List<Map<String, dynamic>>? sduiListings;
  final bool useSkeleton;
  final bool emptyState;

  const ListingPage({
    super.key,
    this.sduiListings,
    this.useSkeleton = false,
    this.emptyState = false,
  });

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  List<ListingItem> _listings = [];
  bool _loading = true;
  String _locationFilter = 'Noida';
  String _categoryFilter = 'Rice';
  String _priceFilter = 'Upto ₹100';
  String _priceFilter2 = '₹100';
  static const List<String> _locations = ['Noida', 'Delhi', 'Mumbai', 'Bangalore', 'Chennai'];
  static const List<String> _categories = ['Rice', 'Electronics', 'Machinery', 'Chemicals', 'Textiles'];
  static const List<String> _priceRanges = ['Upto ₹100', 'Upto ₹500', 'Upto ₹1,000'];
  static const List<String> _priceExact = ['₹100', '₹500', '₹1,000'];

  @override
  void initState() {
    super.initState();
    if (widget.useSkeleton) {
      _loading = true;
      _listings = [];
    } else if (widget.emptyState) {
      _loading = false;
      _listings = [];
    } else {
      _loadListings();
    }
  }

  void _loadListings() {
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final list = widget.sduiListings != null
          ? widget.sduiListings!.map((e) => ListingItem.fromJson(e)).toList()
          : MockData.listings;
      setState(() {
        _listings = list;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchAndFiltersHeader(context),
            Expanded(
              child: _loading
                  ? _buildSkeletonGrid()
                  : _listings.isEmpty
                      ? EmptyState(onAction: () => _loadListings(), actionLabel: 'Refresh')
                      : _buildGrid(),
            ),
          ],
        ),
      ),
    );
  }

  /// Search bar with logo + "Search IndiaMART" + camera/mic, then filter row (Filter, Location, Category, Price).
  Widget _buildSearchAndFiltersHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const IndiamartLogo(height: 36, forDarkBackground: false),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppColors.textPrimary, size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Search IndiaMART',
                          style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.camera_alt_outlined, color: AppColors.textPrimary, size: 20),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                        style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.mic_none_outlined, color: AppColors.textPrimary, size: 20),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                        style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChipButton(icon: Icons.filter_list, onTap: () {}),
                const SizedBox(width: 8),
                _filterDropdown(
                  value: _locationFilter,
                  items: _locations,
                  onChanged: (v) => setState(() => _locationFilter = v ?? _locationFilter),
                ),
                const SizedBox(width: 8),
                _filterDropdown(
                  value: _categoryFilter,
                  items: _categories,
                  onChanged: (v) => setState(() => _categoryFilter = v ?? _categoryFilter),
                ),
                const SizedBox(width: 8),
                _filterDropdown(
                  value: _priceFilter,
                  items: _priceRanges,
                  onChanged: (v) => setState(() => _priceFilter = v ?? _priceFilter),
                ),
                const SizedBox(width: 8),
                _filterDropdown(
                  value: _priceFilter2,
                  items: _priceExact,
                  onChanged: (v) => setState(() => _priceFilter2 = v ?? _priceFilter2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChipButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _filterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.textPrimary),
          style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSkeletonGrid() {
  return GridView.builder(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.72,
    ),
    itemCount: 10, // Changed from 6 to 10
    itemBuilder: (context, index) => const ListingCardSkeleton(),
  );
}

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemCount: _listings.length,
      itemBuilder: (context, index) {
        final item = _listings[index];
        return ListingCard(
          item: item,
          onGetBestPrice: () => _showSnack('Get Best Price: ${item.title}'),
          onContactSupplier: () => _showSnack('Contact: ${item.supplierName}'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CompanyPage(profile: MockData.companyProfile),
            ),
          ),
        );
      },
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }
}
