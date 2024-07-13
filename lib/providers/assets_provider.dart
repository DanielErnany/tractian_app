import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tractian_app/models/companie.dart';
import 'package:http/http.dart' as http;
import 'package:tractian_app/requests/requests.dart';

class AssetsProvider extends ChangeNotifier {
  List<Companie> _companies = [];

  List<Companie> get companies => [..._companies];

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
}
