import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/providers/px_app_constants.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/widgets/not_permitted_dialog.dart';
import 'package:allevia_one/widgets/not_permitted_template_page.dart';
import 'package:flutter/material.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/api_result_mapper.dart';
import 'package:allevia_one/models/pc_form.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/forms_page/widgets/create_edit_form_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/forms_page/widgets/form_view_edit_card.dart';
import 'package:allevia_one/providers/px_forms.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:provider/provider.dart';

class FormsPage extends StatelessWidget {
  const FormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxAppConstants, PxForms>(
      builder: (context, a, f, _) {
        while (a.constants == null || f.result == null) {
          return const CentralLoading();
        }
        //@permission
        final _perm = context.read<PxAuth>().isActionPermitted(
              PermissionEnum.User_Forms_Read,
              context,
            );
        while (!_perm.isAllowed) {
          return NotPermittedTemplatePage(title: context.loc.forms);
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'add-new-form',
            onPressed: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                    PermissionEnum.User_Forms_Add,
                    context,
                  );
              if (!_perm.isAllowed) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return NotPermittedDialog(
                      permission: _perm.permission,
                    );
                  },
                );
                return;
              }
              //todo: add new form Dialog
              final _form = await showDialog<PcForm?>(
                context: context,
                builder: (context) {
                  return const CreateEditFormDialog();
                },
              );
              if (_form == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    //todo:
                    await f.createPcForm(_form);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(context.loc.forms),
                  ),
                  subtitle: const Divider(),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (f.result == null) {
                      return const CentralLoading();
                    }

                    while (f.result is ApiErrorResult) {
                      return CentralError(
                        code: (f.result as ApiErrorResult).errorCode,
                        toExecute: f.retry,
                      );
                    }
                    while (f.result != null &&
                        (f.result as FormDataResult).data.isEmpty) {
                      return Center(
                        child: Card.outlined(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(context.loc.noFormsFound),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: (f.result! as FormDataResult).data.length,
                      itemBuilder: (context, index) {
                        final item = (f.result! as FormDataResult).data[index];
                        return FormViewEditCard(
                          pcForm: item,
                          index: index,
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
