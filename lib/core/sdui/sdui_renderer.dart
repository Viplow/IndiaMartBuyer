import 'package:flutter/material.dart';
import 'sdui_registry.dart';
import 'sdui_schema.dart';

/// Renders an SDUI node tree. Uses registry for known types; wraps unknown in Container.
class SDUIRenderer {
  static Widget build(BuildContext context, SDUINode node) {
    final registry = SDUIRegistry.instance;
    final widget = registry.build(context, node);
    if (widget != null) return widget;
    // Fallback: render children inside a container
    if (node.children.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: node.children
          .map((child) => SDUIRenderer.build(context, child))
          .toList(),
    );
  }
}
