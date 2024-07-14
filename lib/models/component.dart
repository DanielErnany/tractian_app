import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:tractian_app/utils/images.dart';

enum ComponentStatus {
  operating,
  alert;

  @override
  String toString() {
    switch (this) {
      case ComponentStatus.operating:
        return 'operating';

      case ComponentStatus.alert:
        return 'alert';

      default:
        return "";
    }
  }

  static ComponentStatus? fromString(String string) {
    Map<String, ComponentStatus> valuesMap = {};

    for (var element in ComponentStatus.values) {
      valuesMap.addAll({element.toString(): element});
    }

    return valuesMap[string];
  }
}

enum SensorType {
  energy,
  vibration;

  @override
  String toString() {
    switch (this) {
      case SensorType.energy:
        return 'energy';

      case SensorType.vibration:
        return 'vibration';

      default:
        return "";
    }
  }

  static SensorType? fromString(String string) {
    Map<String, SensorType> valuesMap = {};

    for (var element in SensorType.values) {
      valuesMap.addAll({element.toString(): element});
    }

    return valuesMap[string];
  }
}

class Component {
  final String id;
  final String name;
  final SensorType sensorType;
  final ComponentStatus status;
  final String? parentId;

  Component({
    required this.id,
    required this.name,
    required this.sensorType,
    required this.status,
    this.parentId,
  });

  String get imageIcon => Images.componentIcon;

  IconData? get sensorTypeIcon => Icons.flash_on;
  Widget? get statusWidget {
    double radio = 20;

    return ComponentStatus.alert == status
        ? Container(
            width: radio,
            height: radio,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
          )
        : null;
  }

  Component copyWith({
    String? id,
    String? name,
    SensorType? sensorType,
    ComponentStatus? status,
    String? parentId,
  }) {
    return Component(
      id: id ?? this.id,
      name: name ?? this.name,
      sensorType: sensorType ?? this.sensorType,
      status: status ?? this.status,
      parentId: parentId ?? this.parentId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'sensorType': sensorType.toString()});
    result.addAll({'status': status.toString()});
    if (parentId != null) {
      result.addAll({'parentId': parentId});
    }

    return result;
  }

  factory Component.fromMap(Map<String, dynamic> map) {
    return Component(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      sensorType: SensorType.fromString(map['sensorType'])!,
      status: ComponentStatus.fromString(map['status'])!,
      parentId: map['parentId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Component.fromJson(String source) =>
      Component.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Component(id: $id, name: $name, sensorType: $sensorType, status: $status, parentId: $parentId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Component &&
        other.id == id &&
        other.name == name &&
        other.sensorType == sensorType &&
        other.status == status &&
        other.parentId == parentId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        sensorType.hashCode ^
        status.hashCode ^
        parentId.hashCode;
  }
}
