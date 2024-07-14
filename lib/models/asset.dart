import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tractian_app/models/component.dart';
import 'package:tractian_app/utils/images.dart';

class Asset {
  final String id;
  final String name;
  final String? locationId;
  final String? parentId;

  List<Component> components;
  List<Asset> subAssets;

  Asset({
    required this.id,
    required this.name,
    this.locationId,
    this.parentId,
    required this.components,
    required this.subAssets,
  });

  bool get hasChildren => components.isNotEmpty || subAssets.isNotEmpty;

  String get imageIcon => Images.assetIcon;

  Asset copyWith({
    String? id,
    String? name,
    String? locationId,
    String? parentId,
    List<Component>? components,
    List<Asset>? subAssets,
  }) {
    return Asset(
      id: id ?? this.id,
      name: name ?? this.name,
      locationId: locationId ?? this.locationId,
      parentId: parentId ?? this.parentId,
      components: components ?? this.components,
      subAssets: subAssets ?? this.subAssets,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    if (locationId != null) {
      result.addAll({'locationId': locationId});
    }
    if (parentId != null) {
      result.addAll({'parentId': parentId});
    }
    result.addAll({'components': components.map((x) => x.toMap()).toList()});
    result.addAll({'subAssets': subAssets.map((x) => x.toMap()).toList()});

    return result;
  }

  factory Asset.fromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      locationId: map['locationId'],
      parentId: map['parentId'],
      components: List<Component>.from(
          map['components']?.map((x) => Component.fromMap(x))),
      subAssets:
          List<Asset>.from(map['subAssets']?.map((x) => Asset.fromMap(x))),
    );
  }

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
