import 'package:flutter/material.dart';
import 'package:tractian_app/utils/images.dart';
import 'package:tractian_app/utils/routes.dart';
import 'package:tractian_app/widgets/companie_button.dart';

import '../models/companie.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<Companie> _companies = [
    Companie(name: "Companie 1", id: "testId1"),
    Companie(name: "Companie 2", id: "testId2"),
    Companie(name: "Companie 3", id: "testId3"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 25,
          child: Image.asset(Images.tractianLogo),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 40,
        ),
        itemCount: _companies.length,
        separatorBuilder: (context, index) => const SizedBox(
          height: 40,
        ),
        itemBuilder: (context, index) {
          return SizedBox(
            height: 100,
            child: CompanieButton(
              name: _companies[index].name,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.assetsPage,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
