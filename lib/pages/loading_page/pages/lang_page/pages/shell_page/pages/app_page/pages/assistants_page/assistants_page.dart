import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/user/user.dart';
import 'package:allevia_one/models/user/user_with_password.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/assistants_page/widgets/add_assistant_account_dialog.dart';
import 'package:allevia_one/providers/px_app_constants.dart';
import 'package:allevia_one/providers/px_assistant_accounts.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:allevia_one/widgets/central_no_items.dart';
import 'package:allevia_one/widgets/snackbar_.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssistantsPage extends StatelessWidget {
  const AssistantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxAppConstants, PxAssistantAccounts, PxLocale>(
      builder: (context, a, c, l, _) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'add-assistant-account',
            onPressed: () async {
              final _userWithPassword = await showDialog<UserWithPassword?>(
                context: context,
                builder: (context) {
                  return AddAssistantAccountDialog();
                },
              );
              if (_userWithPassword == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await c.addAssistantAccount(_userWithPassword);
                  },
                );
              }
            },
            tooltip: context.loc.addAssistantAccount,
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.assistantAccounts),
                  ),
                  subtitle: const Divider(),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (a.constants == null || c.users == null) {
                      return CentralLoading();
                    }
                    while (c.users is ApiErrorResult) {
                      final _err = c.users as ApiErrorResult<List<User>>;
                      return CentralError(
                        code: _err.errorCode,
                        toExecute: c.retry,
                      );
                    }

                    final items = (c.users as ApiDataResult<List<User>>).data;

                    while (items.isEmpty) {
                      return CentralNoItems(
                        message: context.loc.noItemsFound,
                      );
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card.outlined(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ExpansionTile(
                                title: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: FloatingActionButton.small(
                                        heroTag: UniqueKey(),
                                        onPressed: null,
                                        child: Text('${index + 1}'),
                                      ),
                                    ),
                                    Text(item.email),
                                  ],
                                ),
                                subtitle: const Divider(
                                  color: Colors.grey,
                                ),
                                children: [
                                  ...a.constants!.appPermission.map((perm) {
                                    return CheckboxListTile(
                                      title: Text(
                                        l.isEnglish
                                            ? perm.name_en
                                            : perm.name_ar,
                                      ),
                                      subtitle: const Divider(
                                        color: Colors.grey,
                                      ),
                                      value:
                                          item.app_permissions.contains(perm),
                                      onChanged: (val) async {
                                        if (perm.id == a.admin.id ||
                                            perm.id == a.user.id) {
                                          showIsnackbar(context
                                              .loc.cannotChangeAccountType);
                                          return;
                                        } else {
                                          if (item.app_permissions
                                              .contains(perm)) {
                                            await shellFunction(
                                              context,
                                              toExecute: () async {
                                                await c.removeAccountPermission(
                                                  item.id,
                                                  perm.id,
                                                );
                                              },
                                            );
                                          } else {
                                            await shellFunction(
                                              context,
                                              toExecute: () async {
                                                await c.addAccountPermission(
                                                  item.id,
                                                  perm.id,
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
