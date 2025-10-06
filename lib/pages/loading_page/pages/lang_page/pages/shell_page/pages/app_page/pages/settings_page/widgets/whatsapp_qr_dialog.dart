import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WhatsappQrDialog extends StatelessWidget {
  const WhatsappQrDialog({super.key, required this.qrLink});
  final String qrLink;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blue.shade50,
      title: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: context.loc.scanQrCode,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
          SizedBox(width: 10),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      insetPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: CachedNetworkImage(
          imageUrl: qrLink,
        ),
      ),
    );
  }
}
