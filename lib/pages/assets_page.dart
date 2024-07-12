import 'package:flutter/material.dart';
import 'package:tractian_app/widgets/filter_button.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
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
        ],
      ),
    );
  }
}
