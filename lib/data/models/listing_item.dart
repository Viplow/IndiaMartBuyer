class ListingItem {
  final String id;
  final String title;
  final String imageUrl;
  final String priceRange;
  final String moq;
  final String supplierName;
  final bool verified;
  final String location;
  final String? category;

  const ListingItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.priceRange,
    required this.moq,
    required this.supplierName,
    this.verified = false,
    required this.location,
    this.category,
  });

  factory ListingItem.fromJson(Map<String, dynamic> json) {
    return ListingItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      priceRange: json['priceRange'] as String? ?? '',
      moq: json['moq'] as String? ?? '',
      supplierName: json['supplierName'] as String? ?? '',
      verified: json['verified'] as bool? ?? false,
      location: json['location'] as String? ?? '',
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imageUrl': imageUrl,
        'priceRange': priceRange,
        'moq': moq,
        'supplierName': supplierName,
        'verified': verified,
        'location': location,
        'category': category,
      };
}
