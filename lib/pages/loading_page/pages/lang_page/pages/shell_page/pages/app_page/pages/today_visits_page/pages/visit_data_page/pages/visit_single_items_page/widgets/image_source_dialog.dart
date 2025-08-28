import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceDialog extends StatelessWidget {
  const ImageSourceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(context.loc.pickImageSource),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton.outlined(
              onPressed: () {
                Navigator.pop(context, null);
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
      scrollable: true,
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: Column(
        spacing: 8,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context, ImageSource.camera);
            },
            label: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(context.loc.camera),
            ),
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.camera),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context, ImageSource.gallery);
            },
            label: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(context.loc.file),
            ),
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.file_copy),
            ),
          ),
        ],
      ),
    );
  }
}
