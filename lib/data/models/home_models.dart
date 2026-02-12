/// One enquiry card for "Your Enquiries" section.
class EnquiryItem {
  final String id;
  final String title;
  final String supplierName;
  final String status; // Responded, Pending, Viewed
  final String timeAgo;
  final String statusColor; // green, orange, blue

  const EnquiryItem({
    required this.id,
    required this.title,
    required this.supplierName,
    required this.status,
    required this.timeAgo,
    this.statusColor = 'green',
  });
}

/// Recommended card for "Recommended for You".
class RecommendedItem {
  final String id;
  final String title;
  final String supplierName;
  final String rating;
  final bool verified;
  final bool trustedSeller;
  final String location;
  final String reviewCount;
  final String priceRange;
  final String responseTime;

  const RecommendedItem({
    required this.id,
    required this.title,
    required this.supplierName,
    required this.rating,
    this.verified = true,
    this.trustedSeller = true,
    required this.location,
    required this.reviewCount,
    required this.priceRange,
    required this.responseTime,
  });
}

/// "Continue Where You Left" category chip.
class ContinueCategory {
  final String id;
  final String title;
  final String subtitle;
  final String sellerCount;

  const ContinueCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.sellerCount,
  });
}

/// "Trending Now" row.
class TrendingItem {
  final int rank;
  final String name;
  final String sellerCount;
  final String growthPercent;

  const TrendingItem({
    required this.rank,
    required this.name,
    required this.sellerCount,
    required this.growthPercent,
  });
}

/// "Browse by Category" grid item. iconKey maps to Icons in UI (e.g. code, campaign).
class BrowseCategory {
  final String id;
  final String name;
  final String iconKey;

  const BrowseCategory({
    required this.id,
    required this.name,
    required this.iconKey,
  });
}
