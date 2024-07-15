import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:tractian_app/models/item.dart';
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

  @override
  IconData toIcon() {
    switch (this) {
      case SensorType.energy:
        return Icons.flash_on;

      case SensorType.vibration:
        return Icons.sensors;
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

class Component extends Item {
  final String sensorId;
  final SensorType sensorType;
  final ComponentStatus status;
  final String gatewayId;

  Component({
    required String id,
    required String name,
    String? parentId,
    String? locationId,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
  }) : super(id: id, name: name, parentId: parentId, locationId: locationId);

  @override
  String get imageIcon => Images.componentIcon;

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

  factory Component.fromMap(Map<String, dynamic> map) {
    return Component(
      id: map['id'],
      name: map['name'],
      parentId: map['parentId'],
      locationId: map['locationId'],
      sensorId: map['sensorId'],
      sensorType: SensorType.fromString(map['sensorType'])!,
      status: ComponentStatus.fromString(map['status'])!,
      gatewayId: map['gatewayId'],
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory Component.fromJson(String source) =>
      Component.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Component(sensorId: $sensorId, sensorType: $sensorType, status: $status, gatewayId: $gatewayId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Component &&
        other.sensorId == sensorId &&
        other.sensorType == sensorType &&
        other.status == status &&
        other.gatewayId == gatewayId;
  }

  @override
  int get hashCode {
    return sensorId.hashCode ^
        sensorType.hashCode ^
        status.hashCode ^
        gatewayId.hashCode;
  }
}
