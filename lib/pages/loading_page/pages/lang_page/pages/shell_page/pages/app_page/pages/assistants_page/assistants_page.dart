import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/user/user_with_password.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/assistants_page/widgets/add_assistant_account_dialog.dart';
import 'package:flutter/material.dart';

class AssistantsPage extends StatelessWidget {
  const AssistantsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              toExecute: () async {},
            );
          }
        },
        tooltip: context.loc.addAssistantAccount,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Center(
            child: Text('Assistants Page'),
          )
        ],
      ),
    );
  }
}
