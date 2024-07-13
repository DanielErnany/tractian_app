import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractian_app/providers/assets_provider.dart';
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
  List<Companie> _companies = [];
  bool _isLoading = true;
  bool _isErrorLoad = false;

  @override
  void initState() {
    super.initState();
    loadDatas();
  }

  void loadDatas() async {
    setState(() {
      _isLoading = true;
      _isErrorLoad = false;
    });

    try {
      final providerAssets =
          Provider.of<AssetsProvider>(context, listen: false);
      await providerAssets.loadCompanies();
      setState(() {
        _companies = providerAssets.companies;
      });
    } on Exception {
      setState(() {
        _isErrorLoad = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 25,
          child: Image.asset(Images.tractianLogo),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _isErrorLoad
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.cloud_off,
                        size: 64,
                      ),
                      Text(
                        "Erro ao carregar companias !",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                )
              : ListView.separated(
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
