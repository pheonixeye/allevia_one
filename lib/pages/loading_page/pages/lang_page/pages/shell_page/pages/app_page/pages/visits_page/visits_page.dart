import 'package:allevia_one/core/api/bookkeeping_api.dart';
import 'package:allevia_one/extensions/visit_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/logic/excel_file_prep.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/reciept_prepare_dialog.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/providers/px_one_visit_bookkeeping.dart';
import 'package:allevia_one/widgets/not_permitted_dialog.dart';
import 'package:allevia_one/widgets/not_permitted_template_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/visit_data_api.dart';
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

class VisitsPage extends StatefulWidget {
  const VisitsPage({super.key});

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  late final ScrollController _verticalScroll;
  late final ScrollController _horizontalScroll;

  @override
  void initState() {
    super.initState();
    _verticalScroll = ScrollController();
    _horizontalScroll = ScrollController();
  }

  @override
  void dispose() {
    _verticalScroll.dispose();
    _horizontalScroll.dispose();
    super.dispose();
  }

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
                    return Scrollbar(
                      controller: _verticalScroll,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _verticalScroll,
                        restorationId: 'v-vertical',
                        scrollDirection: Axis.vertical,
                        child: Row(
                          children: [
                            Expanded(
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: _horizontalScroll,
                                child: SingleChildScrollView(
                                  controller: _horizontalScroll,
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
                                        label:
                                            Text(context.loc.attendanceStatus),
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
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      hoverColor:
                                                          Colors.amber.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      onTap: () async {
                                                        //todo: Go to visit Data View Dialog
                                                        await showDialog<void>(
                                                          context: context,
                                                          builder: (context) {
                                                            return ChangeNotifierProvider(
                                                              create: (context) =>
                                                                  PxVisitData(
                                                                api:
                                                                    VisitDataApi(
                                                                  visit_id:
                                                                      x.id,
                                                                ),
                                                              ),
                                                              child:
                                                                  VisitDataViewDialog(
                                                                visit: x,
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            x.patient.name),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    FloatingActionButton.small(
                                                      tooltip: context
                                                          .loc.printReciept,
                                                      key: UniqueKey(),
                                                      onPressed: () async {
                                                        //@permission
                                                        final _perm = context
                                                            .read<PxAuth>()
                                                            .isActionPermitted(
                                                              PermissionEnum
                                                                  .User_Visits_PrintReciept,
                                                              context,
                                                            );
                                                        if (!_perm.isAllowed) {
                                                          await showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return NotPermittedDialog(
                                                                permission: _perm
                                                                    .permission,
                                                              );
                                                            },
                                                          );
                                                          return;
                                                        }

                                                        await showDialog<void>(
                                                          context: context,
                                                          builder: (context) {
                                                            return ChangeNotifierProvider
                                                                .value(
                                                              value:
                                                                  PxOneVisitBookkeeping(
                                                                api:
                                                                    BookkeepingApi(
                                                                  visit_id:
                                                                      x.id,
                                                                ),
                                                              ),
                                                              child:
                                                                  RecieptPrepareDialog(
                                                                visit: x,
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: const Icon(
                                                        Icons.receipt_long,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                  ],
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
                                                      x.visit_status ==
                                                          a.attended;
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
                                                  DateFormat('dd - MM - yyyy',
                                                          l.lang)
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
                                                  x.formattedShift(context),
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.small(
            heroTag: UniqueKey(),
            tooltip: context.loc.exportToExcel,
            onPressed: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                    PermissionEnum.User_Visits_PrintReciept,
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
              final _visits = (v.visits as ApiDataResult<List<Visit>>).data;
              final _excel = ExcelFilePrep(_visits);
              await shellFunction(
                context,
                toExecute: () async {
                  await _excel.save();
                },
              );
            },
            child: const Icon(Icons.file_open),
          ),
        );
      },
    );
  }
}
