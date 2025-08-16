import 'package:allevia_one/constants/app_business_constants.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/settings_page/widgets/change_password_btn.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/providers/px_locale.dart';
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
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Allevia-One v${AppBusinessConstants.ALLEVIA_VERSION}'),
            ],
          ),
        ],
      ),
    );
  }
}
