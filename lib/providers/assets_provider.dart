import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tractian_app/models/companie.dart';
import 'package:http/http.dart' as http;
import 'package:tractian_app/models/location.dart';
import 'package:tractian_app/requests/requests.dart';

class AssetsProvider extends ChangeNotifier {
  List<Companie> _companies = [];
  List<Location> _locations = [];

  List<Companie> get companies => [..._companies];
  List<Location> get locations => [..._locations];

  Future<void> loadCompanies() async {
    try {
      _companies = [];
      final response = await http.get(
        Uri.parse(Requests.companies),
      );

      if (response.statusCode > 200) {
        throw Exception();
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

  Future<void> loadLocations({required String companieId}) async {
    try {
      _locations = [];
      final response = await http.get(
        Uri.parse(Requests.locations(companieId: companieId)),
      );

      if (response.statusCode > 200) {
        throw Exception();
      }
      final List<dynamic> decodedData = jsonDecode(response.body);

      List<Map<String, dynamic>> locationsData =
          List<Map<String, dynamic>>.from(
        decodedData.map((item) => item as Map<String, dynamic>),
      );

      Map<String, Location> locationMap = {};
      List<Location> rootLocations = [];

      for (var locationData in locationsData) {
        Location location = Location.fromMap(locationData);
        locationMap[location.id] = location;
      }

      for (var location in locationMap.values) {
        if (location.parentId == null) {
          rootLocations.add(location);
        } else {
          if (locationMap.containsKey(location.parentId)) {
            locationMap[location.parentId]!.subLocations.add(location);
          }
        }
      }

      _locations = rootLocations;

      notifyListeners();
    } on Exception {
      rethrow;
    }
    return Future.value();
  }
}
