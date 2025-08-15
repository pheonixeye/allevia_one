import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/widgets/not_permitted_dialog.dart';
import 'package:allevia_one/widgets/not_permitted_template_page.dart';
import 'package:flutter/material.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/clinic/clinic.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/clinic_view_card.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/clinics_page/widgets/create_edit_clinic_dialog.dart';
import 'package:allevia_one/providers/px_clinics.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:allevia_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class ClinicsPage extends StatelessWidget {
  const ClinicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxClinics, PxLocale>(
      builder: (context, c, l, _) {
        //@permission
        final _perm = context.read<PxAuth>().isActionPermitted(
              PermissionEnum.User_Clinics_Read,
              context,
            );
        while (!_perm.isAllowed) {
          return NotPermittedTemplatePage(title: context.loc.clinics);
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'create-clinic-btn',
            tooltip: context.loc.addNewClinic,
            onPressed: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                    PermissionEnum.User_Clinics_Add,
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
              final _clinic = await showDialog<Clinic?>(
                context: context,
                builder: (context) {
                  return const CreateEditClinicDialog();
                },
              );
              if (_clinic == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await c.createNewClinic(_clinic);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(context.loc.clinics),
                    ),
                    subtitle: const Divider(),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      while (c.result == null) {
                        return const CentralLoading();
                      }

                      while (c.result is ApiErrorResult) {
                        return CentralError(
                          code: (c.result as ApiErrorResult).errorCode,
                          toExecute: c.retry,
                        );
                      }

                      while (c.result != null &&
                          (c.result is ApiDataResult) &&
                          (c.result as ApiDataResult<List<Clinic>>)
                              .data
                              .isEmpty) {
                        return CentralNoItems(
                          message: context.loc.noClinicsFound,
                        );
                      }
                      final _items =
                          (c.result as ApiDataResult<List<Clinic>>).data;
                      return ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final _clinic = _items[index];
                          return ClinicViewCard(
                            clinic: _clinic,
                            index: index,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
