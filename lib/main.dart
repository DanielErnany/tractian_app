import 'package:flutter/material.dart';
import 'package:tractian_app/pages/assets_page.dart';
import 'package:tractian_app/pages/menu_page.dart';
import 'package:tractian_app/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(23, 25, 45, 1),
          centerTitle: true,
        ),
      ),
      initialRoute: AppRoutes.menuPage,
      routes: {
        AppRoutes.menuPage: (context) => const MenuPage(),
        AppRoutes.assetsPage: (context) => const AssetsPage(),
      },
      // home: const MenuPage(),
    );
  }
}
