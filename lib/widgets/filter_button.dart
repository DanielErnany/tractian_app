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
  bool _isActive = false;

  void _onPressed() {
    setState(() {
      _isActive = !_isActive;
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = _isActive ? Colors.blue : Colors.white;
    Color iconColor = _isActive ? Colors.white : Colors.grey;
    Color textColor = _isActive ? Colors.white : Colors.grey;
    BorderSide? borderSide =
        _isActive ? null : const BorderSide(color: Colors.grey);

    return ElevatedButton.icon(
      onPressed: _onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: borderSide,
      ),
      icon: Icon(
        widget.icon,
        color: iconColor,
      ),
      label: Text(
        widget.text,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
