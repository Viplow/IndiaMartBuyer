import 'package:flutter/material.dart';
import '../../core/session/app_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_network_image.dart';
import '../../core/widgets/indiamart_logo.dart';
import '../../data/models/home_models.dart';
import '../../data/mock_data.dart';
import '../listing/listing_page.dart';
import '../product/product_page.dart';

/// Home screen driven by SDUI. Shows generic name until login, then user name.
class HomePage extends StatefulWidget {
  final String? userName;
  final VoidCallback? onSignIn;
  final VoidCallback? onLogin;

  const HomePage({
    super.key,
    this.userName,
    this.onSignIn,
    this.onLogin,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _ChatMessage {
  final bool isUser;
  final String text;
  _ChatMessage({required this.isUser, required this.text});
}

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;
  int _selectedQuickFilter = 0;
  // Search: 0 = Paper making machine (default), 1 = Bicycle spare parts (photo med), 2 = Services (photo not important)
  int _searchMode = 0;
  String _searchTabLocation = 'Noida';
  String _searchTabCategory = 'Rice';
  String _searchTabPrice = 'Upto ₹100';
  String _searchTabPrice2 = '₹100';
  final _aiChatController = TextEditingController();
  final List<_ChatMessage> _aiMessages = [];
  final _aiScrollController = ScrollController();

  static const List<String> _searchTabLocations = ['Noida', 'Delhi', 'Mumbai', 'Bangalore', 'Chennai'];
  static const List<String> _searchTabCategories = ['Rice', 'Electronics', 'Machinery', 'Chemicals', 'Textiles'];
  static const List<String> _searchTabPriceRanges = ['Upto ₹100', 'Upto ₹500', 'Upto ₹1,000'];
  static const List<String> _searchTabPriceExact = ['₹100', '₹500', '₹1,000'];

  /// After login show name; until then show generic placeholder.
  String get _userName {
    final sessionName = currentUserName.value;
    if (sessionName != null && sessionName.isNotEmpty) return sessionName;
    return widget.userName ?? 'Guest';
  }

  @override
  void initState() {
    super.initState();
    currentUserName.addListener(_onSessionChanged);
  }

  @override
  void dispose() {
    currentUserName.removeListener(_onSessionChanged);
    _aiChatController.dispose();
    _aiScrollController.dispose();
    super.dispose();
  }

  void _onSessionChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedNavIndex == 0
          ? _buildHomeContent(context)
          : _selectedNavIndex == 1
              ? _buildSearchListingContent(context)
              : _selectedNavIndex == 2
                  ? _buildAIChatContent(context)
                  : _buildTabPlaceholder(context),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildHeaderWithSearch(context),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _sectionHeader('Your Enquiries', 'View All →', onViewAll: () {}),
              _enquiriesConsolidatedCard(context),
              const SizedBox(height: 24),
              _sectionHeaderWithIcon(Icons.refresh, 'Continue Where You Left'),
              const SizedBox(height: 12),
              _continueWhereYouLeft(context),
              const SizedBox(height: 24),
              _sectionHeader('Recommended for You', 'See All →', onViewAll: () {}),
              ..._recommendedSectionWithQuotesBanner(context),
              const SizedBox(height: 24),
              _sectionHeaderWithIcon(Icons.tune, 'Quick Filters'),
              const SizedBox(height: 12),
              _quickFilters(),
              const SizedBox(height: 24),
              _sectionHeader('Browse by Category', 'View All →', onViewAll: () {}),
              const SizedBox(height: 12),
              _browseGrid(context),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }

  /// Header + search in one teal block (Indiamart at top, search below with plus).
  Widget _buildHeaderWithSearch(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: MediaQuery.of(context).padding.top + 16,
          bottom: 16,
        ),
        color: const Color(0xFF1D8480),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const IndiamartLogo(height: 48, forDarkBackground: true),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ListingPage(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppColors.textTertiary, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Search for products & services',
                          style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ListingPage()),
                          );
                        },
                        icon: Icon(Icons.camera_alt_outlined, color: AppColors.textTertiary, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        tooltip: 'Search by image',
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ListingPage()),
                          );
                        },
                        icon: Icon(Icons.mic_none_outlined, color: AppColors.textTertiary, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        tooltip: 'Voice search',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String action, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.textTheme.titleMedium),
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              action,
              style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeaderWithIcon(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(title, style: AppTypography.textTheme.titleMedium),
        ],
      ),
    );
  }

  Color _statusColor(String colorKey) {
    switch (colorKey) {
      case 'green':
        return AppColors.verified;
      case 'orange':
        return AppColors.ctaOrange;
      case 'blue':
        return AppColors.accent;
      default:
        return AppColors.verified;
    }
  }

  /// Consolidated "Your Enquiries" card: Active / Pending / Viewed / Calls connected with counts and arrow.
  Widget _enquiriesConsolidatedCard(BuildContext context) {
    final list = MockData.enquiries;
    final activeCount = list.where((e) => e.status == 'Responded').length;
    final pendingCount = list.where((e) => e.status == 'Pending').length;
    final viewedCount = list.where((e) => e.status == 'Viewed').length;
    final callsConnectedCount = MockData.enquiryCallsConnectedCount;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {}, // Navigate to enquiries list when needed
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: AppDecorations.card(borderRadius: 14),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _enquiryStatusChip(context, activeCount, 'Active', Colors.green),
                      const SizedBox(width: 24),
                      _enquiryStatusChip(context, pendingCount, 'Pending', Colors.orange),
                      const SizedBox(width: 24),
                      _enquiryStatusChip(context, viewedCount, 'Viewed', AppColors.accent),
                      const SizedBox(width: 24),
                      _enquiryStatusChip(context, callsConnectedCount, 'Calls connected', AppColors.headerTeal),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _enquiryStatusChip(BuildContext context, int count, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$count',
              style: AppTypography.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
      ],
    );
  }

  /// Recommended cards with Get Instant Quotes banner after the first 2 cards (e.g. if 4 cards: 2, banner, 2).
  List<Widget> _recommendedSectionWithQuotesBanner(BuildContext context) {
    final list = MockData.recommended;
    const showAfterCount = 2;
    final first = list.take(showAfterCount).map((r) => _recommendedCard(r)).toList();
    final rest = list.skip(showAfterCount).map((r) => _recommendedCard(r)).toList();
    return [
      ...first,
      const SizedBox(height: 12),
      _instantQuotesBanner(context),
      const SizedBox(height: 12),
      ...rest,
    ];
  }

  Widget _recommendedCard(RecommendedItem r) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openProductFromRecommended(r),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: AppDecorations.card(borderRadius: 14),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: AppNetworkImage(imageUrl: r.imageUrl, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.title, style: AppTypography.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      r.price,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.folder_outlined, size: 18, color: AppColors.textTertiary),
                        const SizedBox(width: 6),
                        Icon(Icons.check_circle_outline, size: 18, color: AppColors.verified),
                        const SizedBox(width: 6),
                        Icon(Icons.star_rounded, size: 18, color: Colors.amber[700]),
                        const SizedBox(width: 4),
                        Text(r.rating, style: AppTypography.textTheme.labelMedium),
                      ],
                    ),
                    if (r.descriptionSnippet.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        r.descriptionSnippet,
                        style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.call_outlined, size: 18, color: AppColors.headerTeal),
                            label: Text('Call Now', style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.headerTeal, fontWeight: FontWeight.w600)),
                            style: AppDecorations.ctaOutlinedStyle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.local_offer_outlined, size: 18, color: AppColors.headerTeal),
                            label: Text('Get Best Price', style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.headerTeal, fontWeight: FontWeight.w600)),
                            style: AppDecorations.ctaOutlinedStyle,
                          ),
                        ),
                      ],
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

  void _openProductFromRecommended(RecommendedItem r) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductPage(
          title: r.title,
          imageUrl: r.imageUrl,
          price: r.priceRange,
          supplierName: r.supplierName,
          description: r.descriptionSnippet,
        ),
      ),
    );
  }

  /// Product-style items for "Continue Where You Left" (image, price, clickable → ProductPage).
  static final _continueProductItems = [
    (title: 'CNC Milling Machine', imageUrl: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=400', price: '₹12,50,000', supplierName: 'Precision Tools Ltd', description: 'Industrial 5-axis CNC milling machine for metal and composite machining.'),
    (title: 'Industrial Pump Set', imageUrl: 'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=400', price: '₹45,000 - ₹1,20,000', supplierName: 'FlowTech Engineers', description: 'Heavy-duty pump sets for water and chemical handling.'),
    (title: 'Raw Material - Steel Coils', imageUrl: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=400', price: '₹85/kg', supplierName: 'Metals & Alloys Corp', description: 'Cold-rolled steel coils, various gauges.'),
  ];

  Widget _continueWhereYouLeft(BuildContext context) {
    return SizedBox(
      height: 218,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _continueProductItems.length,
        itemBuilder: (context, i) {
          final item = _continueProductItems[i];
          return _continueProductCard(context, item);
        },
      ),
    );
  }

  Widget _continueProductCard(BuildContext context, ({String title, String imageUrl, String price, String supplierName, String description}) item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProductPage(
                title: item.title,
                imageUrl: item.imageUrl,
                price: item.price,
                supplierName: item.supplierName,
                description: item.description,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 168,
          margin: const EdgeInsets.only(right: 14),
          decoration: AppDecorations.card(borderRadius: 14),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1.1,
                child: AppNetworkImage(imageUrl: item.imageUrl, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.price,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  Widget _quickFilters() {
    const filters = [
      (Icons.star_rounded, 'Top Rated', Colors.amber, 1),
      (Icons.location_on_outlined, 'Local Sellers', AppColors.accent, 2),
      (Icons.verified, 'GST Verified', AppColors.verified, 1),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(3, (i) {
        final (icon, label, color, badge) = filters[i];
        final selected = _selectedQuickFilter == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedQuickFilter = i),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: selected ? 0.25 : 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 26),
                  ),
                  if (badge > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.ctaOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$badge',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(label, style: AppTypography.textTheme.bodySmall?.copyWith(fontSize: 11)),
            ],
          ),
        );
      }),
    );
  }

  IconData _iconForKey(String key) {
    switch (key) {
      case 'code':
        return Icons.code;
      case 'campaign':
        return Icons.campaign;
      case 'palette':
        return Icons.palette;
      case 'precision_manufacturing':
        return Icons.precision_manufacturing;
      case 'layers':
        return Icons.layers;
      case 'inventory_2':
        return Icons.inventory_2;
      case 'electrical_services':
        return Icons.electrical_services;
      case 'science':
        return Icons.science;
      default:
        return Icons.category;
    }
  }

  Widget _browseGrid(BuildContext context) {
    const crossAxisCount = 4;
    final list = MockData.browseCategories;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final c = list[i];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.chipBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(_iconForKey(c.iconKey), color: AppColors.accent, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              c.name,
              style: AppTypography.textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget _instantQuotesBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.headerTeal,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppDecorations.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.request_quote, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Instant Quotes',
                  style: AppTypography.textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  "Tell us what you need, and we'll connect you with verified sellers offering the best prices.",
                  style: AppTypography.textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.ctaOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Request Quote'),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendAIMessage(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    setState(() {
      _aiMessages.add(_ChatMessage(isUser: true, text: t));
      _aiChatController.clear();
    });
    _scrollAIToEnd();
    // Demo reply after a short delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _aiMessages.add(_ChatMessage(
          isUser: false,
          text: _demoAIResponse(t),
        ));
      });
      _scrollAIToEnd();
    });
  }

  void _scrollAIToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_aiScrollController.hasClients) {
        _aiScrollController.animateTo(
          _aiScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _demoAIResponse(String query) {
    final q = query.toLowerCase();
    if (q.contains('supplier') || q.contains('find') || q.contains('who')) {
      return 'I can help you find suppliers. Try searching by product or category on the Home screen, or use "Get Instant Quotes" to request quotes from verified sellers.';
    }
    if (q.contains('quote') || q.contains('price')) {
      return 'You can get instant quotes by tapping "Get Instant Quotes" on the Home screen or the Quotes tab. Describe your requirement and we\'ll connect you with verified sellers.';
    }
    if (q.contains('product') || q.contains('category')) {
      return 'Browse by category on the Home screen to explore products. You can also use the search bar to find specific products and services.';
    }
    return 'Thanks for your message. I\'m your B2B assistant. I can help you find suppliers, get quotes, and explore categories. Try asking: "Find suppliers for machinery" or "How do I get a quote?"';
  }

  Widget _buildAIChatContent(BuildContext context) {
    const suggestedPrompts = [
      'Find suppliers for industrial machinery',
      'Get quotes for raw materials',
      'Compare products by category',
      'How do I request a quote?',
    ];
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: const Color(0xFF1D8480),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.white, size: 26),
                const SizedBox(width: 10),
                Text(
                  'AI Search',
                  style: AppTypography.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _aiMessages.isEmpty
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.headerTeal.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.smart_toy, size: 48, color: AppColors.headerTeal),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'How can I help you today?',
                            style: AppTypography.textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Ask about suppliers, quotes, or products',
                            style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text('Suggested prompts', style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: suggestedPrompts.map((p) {
                            return ActionChip(
                              label: Text(p, style: AppTypography.textTheme.bodySmall),
                              onPressed: () => _sendAIMessage(p),
                              backgroundColor: AppColors.surfaceVariant,
                              side: BorderSide(color: AppColors.border),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _aiScrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: _aiMessages.length,
                    itemBuilder: (context, i) {
                      final m = _aiMessages[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: m.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!m.isUser)
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.headerTeal.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.smart_toy, size: 18, color: AppColors.headerTeal),
                              ),
                            if (!m.isUser) const SizedBox(width: 10),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: m.isUser ? AppColors.headerTeal : AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: Radius.circular(m.isUser ? 16 : 4),
                                    bottomRight: Radius.circular(m.isUser ? 4 : 16),
                                  ),
                                ),
                                child: Text(
                                  m.text,
                                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                                    color: m.isUser ? Colors.white : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                            if (m.isUser) const SizedBox(width: 10),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _aiChatController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendAIMessage,
                  ),
                ),
                const SizedBox(width: 12),
                Material(
                  color: AppColors.headerTeal,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: () => _sendAIMessage(_aiChatController.text),
                    borderRadius: BorderRadius.circular(24),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.send_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const String _searchDefaultQuery = 'Paper making machine';

  String get _searchBarLabel {
    switch (_searchMode) {
      case 0:
        return _searchDefaultQuery;
      case 1:
        return 'Bicycle spare parts';
      case 2:
        return 'Services';
      default:
        return _searchDefaultQuery;
    }
  }

  /// Search listing: same header as listing page (logo + Search IndiaMART + filter row), then content.
  Widget _buildSearchListingContent(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchFiltersHeader(context),
          Expanded(
            child: _searchMode == 0
                ? _buildSearchListPaperMaking()
                : _searchMode == 1
                    ? _buildSearchGridBicycle()
                    : _buildSearchListServices(),
          ),
        ],
      ),
    );
  }

  /// Same as listing page: logo + Search IndiaMART bar (camera, mic) + filter row (Filter, Noida, Rice, Upto ₹100, ₹100).
  Widget _buildSearchFiltersHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const IndiamartLogo(height: 44, forDarkBackground: false),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppColors.textPrimary, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showSearchOptions(context),
                          child: Text(
                            _searchBarLabel,
                            style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showSearchOptions(context),
                        icon: Icon(Icons.camera_alt_outlined, color: AppColors.textPrimary, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        tooltip: 'Search by image',
                      ),
                      IconButton(
                        onPressed: () => _showSearchOptions(context),
                        icon: Icon(Icons.mic_none_outlined, color: AppColors.textPrimary, size: 22),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        tooltip: 'Voice search',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _searchTabFilterChip(icon: Icons.filter_list, onTap: () {}),
                const SizedBox(width: 8),
                _searchTabFilterDropdown(
                  value: _searchTabLocation,
                  items: _searchTabLocations,
                  onChanged: (v) => setState(() => _searchTabLocation = v ?? _searchTabLocation),
                ),
                const SizedBox(width: 8),
                _searchTabFilterDropdown(
                  value: _searchTabCategory,
                  items: _searchTabCategories,
                  onChanged: (v) => setState(() => _searchTabCategory = v ?? _searchTabCategory),
                ),
                const SizedBox(width: 8),
                _searchTabFilterDropdown(
                  value: _searchTabPrice,
                  items: _searchTabPriceRanges,
                  onChanged: (v) => setState(() => _searchTabPrice = v ?? _searchTabPrice),
                ),
                const SizedBox(width: 8),
                _searchTabFilterDropdown(
                  value: _searchTabPrice2,
                  items: _searchTabPriceExact,
                  onChanged: (v) => setState(() => _searchTabPrice2 = v ?? _searchTabPrice2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchTabFilterChip({required IconData icon, required VoidCallback onTap}) {
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

  Widget _searchTabFilterDropdown({
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

  void _showSearchOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Search type',
                style: AppTypography.textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.photo_library_outlined, color: AppColors.headerTeal),
                title: const Text('Bicycle spare parts'),
                subtitle: Text('Photo medium important', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textTertiary)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _searchMode = 1);
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.description_outlined, color: AppColors.headerTeal),
                title: const Text('Services'),
                subtitle: Text('Photo not important', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textTertiary)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _searchMode = 2);
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _searchMode = 0);
                },
                child: const Text('Default: Paper making machine'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchGridBicycle() {
    final list = MockData.searchProductsBicycleSpareParts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            '${list.length} products found',
            style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.58,
            ),
            itemCount: list.length,
            itemBuilder: (context, i) => _searchProductCard(list[i]),
          ),
        ),
      ],
    );
  }

  /// Services – photo not important: text-only cards (title, rating, provider, description, badges, location, price).
  Widget _buildSearchListServices() {
    final list = MockData.searchServices;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            '${list.length} services found',
            style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            itemCount: list.length,
            itemBuilder: (context, i) => _searchServiceCard(list[i]),
          ),
        ),
      ],
    );
  }

  Widget _searchServiceCard(SearchServiceItem s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card(borderRadius: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  s.title,
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 16, color: Colors.amber.shade700),
                    const SizedBox(width: 4),
                    Text(s.rating, style: AppTypography.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.business_outlined, size: 16, color: AppColors.textTertiary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  s.providerName,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            s.descriptionSnippet,
            style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textTertiary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (s.verified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 14, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text('GST Verified', style: AppTypography.textTheme.labelSmall?.copyWith(color: Colors.green.shade800)),
                    ],
                  ),
                ),
              if (s.trustedSeller)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text('TrustSEAL', style: AppTypography.textTheme.labelSmall?.copyWith(color: Colors.blue.shade800)),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.textTertiary.withValues(alpha: 0.5)),
                ),
                child: Text(s.experience, style: AppTypography.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: AppColors.textTertiary.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(s.location, style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    s.priceLabel,
                    style: AppTypography.textTheme.labelSmall?.copyWith(color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.priceRange,
                    style: AppTypography.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.call_outlined, size: 18, color: AppColors.headerTeal),
                  label: Text('Call Now', style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.headerTeal, fontWeight: FontWeight.w600)),
                  style: AppDecorations.ctaOutlinedStyle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
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

  /// Paper making machine – photo important: large image, TrustSEAL badge, 3 ISQs, GST, Call + WhatsApp.
  Widget _buildSearchListPaperMaking() {
    final list = MockData.searchProductsPaperMakingMachine;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            'Paper making machine · ${list.length} products found',
            style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            itemCount: list.length,
            itemBuilder: (context, i) => _searchProductCardPhotoProminent(list[i]),
          ),
        ),
      ],
    );
  }

  /// Photo-prominent card: large image, TrustSEAL below, title, price, 3 ISQs, seller (GST, yrs, rating), Call + WhatsApp.
  Widget _searchProductCardPhotoProminent(SearchProductItem p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: AppDecorations.card(borderRadius: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1.35,
            child: AppNetworkImage(imageUrl: p.imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (p.trustedSeller)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber.shade700),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, size: 16, color: Colors.amber.shade800),
                        const SizedBox(width: 6),
                        Text('TrustSEAL', style: AppTypography.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: p.isqs.take(3).map((isq) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(isq, style: AppTypography.textTheme.labelSmall),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  p.title,
                  style: AppTypography.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  p.price,
                  style: AppTypography.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(p.supplierName, style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    if (p.verified)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 16, color: AppColors.verified),
                          const SizedBox(width: 4),
                          Text('GST', style: AppTypography.textTheme.labelSmall?.copyWith(color: AppColors.verified)),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(p.location, style: AppTypography.textTheme.bodySmall),
                    const Spacer(),
                    Icon(Icons.star_rounded, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text('${p.rating} (278)', style: AppTypography.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.call_outlined, size: 20, color: AppColors.headerTeal),
                        label: Text('Call Now', style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.headerTeal, fontWeight: FontWeight.w600)),
                        style: AppDecorations.ctaOutlinedStyle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.local_offer_outlined, size: 20, color: AppColors.headerTeal),
                        label: Text('Get Best Price', style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.headerTeal, fontWeight: FontWeight.w600)),
                        style: AppDecorations.ctaOutlinedStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchProductCard(SearchProductItem p) {
    return Container(
      decoration: AppDecorations.card(borderRadius: 14),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              AspectRatio(
                aspectRatio: 1.1,
                child: AppNetworkImage(imageUrl: p.imageUrl, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (p.verified)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text('GST Verified', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    if (p.trustedSeller) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text('TrustSEAL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  style: AppTypography.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      p.price,
                      style: AppTypography.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 4),
                    Text('/${p.priceUnit}', style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: p.isqs.take(3).map((isq) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isq,
                      style: AppTypography.textTheme.labelSmall?.copyWith(fontSize: 9),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        p.supplierName,
                        style: AppTypography.textTheme.bodySmall?.copyWith(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.star_rounded, size: 14, color: Colors.amber[700]),
                    const SizedBox(width: 2),
                    Text(p.rating, style: AppTypography.textTheme.labelSmall),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 12, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        p.location,
                        style: AppTypography.textTheme.bodySmall?.copyWith(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.call_outlined, size: 16, color: AppColors.headerTeal),
                        label: Text('Call Now', style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.headerTeal, fontWeight: FontWeight.w600, fontSize: 12)),
                        style: AppDecorations.ctaOutlinedStyle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.local_offer_outlined, size: 16, color: AppColors.headerTeal),
                        label: Text('Get Best Price', style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.headerTeal, fontWeight: FontWeight.w600, fontSize: 12)),
                        style: AppDecorations.ctaOutlinedStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabPlaceholder(BuildContext context) {
    if (_selectedNavIndex == 4) {
      final isLoggedIn = currentUserName.value != null && currentUserName.value!.isNotEmpty;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_outline, size: 64, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              Text('Profile', style: AppTypography.textTheme.titleLarge),
              if (isLoggedIn) ...[
                const SizedBox(height: 8),
                Text(
                  currentUserName.value!,
                  style: AppTypography.textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
                ),
              ],
              const SizedBox(height: 24),
              if (isLoggedIn)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      currentUserName.value = null;
                    },
                    icon: const Icon(Icons.logout, size: 20),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                    ),
                  ),
                )
              else ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (widget.onSignIn != null) {
                        widget.onSignIn!();
                      } else {
                        Navigator.of(context).pushNamed('/sign-in');
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      if (widget.onLogin != null) {
                        widget.onLogin!();
                      } else {
                        Navigator.of(context).pushNamed('/login');
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return Center(
      child: Text(
        ['Home', 'Search', 'AI Search', 'Quotes', 'Profile'][_selectedNavIndex],
        style: AppTypography.textTheme.titleLarge,
      ),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.search_rounded, 'Search'),
      (Icons.auto_awesome, 'AI Search'),
      (Icons.request_quote_outlined, 'Quotes'),
      (Icons.person_outline_rounded, 'Profile'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (i) {
              final (icon, label) = items[i];
              final selected = _selectedNavIndex == i;
              return InkWell(
                onTap: () => setState(() => _selectedNavIndex = i),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selected)
                        Container(
                          width: 24,
                          height: 3,
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: AppColors.headerTeal,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      Icon(icon, size: 24, color: selected ? AppColors.headerTeal : AppColors.textTertiary),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: AppTypography.textTheme.labelMedium?.copyWith(
                          color: selected ? AppColors.headerTeal : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
