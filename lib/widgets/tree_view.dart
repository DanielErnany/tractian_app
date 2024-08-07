import 'package:flutter/material.dart';
import 'package:tractian_app/models/component.dart';

class TreeView extends StatelessWidget {
  final String title;
  final SensorType? sensorType;
  final Widget? statusWidget;
  final String? iconImage;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const TreeView({
    super.key,
    required this.title,
    required this.children,
    this.iconImage,
    this.padding,
    this.sensorType,
    this.statusWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget titleWidget = Row(
      children: [
        Container(
          height: 30,
          width: 2,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 5,
          child: Divider(
            color: Colors.grey,
            thickness: 2,
          ),
        ),
        const SizedBox(width: 5),
        if (iconImage != null) Image.asset(iconImage!, height: 20),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (sensorType != null)
          Icon(
            sensorType!.toIcon(),
          ),
        if (statusWidget != null) statusWidget!,
      ],
    );

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: (children.isEmpty)
          ? ListTile(title: titleWidget)
          : ExpansionTile(
              childrenPadding: padding,
              title: titleWidget,
              children: children,
            ),
    );
  }
}
