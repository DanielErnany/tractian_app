import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isActive;
  final Function() onPressed;

  const FilterButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isActive ? Colors.blue : Colors.white;
    Color iconColor = isActive ? Colors.white : Colors.grey;
    Color textColor = isActive ? Colors.white : Colors.grey;
    BorderSide? borderSide =
        isActive ? null : const BorderSide(color: Colors.grey);

    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: borderSide,
      ),
      icon: Icon(
        icon,
        color: iconColor,
      ),
      label: Text(
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
