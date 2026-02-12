/// SDUI node: type + attributes + children.
/// Server sends JSON in this shape; client renders via registry.
class SDUINode {
  final String type;
  final Map<String, dynamic> attributes;
  final List<SDUINode> children;

  const SDUINode({
    required this.type,
    this.attributes = const {},
    this.children = const [],
  });

  factory SDUINode.fromJson(dynamic json) {
    if (json == null) return SDUINode(type: 'Unknown');
    if (json is! Map<String, dynamic>) {
      return SDUINode(type: 'Unknown', attributes: {'raw': json});
    }
    final type = json['type'] as String? ?? 'Container';
    final attrs = Map<String, dynamic>.from(json['attributes'] as Map? ?? {});
    final childrenJson = json['children'] as List?;
    final children = childrenJson
            ?.map((e) => SDUINode.fromJson(e))
            .toList() ??
        const <SDUINode>[];
    return SDUINode(type: type, attributes: attrs, children: children);
  }

  T? attr<T>(String key, [T? defaultValue]) {
    if (!attributes.containsKey(key)) return defaultValue;
    final v = attributes[key];
    if (v is T) return v;
    return defaultValue;
  }

  String get attrString => attr<String>('') ?? '';
}
