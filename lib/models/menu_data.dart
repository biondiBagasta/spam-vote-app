class MenuData {
  final int? id;
  final DateTime? createdAt;
  final String? url;
  final String? targetElement;
  final String? blockedElement;
  final int? isCouple;
  final String? name;

  MenuData({
    this.id,
    this.createdAt,
    this.url,
    this.targetElement,
    this.blockedElement,
    this.isCouple,
    this.name,
  });

  factory MenuData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MenuData();

    return MenuData(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      url: json['url'] as String?,
      targetElement: json['target_element'] as String?,
      blockedElement: json['blocked_element'] as String?,
      isCouple: json['is_couple'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'url': url,
      'target_element': targetElement,
      'blocked_element': blockedElement,
      'is_couple': isCouple,
      'name': name,
    };
  }
}