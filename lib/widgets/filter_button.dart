import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  String text;
  IconData icon;
  Function() onPressed;
  FilterButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Colors.grey)),
      icon: Icon(
        widget.icon,
        color: Colors.grey,
      ),
      label: Text(
        widget.text,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
