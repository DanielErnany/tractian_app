import 'package:flutter/material.dart';
import 'package:tractian_app/utils/images.dart';

class CompanieButton extends StatelessWidget {
  String name;
  String id;
  CompanieButton({
    Key? key,
    required this.name,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (() {}),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.only(left: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: Image.asset(Images.companieIcon),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
