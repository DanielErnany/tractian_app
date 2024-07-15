import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tractian_app/models/asset.dart';
import 'package:tractian_app/models/component.dart';
import 'package:tractian_app/utils/images.dart';

class Location {
  final String id;
  final String name;
  final String? parentId;
  List<Location> subLocations;
  List<Component> components;
  List<Asset> assets;

  Location({
    List<Location>? subLocations,
    List<Component>? components,
    List<Asset>? assets,
    required this.id,
    required this.name,
    this.parentId,
  })  : subLocations = subLocations ?? [],
        components = components ?? [],
        assets = assets ?? [];

  String get imageIcon => Images.locationIcon;

  Location copyWith({
    String? id,
    String? name,
    String? parentId,
    List<Location>? subLocations,
    List<Component>? components,
    List<Asset>? assets,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      subLocations: subLocations ?? this.subLocations,
      components: components ?? this.components,
      assets: assets ?? this.assets,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    if (parentId != null) {
      result.addAll({'parentId': parentId});
    }
    result
        .addAll({'subLocations': subLocations.map((x) => x.toMap()).toList()});
    result.addAll({'components': components.map((x) => x.toMap()).toList()});
    result.addAll({'assets': assets.map((x) => x.toMap()).toList()});

    return result;
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      parentId: map['parentId'],
      subLocations: map['subLocations'] != null
          ? List<Location>.from(
              map['subLocations']?.map((x) => Location.fromMap(x)))
          : [],
      components: map['components'] != null
          ? List<Component>.from(
              map['components']?.map((x) => Component.fromMap(x)))
          : [],
      assets: map['assets'] != null
          ? List<Asset>.from(map['assets']?.map((x) => Asset.fromMap(x)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Location.fromJson(String source) =>
      Location.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Location(id: $id, name: $name, parentId: $parentId, subLocations: $subLocations, components: $components, assets: $assets)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Location &&
        other.id == id &&
        other.name == name &&
        other.parentId == parentId &&
        listEquals(other.subLocations, subLocations) &&
        listEquals(other.components, components) &&
        listEquals(other.assets, assets);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        parentId.hashCode ^
        subLocations.hashCode ^
        components.hashCode ^
        assets.hashCode;
  }
}
