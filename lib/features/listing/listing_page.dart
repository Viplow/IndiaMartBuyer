import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../data/models/listing_item.dart';
import 'widgets/empty_state.dart';
import 'widgets/filter_bar.dart';
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
  String _sortValue = 'Relevance';
  final List<FilterChipItem> _chips = [
    const FilterChipItem(id: 'price', label: 'Price', selected: false),
    const FilterChipItem(id: 'moq', label: 'MOQ', selected: false),
    const FilterChipItem(id: 'location', label: 'Location', selected: false),
    const FilterChipItem(id: 'supplier', label: 'Supplier Type', selected: false),
  ];
  static const List<String> _sortOptions = ['Relevance', 'Price: Low to High', 'Verified Suppliers'];

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

  void _onChipTap(String id) {
    setState(() {
      for (var i = 0; i < _chips.length; i++) {
        if (_chips[i].id == id) {
          _chips[i] = FilterChipItem(id: _chips[i].id, label: _chips[i].label, selected: !_chips[i].selected);
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('B2B Marketplace'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Material(
            elevation: 0,
            child: FilterBar(
              chips: _chips,
              onChipTap: _onChipTap,
              sortValue: _sortValue,
              sortOptions: _sortOptions,
              onSortChanged: (v) => setState(() => _sortValue = v ?? _sortValue),
            ),
          ),
          Expanded(
            child: _loading
                ? _buildSkeletonGrid()
                : _listings.isEmpty
                    ? EmptyState(onAction: () => _loadListings(), actionLabel: 'Refresh')
                    : _buildGrid(),
          ),
        ],
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
