import 'dart:convert';

import 'package:tractian_app/utils/images.dart';

class Item {
  final String id;
  final String name;
  final String? parentId;
  final String? locationId;

  Item({
    required this.id,
    required this.name,
    this.parentId,
    this.locationId,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      parentId: map['parentId'],
      locationId: map['locationId'],
    );
  }
  String get imageIcon => Images.assetIcon;

  Item copyWith({
    String? id,
    String? name,
    String? parentId,
    String? locationId,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      locationId: locationId ?? this.locationId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    if (parentId != null) {
      result.addAll({'parentId': parentId});
    }
    if (locationId != null) {
      result.addAll({'locationId': locationId});
    }

    return result;
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Item(id: $id, name: $name, parentId: $parentId, locationId: $locationId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item &&
        other.id == id &&
        other.name == name &&
        other.parentId == parentId &&
        other.locationId == locationId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        parentId.hashCode ^
        locationId.hashCode;
  }
}
