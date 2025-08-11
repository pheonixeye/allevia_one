import 'package:flutter/material.dart';

class ThemedPopupmenuBtn<T> extends StatelessWidget {
  const ThemedPopupmenuBtn({
    super.key,
    required this.itemBuilder,
    required this.icon,
    required this.tooltip,
  });
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final Icon icon;
  final String tooltip;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      tooltip: tooltip,
      icon: icon,
      itemBuilder: itemBuilder,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
      ),
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevation: WidgetStatePropertyAll(6),
        shadowColor: WidgetStatePropertyAll(Colors.grey),
        backgroundColor: WidgetStatePropertyAll(Colors.orange.shade300),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
      ),
      borderRadius: BorderRadius.circular(8),
      iconColor: Colors.white,
      elevation: 8,
      offset: const Offset(0, 32),
    );
  }
}
