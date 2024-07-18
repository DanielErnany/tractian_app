import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tractian_app/models/asset.dart';
import 'package:tractian_app/models/component.dart';
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

  late List<dynamic> _locationsAndItems;

  bool _isLoading = true;

  SensorType? _selectedSensorType;
  ComponentStatus? _selectedStatus;
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  bool _isEnergyFilterActive = false;
  bool _isAlertStatusFilterActive = false;

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
      _locationsAndItems = provider.filterLocationsAndItems(
        sensorType: _selectedSensorType,
        status: _selectedStatus,
        searchQuery: _searchQuery,
      );
      _isLoading = false;
    });
  }

  void _filterSearchResults(String query) {
    setState(() {
      _searchQuery = query;

      final provider = Provider.of<AssetsProvider>(context, listen: false);
      _locationsAndItems = provider.filterLocationsAndItems(
        sensorType: _selectedSensorType,
        status: _selectedStatus,
        searchQuery: _searchQuery,
      );
    });
  }

  void _applyFilter(SensorType? sensorType, ComponentStatus? status) {
    setState(() {
      _selectedSensorType = sensorType;
      _selectedStatus = status;

      final provider = Provider.of<AssetsProvider>(context, listen: false);
      _locationsAndItems = provider.filterLocationsAndItems(
        sensorType: _selectedSensorType,
        status: _selectedStatus,
        searchQuery: _searchQuery,
      );
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
        ...location.components
            .map((component) => buildComponentNode(component))
            .toList(),
        ...location.assets.map((asset) => buildAssetNode(asset)).toList(),
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
                          children: [
                            const Icon(Icons.search),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: "Buscar Ativo ou Local",
                                  border: InputBorder.none,
                                ),
                                onChanged: _filterSearchResults,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(children: [
                        FilterButton(
                          icon: Icons.flash_on,
                          text: "Sensor de energia",
                          isActive: _isEnergyFilterActive,
                          onPressed: () {
                            SensorType? sensorType =
                                _selectedSensorType == SensorType.energy
                                    ? null
                                    : SensorType.energy;
                            _isEnergyFilterActive = !_isEnergyFilterActive;
                            _applyFilter(sensorType, _selectedStatus);
                          },
                        ),
                        const Spacer(flex: 1),
                        FilterButton(
                          icon: Icons.error,
                          text: "Crítico",
                          isActive: _isAlertStatusFilterActive,
                          onPressed: () {
                            ComponentStatus? status =
                                _selectedStatus == ComponentStatus.alert
                                    ? null
                                    : ComponentStatus.alert;
                            _isAlertStatusFilterActive =
                                !_isAlertStatusFilterActive;
                            _applyFilter(_selectedSensorType, status);
                          },
                        ),
                        const Spacer(flex: 3),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(thickness: 1.5),
                ..._locationsAndItems.map((item) {
                  if (item is Location) {
                    return buildLocationNode(item);
                  } else if (item is Asset) {
                    return buildAssetNode(item);
                  } else if (item is Component) {
                    return buildComponentNode(item);
                  } else {
                    return const SizedBox.shrink();
                  }
                }).toList(),
              ],
            ),
    );
  }
}
