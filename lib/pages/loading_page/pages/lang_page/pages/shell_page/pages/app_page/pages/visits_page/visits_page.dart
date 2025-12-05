import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/logic/excel_file_prep.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/visit_data_table_rows_columns.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/providers/px_clinics.dart';
import 'package:allevia_one/providers/px_doctor.dart';
import 'package:allevia_one/widgets/not_permitted_dialog.dart';
import 'package:allevia_one/widgets/not_permitted_template_page.dart';
import 'package:flutter/material.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/visits_page/widgets/visits_filter_header.dart';
import 'package:allevia_one/providers/px_app_constants.dart';
import 'package:allevia_one/providers/px_locale.dart';
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
    return Consumer5<PxAppConstants, PxDoctor, PxClinics, PxVisitFilter,
        PxLocale>(
      builder: (context, a, d, c, v, l, _) {
        while (a.constants == null ||
            d.allDoctors == null ||
            c.result == null ||
            v.concisedVisits == null) {
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
              //todo: add filter by doctor, clinic
              VisitsFilterHeader(),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (v.concisedVisits == null || a.constants == null) {
                      return CentralLoading();
                    }
                    while (v.concisedVisits is ApiErrorResult) {
                      return CentralError(
                        code: (v.concisedVisits as ApiErrorResult).errorCode,
                        toExecute: v.retry,
                      );
                    }
                    final _items = v.filteredConcisedVisits;
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
                                    columns: buildDataColumns(context),
                                    rows: [
                                      ..._items.map((x) {
                                        final index = _items.indexOf(x);
                                        return buildVisitDataRow(
                                          context,
                                          x: x,
                                          index: index,
                                          l: l,
                                          a: a,
                                          c: c,
                                          d: d,
                                        );
                                      }),
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
              final _visits = v.filteredConcisedVisits;
              final _excel = ExcelFilePrep(
                visits: _visits,
                from: v.from,
                to: v.to,
              );
              await shellFunction(
                context,
                toExecute: () async {
                  await _excel.save(
                    constants: a.constants!,
                    doctors: d.allDoctors!,
                  );
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
