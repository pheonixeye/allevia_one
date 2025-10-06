import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/whatsapp_qr_dialog.dart';
import 'package:allevia_one/providers/px_whatsapp.dart';
import 'package:allevia_one/widgets/snackbar_.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ConnectWaBtn extends StatelessWidget {
  const ConnectWaBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxWhatsapp>(
      builder: (context, w, _) {
        return FloatingActionButton.small(
          tooltip: context.loc.connectWhatsapp,
          heroTag: UniqueKey(),
          onPressed: () async {
            await shellFunction(
              context,
              toExecute: () async {
                await w.login();
              },
              duration: const Duration(milliseconds: 50),
            );
            if (w.qrLink == null && context.mounted) {
              showIsnackbar(context.loc.error);
              return;
            }

            if (context.mounted) {
              await showDialog<void>(
                context: context,
                builder: (context) {
                  return WhatsappQrDialog(
                    qrLink: w.qrLink!,
                  );
                },
              );
            }
          },
          child: const Icon(FontAwesomeIcons.whatsapp),
        );
      },
    );
  }
}
