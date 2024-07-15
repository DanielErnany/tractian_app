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
    final List<Item> items = [];

    for (var data in itemDecodedData) {
      Item item = createItem(data);
      items.add(item);
    }

    final List<Item> rootItems = [];

// Associa Components e Assets e Assets e SubAssts
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

    List<String> itemsInLocation = [];
// Associa Assets e Componets a Location
    for (Item item in rootItems) {
      if (item.locationId != null) {
        Location location =
            _locations.firstWhere((element) => element.id == item.locationId);
        itemsInLocation.add(item.id);
        if (item is Component) {
          location.components.add(item);
        } else {
          location.assets.add(item as Asset);
        }
      }
    }

// Remove Items que já estão em uma Location
    for (var itemId in itemsInLocation) {
      rootItems.removeWhere((element) => element.id == itemId);
    }

// Associa Locations e SubLocations
    List<String> subLocations = [];
    for (var location in _locations) {
      if (location.parentId != null) {
        subLocations.add(location.id);
        Location parent =
            _locations.firstWhere((element) => element.id == location.parentId);

        parent.subLocations.add(location);
      }
    }
    // Remove sublocations que já estão em uma Location
    for (var locationId in subLocations) {
      _locations.removeWhere((element) => element.id == locationId);
    }

    _items = rootItems;
  }

  Item createItem(Map<String, dynamic> map) {
    if (map.containsKey('sensorType') && map['sensorType'] != null) {
      return Component.fromMap(map);
    } else {
      return Asset.fromMap(map);
    }
  }
}
