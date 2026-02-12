class CompanyProfile {
  final String id;
  final String name;
  final String? tagline;
  final String logoUrl;
  final String bannerUrl;
  final bool verified;
  final String yearsInBusiness;
  final String? rating;
  final String? ratingCount; // e.g. "259"
  final String? responseRate; // e.g. "74%"
  final String? gstNumber;
  final List<String> certifications;
  final String location;
  final List<CompanyProduct> products;
  final List<String> galleryUrls;
  final String? about;

  const CompanyProfile({
    required this.id,
    required this.name,
    this.tagline,
    required this.logoUrl,
    required this.bannerUrl,
    this.verified = false,
    required this.yearsInBusiness,
    this.rating,
    this.ratingCount,
    this.responseRate,
    this.gstNumber,
    this.certifications = const [],
    required this.location,
    this.products = const [],
    this.galleryUrls = const [],
    this.about,
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      tagline: json['tagline'] as String?,
      logoUrl: json['logoUrl'] as String? ?? '',
      bannerUrl: json['bannerUrl'] as String? ?? '',
      verified: json['verified'] as bool? ?? false,
      yearsInBusiness: json['yearsInBusiness'] as String? ?? '',
      rating: json['rating'] as String?,
      ratingCount: json['ratingCount'] as String?,
      responseRate: json['responseRate'] as String?,
      gstNumber: json['gstNumber'] as String?,
      certifications: (json['certifications'] as List?)?.cast<String>() ?? [],
      location: json['location'] as String? ?? '',
      products: (json['products'] as List?)
              ?.map((e) => CompanyProduct.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
      galleryUrls: (json['galleryUrls'] as List?)?.cast<String>() ?? [],
      about: json['about'] as String?,
    );
  }
}

class CompanyProduct {
  final String id;
  final String name;
  final String imageUrl;
  final String priceRange;
  final String? moq;
  final List<MapEntry<String, String>>? specifications;

  const CompanyProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.priceRange,
    this.moq,
    this.specifications,
  });

  factory CompanyProduct.fromJson(Map<String, dynamic> json) {
    return CompanyProduct(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      priceRange: json['priceRange'] as String? ?? '',
      moq: json['moq'] as String?,
      specifications: null,
    );
  }
}
