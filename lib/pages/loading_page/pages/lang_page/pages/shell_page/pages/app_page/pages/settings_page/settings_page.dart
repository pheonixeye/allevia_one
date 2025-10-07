import 'package:allevia_one/constants/app_business_constants.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/change_log_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/change_password_btn.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/connect_wa_btn.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_whatsapp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/language_btn.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/logout_btn.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(context.loc.settings),
              subtitle: const Divider(),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Consumer2<PxAuth, PxLocale>(
                  builder: (context, a, l, _) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card.outlined(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8,
                                children: [
                                  if (a.user == null)
                                    SizedBox(
                                      height: 10,
                                      child: LinearProgressIndicator(),
                                    )
                                  else ...[
                                    Text('${a.user?.email}'),
                                    Text(
                                        '${l.isEnglish ? a.user?.account_type.name_en : a.user?.account_type.name_ar}'),
                                  ]
                                ],
                              ),
                            ),
                            subtitle: const Divider(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.loc.appLanguage),
                        ),
                        trailing: const LanguageBtn(),
                        subtitle: const Divider(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.loc.changePassword),
                        ),
                        trailing: const ChangePasswordBtn(),
                        subtitle: const Divider(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(context.loc.logout),
                        ),
                        trailing: const LogoutBtn(),
                        subtitle: const Divider(),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Consumer<PxWhatsapp>(
                  builder: (context, w, _) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card.outlined(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(context.loc.whatsappSettings),
                                  const Spacer(),
                                  const ConnectWaBtn(),
                                  const SizedBox(width: 10),
                                  FloatingActionButton.small(
                                    tooltip: context
                                        .loc.showConnectedwhatsappDevices,
                                    heroTag: UniqueKey(),
                                    onPressed: () async {
                                      await shellFunction(
                                        context,
                                        toExecute: () async {
                                          await w.fetchConnectedDevices();
                                        },
                                      );
                                    },
                                    child: const Icon(Icons.device_hub),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(context.loc.whatsappDevices),
                                ),
                                if (w.connectedDevices != null) ...[
                                  ...w.connectedDevices!.map((e) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    );
                                  })
                                ],
                                if (w.connectedDevices == null)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(context.loc.noConnectedDevices),
                                  ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Allevia-One v${AppBusinessConstants.ALLEVIA_VERSION}',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return ChangeLogDialog();
                        },
                      );
                    },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
