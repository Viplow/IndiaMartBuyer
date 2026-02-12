import 'package:flutter/material.dart';
import 'sdui_schema.dart';

typedef SDUIWidgetBuilder = Widget Function(
  BuildContext context,
  SDUINode node,
);

/// Registry of SDUI component types -> widget builders.
/// Register B2B components so server-driven JSON can render them.
class SDUIRegistry {
  SDUIRegistry._();
  static final SDUIRegistry _instance = SDUIRegistry._();
  static SDUIRegistry get instance => _instance;

  final Map<String, SDUIWidgetBuilder> _builders = {};

  void register(String type, SDUIWidgetBuilder builder) {
    _builders[type] = builder;
  }

  Widget? build(BuildContext context, SDUINode node) {
    final builder = _builders[node.type];
    if (builder == null) return null;
    return builder(context, node);
  }

  bool has(String type) => _builders.containsKey(type);
}
