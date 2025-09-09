import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/widgets/not_permitted_dialog.dart';
import 'package:allevia_one/widgets/not_permitted_template_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/extensions/number_translator.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/supplies/supply_movement.dart';
import 'package:allevia_one/models/supplies/supply_movement_dto.dart';
import 'package:allevia_one/models/supplies/supply_movement_type.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/supply_movements_page/widgets/add_supply_movement_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/supply_movements_page/widgets/print_supply_movements_dialog.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_supply_movements.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:allevia_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class SupplyMovementsPage extends StatefulWidget {
  const SupplyMovementsPage({super.key});

  @override
  State<SupplyMovementsPage> createState() => _SupplyMovementsPageState();
}

class _SupplyMovementsPageState extends State<SupplyMovementsPage> {
  late final TextEditingController _fromController;
  late final TextEditingController _toController;
  late final l = context.read<PxLocale>();
  late final ScrollController _verticalScroll;
  late final ScrollController _horizontalScroll;

  @override
  void initState() {
    super.initState();
    final _s = context.read<PxSupplyMovements>();
    _fromController = TextEditingController(
        text: DateFormat('dd - MM - yyyy', l.lang).format(_s.from));
    _toController = TextEditingController(
        text: DateFormat('dd - MM - yyyy', l.lang).format(_s.to));
    _verticalScroll = ScrollController();
    _horizontalScroll = ScrollController();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _verticalScroll.dispose();
    _horizontalScroll.dispose();
    super.dispose();
  }

  Widget _buildDataTable(List<SupplyMovement> _items) {
    return Scrollbar(
      thumbVisibility: true,
      controller: _verticalScroll,
      child: SingleChildScrollView(
        controller: _verticalScroll,
        restorationId: 'data-table-vertical',
        scrollDirection: Axis.vertical,
        child: Row(
          children: [
            Expanded(
              child: Scrollbar(
                controller: _horizontalScroll,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalScroll,
                  restorationId: 'data-table-horizontal',
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
                        label: Text(
                          context.loc.number,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          context.loc.movementDate,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          context.loc.supplyItem,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          context.loc.clinic,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          context.loc.movementDirection,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          context.loc.movementReason,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          context.loc.movementQuantity,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          context.loc.movementAmount,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          context.loc.relatedVisitId,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          context.loc.autoAdd,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          context.loc.addedBy,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    rows: [
                      ..._items.map<DataRow>((x) {
                        final _supplyItemMovementType =
                            SupplyMovementType.fromString(x.movement_type);
                        final _index = _items.indexOf(x);
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                '${_index + 1}'.toArabicNumber(context),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                DateFormat('dd - MM - yyyy', l.lang)
                                    .format(x.created),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                l.isEnglish
                                    ? x.supply_item.name_en
                                    : x.supply_item.name_ar,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                l.isEnglish
                                    ? x.clinic.name_en
                                    : x.clinic.name_ar,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Tooltip(
                                  message: l.isEnglish
                                      ? _supplyItemMovementType.en
                                      : _supplyItemMovementType.ar,
                                  child: Icon(
                                    switch (_supplyItemMovementType) {
                                      SupplyMovementType.OUT_IN =>
                                        Icons.arrow_downward,
                                      SupplyMovementType.IN_OUT =>
                                        Icons.arrow_upward,
                                      SupplyMovementType.IN_IN =>
                                        Icons.compare_arrows_rounded,
                                    },
                                    color: switch (_supplyItemMovementType) {
                                      SupplyMovementType.OUT_IN => Colors.red,
                                      SupplyMovementType.IN_OUT => Colors.green,
                                      SupplyMovementType.IN_IN => Colors.blue,
                                    },
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                x.reason,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                '${x.movement_quantity} ${l.isEnglish ? x.supply_item.unit_en : x.supply_item.unit_ar}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                '${x.movement_amount} ${context.loc.egp}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text.rich(
                                TextSpan(
                                  text: (x.visit_id == null ||
                                          x.visit_id!.isEmpty)
                                      ? '----'
                                      : x.visit_id!,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      //TODO: navigate to visit
                                    },
                                ),
                                style: TextStyle(
                                  decoration: (x.visit_id == null ||
                                          x.visit_id!.isEmpty)
                                      ? TextDecoration.none
                                      : TextDecoration.underline,
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: switch (x.auto_add) {
                                  true => const Icon(Icons.check,
                                      color: Colors.green),
                                  false =>
                                    const Icon(Icons.close, color: Colors.red),
                                },
                              ),
                            ),
                            DataCell(
                              Text(
                                x.added_by.email,
                                textAlign: TextAlign.center,
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
  }

  @override
  Widget build(BuildContext context) {
    //todo: Change to table layout
    return Consumer2<PxSupplyMovements, PxLocale>(
      builder: (context, s, l, _) {
        //@permission
        final _perm = context.read<PxAuth>().isActionPermitted(
              PermissionEnum.User_SupplyMovements_Read,
              context,
            );
        while (!_perm.isAllowed) {
          return NotPermittedTemplatePage(
              title: context.loc.supplyItemsMovement);
        }
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(context.loc.supplyItemsMovement),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Builder(
                            builder: (context) {
                              while (s.result == null) {
                                return CupertinoActivityIndicator();
                              }
                              final _items = (s.result
                                      as ApiDataResult<List<SupplyMovement>>)
                                  .data;
                              return FloatingActionButton.small(
                                heroTag: UniqueKey(),
                                onPressed: () async {
                                  if (context.mounted) {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return PrintSupplyMovementsDialog(
                                          movements: _items,
                                          fromDate: s.from,
                                          toDate: s.to,
                                        );
                                      },
                                    );
                                  }
                                },
                                child: const Icon(Icons.print),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: const Divider(),
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Text(context.loc.from),
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: _fromController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        FloatingActionButton.small(
                          heroTag: UniqueKey(),
                          tooltip: context.loc.pickStartingDate,
                          onPressed: () async {
                            final _from = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now().copyWith(
                                year: DateTime.now().year - 5,
                              ),
                              lastDate: DateTime.now(),
                            );
                            if (_from != null) {
                              _fromController.text =
                                  DateFormat('dd - MM - yyyy', l.lang)
                                      .format(_from);
                              if (context.mounted) {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await s.changeDate(
                                      from: _from,
                                      to: s.to,
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: const Icon(Icons.calendar_month_rounded),
                        ),
                        Text(context.loc.to),
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            controller: _toController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        FloatingActionButton.small(
                          tooltip: context.loc.pickEndingDate,
                          heroTag: UniqueKey(),
                          onPressed: () async {
                            final _to = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now().copyWith(
                                year: DateTime.now().year - 5,
                              ),
                              lastDate: DateTime.now(),
                            );
                            if (_to != null) {
                              _toController.text =
                                  DateFormat('dd - MM - yyyy', l.lang)
                                      .format(_to);
                              if (context.mounted) {
                                await shellFunction(
                                  context,
                                  toExecute: () async {
                                    await s.changeDate(
                                      from: s.from,
                                      to: _to,
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: const Icon(Icons.calendar_month_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (s.result == null) {
                      return const CentralLoading();
                    }

                    while (s.result is ApiErrorResult) {
                      return CentralError(
                        code: (s.result as ApiErrorResult).errorCode,
                        toExecute: s.retry,
                      );
                    }

                    while (s.result != null &&
                        (s.result is ApiDataResult) &&
                        (s.result as ApiDataResult<List<SupplyMovement>>)
                            .data
                            .isEmpty) {
                      return CentralNoItems(
                        message: context.loc.noSupplyMovementsFound,
                      );
                    }
                    final _items =
                        (s.result as ApiDataResult<List<SupplyMovement>>).data;

                    return _buildDataTable(_items);
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.small(
            heroTag: UniqueKey(),
            tooltip: context.loc.newSupplyMovement,
            onPressed: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                    PermissionEnum.User_SupplyMovement_Add,
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
              final _dtos = await showDialog<List<SupplyMovementDto?>?>(
                context: context,
                builder: (context) {
                  return AddSupplyMovementDialog();
                },
              );
              if (_dtos == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await s.addSupplyMovements(_dtos);
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
