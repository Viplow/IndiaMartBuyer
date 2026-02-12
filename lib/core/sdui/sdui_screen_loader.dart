import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sdui_registry.dart';
import 'sdui_schema.dart';

/// Loads a screen from JSON (asset or future) and renders via SDUI.
class SDUIScreenLoader extends StatefulWidget {
  final String? assetPath;
  final Future<Map<String, dynamic>>? jsonFuture;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const SDUIScreenLoader({
    super.key,
    this.assetPath,
    this.jsonFuture,
    this.loadingWidget,
    this.errorWidget,
  }) : assert(assetPath != null || jsonFuture != null);

  @override
  State<SDUIScreenLoader> createState() => _SDUIScreenLoaderState();
}

class _SDUIScreenLoaderState extends State<SDUIScreenLoader> {
  Map<String, dynamic>? _json;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      Map<String, dynamic>? data;
      if (widget.jsonFuture != null) {
        data = await widget.jsonFuture;
      } else if (widget.assetPath != null) {
        final str = await rootBundle.loadString(widget.assetPath!);
        data = _decodeJson(str);
      }
      if (mounted) setState(() { _json = data; _error = null; });
    } catch (e, st) {
      if (mounted) setState(() { _error = e.toString(); });
      debugPrintStack(stackTrace: st);
    }
  }

  static Map<String, dynamic>? _decodeJson(String str) {
    return jsonDecode(str) as Map<String, dynamic>?;
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorWidget ??
          Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text('Failed to load screen: $_error', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          );
    }
    if (_json == null) {
      return widget.loadingWidget ??
          const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final node = SDUINode.fromJson(_json);
    final built = SDUIRegistry.instance.build(context, node);
    if (built == null) {
      return widget.errorWidget ??
          Scaffold(
            body: Center(child: Text('Unknown screen type: ${node.type}')),
          );
    }
    return built;
  }
}
