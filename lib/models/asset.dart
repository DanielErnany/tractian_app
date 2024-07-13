import 'package:tractian_app/models/component.dart';
import 'package:tractian_app/utils/images.dart';

class Asset {
  final String id;
  final String name;
  final String? locationId;
  final String? parentId;

  List<Component> components = [];
  List<Asset> subAssets = [];

  Asset({
    required this.id,
    required this.name,
    this.locationId,
    this.parentId,
  });

  bool get hasChildren => components.isNotEmpty || subAssets.isNotEmpty;

  String get imageIcon => Images.assetIcon;
}
