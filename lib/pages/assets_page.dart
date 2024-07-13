import 'package:flutter/material.dart';
import 'package:tractian_app/models/asset.dart';
import 'package:tractian_app/models/component.dart';
import 'package:tractian_app/models/location.dart';
import 'package:tractian_app/widgets/filter_button.dart';
import 'package:tractian_app/widgets/tree_view.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  EdgeInsets leftPadding = const EdgeInsets.only(left: 15);

  Widget buildComponentNode(Component component) {
    return TreeView(
      title: component.name,
      iconImage: component.imageIcon,
      padding: leftPadding,
      sensorTypeIcon: component.sensorTypeIcon,
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
    // Criando componentes
    Component motorRTCoalAF01 = Component(
        id: '1',
        name: 'MOTOR RT COAL AF01',
        sensorType: SensorType.vibration,
        status: ComponentStatus.operating);
    Component fanExternal = Component(
        id: '2',
        name: 'Fan - External',
        sensorType: SensorType.vibration,
        status: ComponentStatus.operating);

    // Criando sub-ativos
    Asset motorTC01CoalUnloadingAF02 =
        Asset(id: '3', name: 'MOTOR TC01 COAL UNLOADING AF02');
    motorTC01CoalUnloadingAF02.components.add(motorRTCoalAF01);

    // Criando ativos
    Asset conveyorBeltAssembly = Asset(id: '4', name: 'CONVEYOR BELT ASSEMBLY');
    conveyorBeltAssembly.subAssets.add(motorTC01CoalUnloadingAF02);

    // Criando localizações e sub-localizações
    Location charcoalStorageSector =
        Location(id: '5', name: 'CHARCOAL STORAGE SECTOR');
    charcoalStorageSector.assets.add(conveyorBeltAssembly);

    Location productionAreaRawMaterial =
        Location(id: '6', name: 'PRODUCTION AREA - RAW MATERIAL');
    productionAreaRawMaterial.subLocations.add(charcoalStorageSector);

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
      body: ListView(
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
          TreeView(
            title: productionAreaRawMaterial.name,
            padding: leftPadding,
            iconImage: productionAreaRawMaterial.imageIcon,
            children: productionAreaRawMaterial.subLocations
                .map((subLocation) => buildLocationNode(
                      subLocation,
                    ))
                .toList(),
          ),
          TreeView(
            title: fanExternal.name,
            iconImage: fanExternal.imageIcon,
            padding: leftPadding,
            statusWidget: fanExternal.statusWidget,
            sensorTypeIcon: fanExternal.sensorTypeIcon,
            children: const [],
          ),
        ],
      ),
    );
  }
}
