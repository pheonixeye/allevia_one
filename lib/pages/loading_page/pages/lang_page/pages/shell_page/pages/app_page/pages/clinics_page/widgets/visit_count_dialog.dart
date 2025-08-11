import 'package:flutter/material.dart';
import 'package:allevia_one/extensions/loc_ext.dart';

class VisitCountDialog extends StatelessWidget {
  const VisitCountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(context.loc.visitsPerShift),
          ),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      scrollable: false,
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...List.generate(10, (index) => (index + 1) * 5).map((e) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilterChip.elevated(
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('$e'),
                ),
                onSelected: (val) {
                  Navigator.pop(context, e);
                },
              ),
            );
          })
        ],
      ),
    );
  }
}
