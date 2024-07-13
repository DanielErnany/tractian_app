import 'package:tractian_app/models/asset.dart';
import 'package:tractian_app/utils/images.dart';

class Location {
  final String id;
  final String name;
  final String? parentId;
  List<Location> subLocations = [];
  List<Asset> assets = [];

  Location({
    required this.id,
    required this.name,
    this.parentId,
  });

  String get imageIcon => Images.locationIcon;
}
