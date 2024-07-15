import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tractian_app/models/component.dart';
import 'package:tractian_app/models/item.dart';
import 'package:tractian_app/utils/images.dart';

class Asset extends Item {
  List<Component> components;
  List<Asset> subAssets;

  Asset({
    required String id,
    required String name,
    String? parentId,
    String? locationId,
    List<Component>? components,
    List<Asset>? subAssets,
  })  : components = components ?? [],
        subAssets = subAssets ?? [],
        super(id: id, name: name, parentId: parentId, locationId: locationId);

  @override
  String get imageIcon => Images.assetIcon;

  factory Asset.fromMap(Map<String, dynamic> map) {
    List<Component>? components = map['components'] != null
        ? List<Component>.from(
            map['components']?.map((x) => Component.fromMap(x)))
        : null;
    List<Asset>? subAssets = map['subAssets'] != null
        ? List<Asset>.from(map['subAssets']?.map((x) => Asset.fromMap(x)))
        : null;

    return Asset(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      locationId: map['locationId'],
      parentId: map['parentId'],
      components: components,
      subAssets: subAssets,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory Asset.fromJson(String source) => Asset.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Asset(id: $id, name: $name, locationId: $locationId, parentId: $parentId, components: $components, subAssets: $subAssets)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Asset &&
        other.id == id &&
        other.name == name &&
        other.locationId == locationId &&
        other.parentId == parentId &&
        listEquals(other.components, components) &&
        listEquals(other.subAssets, subAssets);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        locationId.hashCode ^
        parentId.hashCode ^
        components.hashCode ^
        subAssets.hashCode;
  }
}
