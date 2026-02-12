import 'package:flutter/material.dart';
import '../../core/session/app_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_decorations.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/home_models.dart';
import '../../data/mock_data.dart';

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

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;
  int _selectedQuickFilter = 0;

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
    super.dispose();
  }

  void _onSessionChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedNavIndex == 0 ? _buildHomeContent(context) : _buildTabPlaceholder(context),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildHeader(context),
        SliverToBoxAdapter(child: _buildSearchBar(context)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _sectionHeader('Your Enquiries', 'View All →', onViewAll: () {}),
              ...MockData.enquiries.map((e) => _enquiryCard(e)),
              const SizedBox(height: 24),
              _sectionHeader('Recommended for You', 'See All →', onViewAll: () {}),
              ...MockData.recommended.map((r) => _recommendedCard(r)),
              const SizedBox(height: 24),
              _sectionHeaderWithIcon(Icons.schedule, 'Continue Where You Left'),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.continueCategories.length,
                  itemBuilder: (context, i) {
                    final c = MockData.continueCategories[i];
                    return _continueCard(c);
                  },
                ),
              ),
              const SizedBox(height: 24),
              _sectionHeaderWithIcon(Icons.tune, 'Quick Filters'),
              const SizedBox(height: 12),
              _quickFilters(),
              const SizedBox(height: 24),
              _sectionHeaderWithIcon(Icons.trending_up, 'Trending Now'),
              const SizedBox(height: 12),
              ...MockData.trending.map((t) => _trendingRow(t)),
              const SizedBox(height: 24),
              _sectionHeader('Browse by Category', 'All >', onViewAll: () {}),
              const SizedBox(height: 12),
              _browseGrid(context),
              const SizedBox(height: 24),
              _instantQuotesBanner(context),
              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: MediaQuery.of(context).padding.top + 16,
          bottom: 24,
        ),
        color: const Color(0xFF1D8480),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Indiamart',
                style: AppTypography.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: AppColors.textTertiary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search for products or services...',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
                ),
              ),
              Icon(Icons.mic_none, color: AppColors.textTertiary, size: 22),
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

  Widget _enquiryCard(EnquiryItem e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: AppDecorations.card(borderRadius: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _statusColor(e.statusColor).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                e.supplierName.isNotEmpty ? e.supplierName[0] : '?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _statusColor(e.statusColor),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.title, style: AppTypography.textTheme.titleSmall),
                Text(e.supplierName, style: AppTypography.textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                e.status,
                style: AppTypography.textTheme.labelMedium?.copyWith(color: _statusColor(e.statusColor)),
              ),
              Text(e.timeAgo, style: AppTypography.textTheme.bodySmall),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.mail_outline, size: 18, color: AppColors.accent),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    tooltip: 'Enquiry',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.call_outlined, size: 18, color: AppColors.verified),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    tooltip: 'Call',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recommendedCard(RecommendedItem r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card(borderRadius: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.title, style: AppTypography.textTheme.titleMedium),
                    Text(r.supplierName, style: AppTypography.textTheme.bodySmall),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star_rounded, size: 18, color: Colors.amber[700]),
                  const SizedBox(width: 4),
                  Text(r.rating, style: AppTypography.textTheme.labelMedium),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (r.verified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.verified, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 14, color: AppColors.verified),
                      const SizedBox(width: 4),
                      Text('GST Verified', style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.verified, fontSize: 11)),
                    ],
                  ),
                ),
              if (r.trustedSeller)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent, width: 1),
                  ),
                  child: Text('TrustSEAL / Verified Exporter', style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.accent, fontSize: 10)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(r.location, style: AppTypography.textTheme.bodySmall),
              const SizedBox(width: 12),
              Text(r.reviewCount, style: AppTypography.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Text('Starting from ${r.priceRange}', style: AppTypography.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.mail_outline, size: 22, color: AppColors.accent),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                tooltip: 'Enquiry',
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.call_outlined, size: 22, color: AppColors.verified),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                tooltip: 'Call',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _continueCard(ContinueCategory c) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: AppDecorations.card(borderRadius: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(c.title, style: AppTypography.textTheme.titleSmall),
          Text(c.subtitle, style: AppTypography.textTheme.bodySmall),
          Text(c.sellerCount, style: AppTypography.textTheme.bodySmall?.copyWith(color: AppColors.accent)),
          const Align(alignment: Alignment.centerRight, child: Icon(Icons.arrow_forward_ios, size: 12)),
        ],
      ),
    );
  }

  Widget _quickFilters() {
    const filters = [
      (Icons.star_rounded, 'Top Rated', Colors.amber),
      (Icons.location_on_outlined, 'Local Sellers', AppColors.accent),
      (Icons.verified, 'Verified', AppColors.verified),
      (Icons.flash_on, 'Quick Response', AppColors.ctaOrange),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (i) {
        final (icon, label, color) = filters[i];
        final selected = _selectedQuickFilter == i;
        return GestureDetector(
          onTap: () => setState(() => _selectedQuickFilter = i),
          child: Column(
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
              const SizedBox(height: 6),
              Text(label, style: AppTypography.textTheme.bodySmall?.copyWith(fontSize: 11)),
            ],
          ),
        );
      }),
    );
  }

  Widget _trendingRow(TrendingItem t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.chipBackground,
              shape: BoxShape.circle,
            ),
            child: Center(child: Text('${t.rank}', style: AppTypography.textTheme.labelMedium)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(t.name, style: AppTypography.textTheme.bodyMedium)),
          Text(t.sellerCount, style: AppTypography.textTheme.bodySmall),
          const SizedBox(width: 8),
          Text(t.growthPercent, style: AppTypography.textTheme.labelMedium?.copyWith(color: AppColors.verified)),
        ],
      ),
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
        ['Home', 'Search', 'AI Chat', 'Quotes', 'Profile'][_selectedNavIndex],
        style: AppTypography.textTheme.titleLarge,
      ),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      (Icons.home_rounded, 'Home'),
      (Icons.search_rounded, 'Search'),
      (Icons.chat_bubble_outline_rounded, 'AI Chat'),
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
                      Icon(icon, size: 24, color: selected ? AppColors.accent : AppColors.textTertiary),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: AppTypography.textTheme.labelMedium?.copyWith(
                          color: selected ? AppColors.accent : AppColors.textTertiary,
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
