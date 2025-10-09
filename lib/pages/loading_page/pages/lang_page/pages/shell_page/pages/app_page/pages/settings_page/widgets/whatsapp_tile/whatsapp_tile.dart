import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/whatsapp_tile/whatsapp_qr_dialog.dart';
import 'package:allevia_one/providers/px_whatsapp.dart';
import 'package:allevia_one/widgets/snackbar_.dart';
import 'package:allevia_one/widgets/themed_popupmenu_btn.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class WhatsappTile extends StatelessWidget {
  const WhatsappTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PxWhatsapp>(
      builder: (context, w, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(context.loc.whatsappSettings),
                ),
                isThreeLine: true,
                trailing: ThemedPopupmenuBtn(
                  tooltip: context.loc.settings,
                  icon: const Icon(Icons.menu),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            const Icon(FontAwesomeIcons.whatsapp),
                            SizedBox(width: 4),
                            Text(context.loc.connectWhatsapp),
                          ],
                        ),
                        onTap: () async {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await w.login();
                            },
                            duration: const Duration(milliseconds: 100),
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
                            ).whenComplete(() async {
                              await w.fetchConnectedDevices();
                            });
                          }
                        },
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            const Icon(Icons.device_hub),
                            SizedBox(width: 4),
                            Text(context.loc.showConnectedwhatsappDevices),
                          ],
                        ),
                        onTap: () async {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await w.fetchConnectedDevices();
                            },
                          );
                        },
                      ),
                    ];
                  },
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: FloatingActionButton.small(
                        onPressed: null,
                        heroTag: UniqueKey(),
                      ),
                      titleAlignment: ListTileTitleAlignment.top,
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(context.loc.whatsappDevices),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (w.connectedDevices != null) ...[
                            ...w.connectedDevices!.map((e) {
                              return Card.outlined(
                                elevation: 2,
                                color: Colors.amber.shade50,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...e.entries.map((x) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          title: Text('${x.key}'),
                                          subtitle: Text('${x.value}'),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            })
                          ],
                          if (w.connectedDevices == null)
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  context.loc.noConnectedDevices,
                                ),
                              ),
                            ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
