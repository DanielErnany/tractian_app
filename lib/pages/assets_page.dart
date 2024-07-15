import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractian_app/models/asset.dart';
import 'package:tractian_app/models/component.dart';
import 'package:tractian_app/models/item.dart';
import 'package:tractian_app/models/location.dart';
import 'package:tractian_app/providers/assets_provider.dart';
import 'package:tractian_app/widgets/filter_button.dart';
import 'package:tractian_app/widgets/tree_view.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  EdgeInsets leftPadding = const EdgeInsets.only(left: 15);

  late String companieId;

  late List<Location> _locations;

  late List<Item> _items;

  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    companieId = ModalRoute.of(context)?.settings.arguments as String;

    loadDatas();
  }

  void loadDatas() async {
    setState(() {
      _isLoading = true;
    });
    final provider = Provider.of<AssetsProvider>(context, listen: false);

    await provider.loadAllData(companieId: companieId);

    setState(() {
      _locations = provider.locations;
      _items = provider.items;
      _isLoading = false;
    });
  }

  Widget buildComponentNode(Component component) {
    return TreeView(
      title: component.name,
      iconImage: component.imageIcon,
      padding: leftPadding,
        sensorType: component.sensorType,
      statusWidget: component.statusWidget,
      children: const [],
    );
  }

  Widget buildAssetNode(Asset asset) {
    return TreeView(
      title: asset.name,
      iconImage: asset.imageIcon,
      padding: leftPadding,
      children: [
        ...asset.subAssets.map((subAsset) => buildAssetNode(subAsset)).toList(),
        ...asset.components
            .map((component) => buildComponentNode(component))
            .toList(),
      ],
    );
  }

  Widget buildLocationNode(Location location) {
    return TreeView(
      title: location.name,
      iconImage: location.imageIcon,
      padding: leftPadding,
      children: [
        ...location.subLocations
            .map((subLocation) => buildLocationNode(subLocation))
            .toList(),
        ...location.assets
            .map((asset) => buildAssetNode(
                  asset,
                ))
            .toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
        leading: IconButton(
          onPressed: (() {
            Navigator.of(context).pop();
          }),
          icon: const Icon(Icons.arrow_back_ios_new_sharp),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 25),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 10),
                        color: const Color.fromRGBO(234, 239, 243, 1),
                        child: Row(
                          children: const [
                            Icon(Icons.search),
                            Text("Buscar Ativo ou Local")
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(children: [
                        FilterButton(
                          icon: Icons.flash_on,
                          text: "Sensor de energia",
                          onPressed: () {},
                        ),
                        const Spacer(flex: 1),
                        FilterButton(
                          icon: Icons.error,
                          text: "Crítico",
                          onPressed: () {},
                        ),
                        const Spacer(flex: 3),
                      ])
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1.5),
                ..._locations
                    .map(
                      (location) => buildLocationNode(location),
                    )
                    .toList(),
                ..._items.map((item) {
                  if (item is Asset) {
                    return buildAssetNode(item);
                  } else {
                    return buildComponentNode(item as Component);
                  }
                }).toList(),
              ],
            ),
    );
  }
}
