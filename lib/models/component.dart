import 'package:flutter/material.dart';
import 'package:tractian_app/utils/images.dart';

enum ComponentStatus {
  operating,
  alert,
}

enum SensorType { energy, vibration }

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
}
