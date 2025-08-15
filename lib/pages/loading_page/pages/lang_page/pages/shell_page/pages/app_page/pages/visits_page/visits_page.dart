import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/widgets/not_permitted_template_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/visit_data_api.dart';
import 'package:allevia_one/extensions/clinic_schedule_shift_ext.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/extensions/number_translator.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/visit_data_view_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/visits_filter_header.dart';
import 'package:allevia_one/providers/px_app_constants.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_visit_data.dart';
import 'package:allevia_one/providers/px_visit_filter.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:allevia_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class VisitsPage extends StatelessWidget {
  const VisitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<PxVisitFilter, PxAppConstants, PxLocale>(
      builder: (context, v, a, l, _) {
        while (v.visits == null || a.constants == null) {
          return CentralLoading();
        }
        //@permission
        final _perm = context.read<PxAuth>().isActionPermitted(
              PermissionEnum.User_Visits_Read,
              context,
            );
        while (!_perm.isAllowed) {
          return NotPermittedTemplatePage(title: context.loc.visits);
        }
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VisitsFilterHeader(),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (v.visits == null || a.constants == null) {
                      return CentralLoading();
                    }
                    while (v.visits is ApiErrorResult) {
                      return CentralError(
                        code: (v.visits as ApiErrorResult).errorCode,
                        toExecute: v.retry,
                      );
                    }
                    final _items =
                        (v.visits as ApiDataResult<List<Visit>>).data;
                    while (_items.isEmpty) {
                      return CentralNoItems(
                        message: context.loc.noVisitsFoundForSelectedDateRange,
                      );
                    }
                    return SingleChildScrollView(
                      restorationId: 'v-vertical',
                      scrollDirection: Axis.vertical,
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              restorationId: 'v-horizontal',
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                border: TableBorder.all(),
                                dividerThickness: 2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                headingRowColor: WidgetStatePropertyAll(
                                  Colors.amber.shade50,
                                ),
                                columns: [
                                  DataColumn(
                                    label: Text(context.loc.number),
                                  ),
                                  DataColumn(
                                    label: Text(context.loc.patientName),
                                  ),
                                  DataColumn(
                                    label: Text(context.loc.doctor),
                                  ),
                                  DataColumn(
                                    label: Text(context.loc.attendanceStatus),
                                  ),
                                  DataColumn(
                                    label: Text(context.loc.visitDate),
                                  ),
                                  DataColumn(
                                    label: Text(context.loc.visitType),
                                  ),
                                  DataColumn(
                                    label: Text(context.loc.clinic),
                                  ),
                                  DataColumn(
                                    label: Text(context.loc.clinicShift),
                                  ),
                                  DataColumn(
                                    label: Text(context.loc.addedBy),
                                  ),
                                ],
                                rows: [
                                  ..._items.map((x) {
                                    final index = _items.indexOf(x);
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Center(
                                            child: Text('${index + 1}'
                                                .toArabicNumber(context)),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: InkWell(
                                              hoverColor: Colors.amber.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              onTap: () async {
                                                //todo: Go to visit Data View Dialog
                                                await showDialog<void>(
                                                  context: context,
                                                  builder: (context) {
                                                    return ChangeNotifierProvider(
                                                      create: (context) =>
                                                          PxVisitData(
                                                        api: VisitDataApi(
                                                          visit_id: x.id,
                                                        ),
                                                      ),
                                                      child:
                                                          VisitDataViewDialog(),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(x.patient.name),
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              l.isEnglish
                                                  ? x.doctor.name_en
                                                  : x.doctor.name_ar,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Builder(
                                            builder: (context) {
                                              final _isAttended =
                                                  x.visit_status == a.attended;
                                              return Center(
                                                child: Icon(
                                                  _isAttended
                                                      ? Icons.check
                                                      : Icons.close,
                                                  color: _isAttended
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              DateFormat(
                                                      'dd - MM - yyyy', l.lang)
                                                  .format(x.visit_date),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              l.isEnglish
                                                  ? x.visit_type.name_en
                                                  : x.visit_type.name_ar,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              l.isEnglish
                                                  ? x.clinic.name_en
                                                  : x.clinic.name_ar,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              x.clinic_schedule_shift
                                                  .formattedFromTo(context),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              x.added_by.email,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  })
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
