import 'package:flutter/material.dart';
import '../sdui_schema.dart';
import '../../../features/listing/widgets/listing_card.dart';
import '../../../data/models/listing_item.dart';

/// SDUI widget: renders ListingCard from node attributes.
Widget sduiListingCard(BuildContext context, SDUINode node) {
  final attrs = node.attributes;
  final item = ListingItem(
    id: attrs['id'] as String? ?? '',
    title: attrs['title'] as String? ?? '',
    imageUrl: attrs['imageUrl'] as String? ?? '',
    priceRange: attrs['priceRange'] as String? ?? '',
    moq: attrs['moq'] as String? ?? '',
    supplierName: attrs['supplierName'] as String? ?? '',
    verified: attrs['verified'] as bool? ?? false,
    location: attrs['location'] as String? ?? '',
    category: attrs['category'] as String?,
  );
  return ListingCard(
    item: item,
    onGetBestPrice: () {},
    onContactSupplier: () {},
  );
}
