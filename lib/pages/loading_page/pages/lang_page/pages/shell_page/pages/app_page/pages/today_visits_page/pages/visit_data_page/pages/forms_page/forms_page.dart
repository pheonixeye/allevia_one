import 'package:flutter/material.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/pc_form.dart';
import 'package:allevia_one/models/visit_data/visit_data.dart';
import 'package:allevia_one/models/visit_data/visit_form_item.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/forms_page/form_picker_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/pages/forms_page/form_view_edit_card.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_details_page_info_header.dart';
import 'package:allevia_one/providers/px_forms.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_visit_data.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:allevia_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class VisitFormsPage extends StatelessWidget {
  const VisitFormsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxVisitData, PxForms, PxLocale>(
      builder: (context, v, f, l, _) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              while (f.result == null || v.result == null) {
                return const CentralLoading();
              }

              while (v.result is ApiErrorResult) {
                return CentralError(
                  code: (f.result as ApiErrorResult).errorCode,
                  toExecute: f.retry,
                );
              }
              while (
                  (v.result as ApiDataResult<VisitData>).data.forms.isEmpty) {
                return Column(
                  children: [
                    VisitDetailsPageInfoHeader(
                      patient:
                          (v.result as ApiDataResult<VisitData>).data.patient,
                      title: context.loc.visitForms,
                      iconData: Icons.edit_document,
                    ),
                    Expanded(
                      child: CentralNoItems(
                        message: context.loc.noItemsFound,
                      ),
                    ),
                  ],
                );
              }
              final _items = (v.result as ApiDataResult<VisitData>).data.forms;
              return Column(
                children: [
                  VisitDetailsPageInfoHeader(
                    patient:
                        (v.result as ApiDataResult<VisitData>).data.patient,
                    title: context.loc.visitForms,
                    iconData: Icons.edit_document,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final _item = _items[index];
                        return VisitFormViewEditCard(
                          form: _item,
                          index: index,
                          form_data: (v.result as ApiDataResult<VisitData>)
                              .data
                              .forms_data
                              .firstWhere((x) => x.form_id == _item.id),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton.small(
            heroTag: 'add-form-to-visit',
            tooltip: context.loc.addNewForm,
            onPressed: () async {
              final _form = await showDialog<PcForm?>(
                context: context,
                builder: (context) {
                  return const FormPickerDialog();
                },
              );
              if (_form == null) {
                return;
              }
              final _visit_form_data = VisitFormItem(
                id: '',
                visit_id: (v.result as ApiDataResult<VisitData>).data.visit_id,
                patient_id:
                    (v.result as ApiDataResult<VisitData>).data.patient.id,
                form_id: _form.id,
                form_data: _form.form_fields
                    .map((x) => SingleFieldData(
                          id: x.id,
                          field_name: x.field_name,
                          field_value: '',
                        ))
                    .toList(),
              );
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await v.attachForm(_visit_form_data);
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
