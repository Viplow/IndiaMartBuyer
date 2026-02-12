import 'package:flutter/material.dart';
import '../sdui_schema.dart';
import '../../../features/listing/widgets/empty_state.dart';

Widget sduiEmptyState(BuildContext context, SDUINode node) {
  final attrs = node.attributes;
  return EmptyState(
    title: attrs['title'] as String? ?? 'No listings found',
    subtitle: attrs['subtitle'] as String?,
    actionLabel: attrs['actionLabel'] as String?,
  );
}
