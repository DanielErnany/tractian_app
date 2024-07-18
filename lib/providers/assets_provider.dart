import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tractian_app/models/asset.dart';
import 'package:tractian_app/models/companie.dart';
import 'package:http/http.dart' as http;
import 'package:tractian_app/models/component.dart';
import 'package:tractian_app/models/item.dart';
import 'package:tractian_app/models/location.dart';
import 'package:tractian_app/requests/requests.dart';

class AssetsProvider extends ChangeNotifier {
  List<Companie> _companies = [];
  List<Location> _locations = [];
  List<Item> _items = [];

  List<Companie> get companies => [..._companies];
  List<Location> get locations => [..._locations];
  List<Item> get items => [..._items];

  Future<void> loadCompanies() async {
    try {
      _companies = [];
      final response = await http.get(
        Uri.parse(Requests.companies),
      );

      if (response.statusCode > 200) {
        throw Exception('Failed to load companies');
      }
      final List<dynamic> decodedData = jsonDecode(response.body);

      List<Map<String, dynamic>> companiesData =
          List<Map<String, dynamic>>.from(
        decodedData.map((item) => item as Map<String, dynamic>),
      );

      _companies = companiesData.map((e) => Companie.fromMap(e)).toList();

      notifyListeners();
    } on Exception {
      rethrow;
    }
    return Future.value();
  }

  Future<void> loadAllData({required String companieId}) async {
    try {
      await _loadLocations(companieId: companieId);
      await _loadAssets(companieId: companieId);
      notifyListeners();
    } on Exception {
      rethrow;
    }
  }

  Future<void> _loadLocations({required String companieId}) async {
    final response =
        await http.get(Uri.parse(Requests.locations(companieId: companieId)));
    if (response.statusCode > 200) {
      throw Exception('Failed to load locations');
    }

    final List<dynamic> decodedData = jsonDecode(response.body);
    _locations = [];
    for (var data in decodedData) {
      Location location = Location.fromMap(data);
      _locations.add(location);
    }
  }

  Future<void> _loadAssets({required String companieId}) async {
    final response =
        await http.get(Uri.parse(Requests.assets(companieId: companieId)));

    if (response.statusCode > 200) {
      throw Exception('Failed to load assets');
    }

    final List<dynamic> itemDecodedData = jsonDecode(response.body);
    final List<Item> items =
        itemDecodedData.map((data) => createItem(data)).toList();

    final List<Item> rootItems = _associateComponentsAndAssets(items);
    final List<String> itemsInLocation =
        _associateAssetsToLocation(rootItems, _locations);

    _removeItemsInLocation(rootItems, itemsInLocation);
    _associateLocationsAndSubLocations(_locations);

    _items = rootItems;
  }

  List<dynamic> filterLocationsAndItems({
    SensorType? sensorType,
    ComponentStatus? status,
    String? searchQuery,
  }) {
    List<dynamic> filteredLocationsAndItems = [];

    for (var location in _locations) {
      var filteredLocation =
          _filterLocation(location, sensorType, status, searchQuery);
      if (filteredLocation != null) {
        filteredLocationsAndItems.add(filteredLocation);
      }
    }

    for (var item in _items) {
      if (_containsMatchingComponentInItem(
          item, sensorType, status, searchQuery)) {
        filteredLocationsAndItems.add(item);
      }
    }

    return filteredLocationsAndItems;
  }

  Location? _filterLocation(
    Location location,
    SensorType? sensorType,
    ComponentStatus? status,
    String? searchQuery,
  ) {
    List<Asset> filteredAssets = [];
    List<Component> filteredComponents = [];

    for (var asset in location.assets) {
      var filteredAsset = _filterAsset(asset, sensorType, status, searchQuery);
      if (filteredAsset != null) {
        filteredAssets.add(filteredAsset);
      }
    }

    for (var component in location.components) {
      if (_containsMatchingComponentInItem(
          component, sensorType, status, searchQuery)) {
        filteredComponents.add(component);
      }
    }

    List<Location> filteredSubLocations = [];
    for (var subLocation in location.subLocations) {
      var filteredSubLocation =
          _filterLocation(subLocation, sensorType, status, searchQuery);
      if (filteredSubLocation != null) {
        filteredSubLocations.add(filteredSubLocation);
      }
    }

    bool matches = (searchQuery == null ||
            location.name.toLowerCase().contains(searchQuery.toLowerCase())) &&
        (sensorType == null ||
            filteredAssets.isNotEmpty ||
            filteredComponents.isNotEmpty) &&
        (status == null ||
            filteredAssets.isNotEmpty ||
            filteredComponents.isNotEmpty);

    if (matches ||
        filteredAssets.isNotEmpty ||
        filteredComponents.isNotEmpty ||
        filteredSubLocations.isNotEmpty) {
      return Location(
        id: location.id,
        name: location.name,
        components: filteredComponents,
        assets: filteredAssets,
        subLocations: filteredSubLocations,
        parentId: location.parentId,
      );
    }

    return null;
  }

  Asset? _filterAsset(
    Asset asset,
    SensorType? sensorType,
    ComponentStatus? status,
    String? searchQuery,
  ) {
    List<Asset> filteredSubAssets = [];
    List<Component> filteredComponents = [];

    for (var subAsset in asset.subAssets) {
      var filteredSubAsset =
          _filterAsset(subAsset, sensorType, status, searchQuery);
      if (filteredSubAsset != null) {
        filteredSubAssets.add(filteredSubAsset);
      }
    }

    for (var component in asset.components) {
      if (_containsMatchingComponentInItem(
          component, sensorType, status, searchQuery)) {
        filteredComponents.add(component);
      }
    }

    bool matches = (searchQuery == null ||
            asset.name.toLowerCase().contains(searchQuery.toLowerCase())) &&
        (sensorType == null || filteredComponents.isNotEmpty) &&
        (status == null || filteredComponents.isNotEmpty);

    if (matches ||
        filteredComponents.isNotEmpty ||
        filteredSubAssets.isNotEmpty) {
      return Asset(
        id: asset.id,
        name: asset.name,
        components: filteredComponents,
        subAssets: filteredSubAssets,
        locationId: asset.locationId,
        parentId: asset.parentId,
      );
    }

    return null;
  }

  bool _containsMatchingComponentInItem(
    Item item,
    SensorType? sensorType,
    ComponentStatus? status,
    String? searchQuery,
  ) {
    if (item is Component &&
        (sensorType == null || item.sensorType == sensorType) &&
        (status == null || item.status == status) &&
        (searchQuery == null ||
            item.name.toLowerCase().contains(searchQuery.toLowerCase()))) {
      return true;
    }

    if (item is Asset) {
      for (var component in item.components) {
        if (_containsMatchingComponentInItem(
            component, sensorType, status, searchQuery)) {
          return true;
        }
      }

      for (var subAsset in item.subAssets) {
        if (_containsMatchingComponentInItem(
            subAsset, sensorType, status, searchQuery)) {
          return true;
        }
      }
    }

    return false;
  }

  List<Item> _associateComponentsAndAssets(List<Item> items) {
    final List<Item> rootItems = [];
    for (var item in items) {
      if (item.parentId == null) {
        rootItems.add(item);
      } else {
        Asset parent =
            items.firstWhere((element) => element.id == item.parentId) as Asset;
        if (item is Component) {
          parent.components.add(item);
        } else {
          parent.subAssets.add(item as Asset);
        }
      }
    }
    return rootItems;
  }

  List<String> _associateAssetsToLocation(
      List<Item> rootItems, List<Location> locations) {
    final List<String> itemsInLocation = [];
    for (Item item in rootItems) {
      if (item.locationId != null) {
        Location location =
            locations.firstWhere((element) => element.id == item.locationId);
        itemsInLocation.add(item.id);
        if (item is Component) {
          location.components.add(item);
        } else {
          location.assets.add(item as Asset);
        }
      }
    }
    return itemsInLocation;
  }

  void _removeItemsInLocation(
      List<Item> rootItems, List<String> itemsInLocation) {
    for (var itemId in itemsInLocation) {
      rootItems.removeWhere((element) => element.id == itemId);
    }
  }

  void _associateLocationsAndSubLocations(List<Location> locations) {
    List<String> subLocations = [];
    for (var location in _locations) {
      if (location.parentId != null) {
        subLocations.add(location.id);
        Location parent =
            locations.firstWhere((element) => element.id == location.parentId);
        parent.subLocations.add(location);
      }
    }
    for (var locationId in subLocations) {
      locations.removeWhere((element) => element.id == locationId);
    }
  }

  Item createItem(Map<String, dynamic> map) {
    if (map.containsKey('sensorType') && map['sensorType'] != null) {
      return Component.fromMap(map);
    } else {
      return Asset.fromMap(map);
    }
  }
}
