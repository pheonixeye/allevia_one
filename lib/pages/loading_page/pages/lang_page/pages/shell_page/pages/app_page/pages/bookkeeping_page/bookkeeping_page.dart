import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/providers/px_app_constants.dart';
import 'package:allevia_one/providers/px_auth.dart';
import 'package:allevia_one/widgets/not_permitted_dialog.dart';
import 'package:allevia_one/widgets/not_permitted_template_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/extensions/number_translator.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/bookkeeping/bookkeeping_direction.dart';
import 'package:allevia_one/models/bookkeeping/bookkeeping_item.dart';
import 'package:allevia_one/models/bookkeeping/bookkeeping_item_dto.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/bookkeeping_page/widgets/add_bookkeeping_entry_dialog.dart';
import 'package:allevia_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/bookkeeping_page/widgets/bookkeeping_filter_header.dart';
import 'package:allevia_one/providers/px_bookkeeping.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:allevia_one/widgets/central_no_items.dart';
import 'package:provider/provider.dart';

class BookkeepingPage extends StatefulWidget {
  const BookkeepingPage({super.key});

  @override
  State<BookkeepingPage> createState() => _BookkeepingPageState();
}

class _BookkeepingPageState extends State<BookkeepingPage> {
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
    return Consumer3<PxAppConstants, PxBookkeeping, PxLocale>(
      builder: (context, a, b, l, _) {
        while (b.result == null || a.constants == null) {
          return CentralLoading();
        }
        //@permission
        final _perm = context.read<PxAuth>().isActionPermitted(
              PermissionEnum.User_Bookkeeping_Read,
              context,
            );
        while (!_perm.isAllowed) {
          return NotPermittedTemplatePage(title: context.loc.bookkeeping);
        }
        return Scaffold(
          body: Column(
            children: [
              BookkeepingFilterHeader(),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (b.result == null) {
                      return const CentralLoading();
                    }

                    while (b.result is ApiErrorResult) {
                      return CentralError(
                        code: (b.result as ApiErrorResult).errorCode,
                        toExecute: b.retry,
                      );
                    }

                    while (b.result != null &&
                        (b.result is ApiDataResult) &&
                        (b.result as ApiDataResult<List<BookkeepingItem>>)
                            .data
                            .isEmpty) {
                      return CentralNoItems(
                        message:
                            context.loc.noBookkeepingEntriesFoundInSelectedDate,
                      );
                    }
                    final _items =
                        (b.result as ApiDataResult<List<BookkeepingItem>>).data;

                    return Scrollbar(
                      controller: _verticalScroll,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _verticalScroll,
                        restorationId: 'bk-vertical',
                        scrollDirection: Axis.vertical,
                        child: Row(
                          children: [
                            Expanded(
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: _horizontalScroll,
                                child: SingleChildScrollView(
                                  controller: _horizontalScroll,
                                  restorationId: 'bk-horizontal',
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
                                        label: Text(context.loc.date),
                                      ),
                                      DataColumn(
                                        label: Text(context.loc.operation),
                                      ),
                                      DataColumn(
                                        label: Text(context.loc.bkType),
                                      ),
                                      DataColumn(
                                        label: Text(context.loc.amount),
                                      ),
                                      DataColumn(
                                        label: Text(context.loc.autoAdd),
                                      ),
                                      DataColumn(
                                        label: Text(context.loc.addedBy),
                                      ),
                                    ],
                                    rows: [
                                      ..._items.map((x) {
                                        final _index = _items.indexOf(x);
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Text('${_index + 1}'
                                                  .toArabicNumber(context)),
                                            ),
                                            DataCell(
                                              Text(
                                                DateFormat('dd - MM - yyyy',
                                                        l.lang)
                                                    .format(x.created),
                                              ),
                                            ),
                                            DataCell(
                                              InkWell(
                                                onTap: x.auto_add
                                                    ? () async {
                                                        //TODO: allow for finding item details
                                                      }
                                                    : null,
                                                child: Text(x.item_name),
                                              ),
                                            ),
                                            DataCell(
                                              switch (x.type) {
                                                BookkeepingDirection.IN =>
                                                  const Icon(
                                                    Icons.arrow_downward,
                                                    color: Colors.green,
                                                  ),
                                                BookkeepingDirection.OUT =>
                                                  const Icon(
                                                    Icons.arrow_upward,
                                                    color: Colors.red,
                                                  ),
                                                BookkeepingDirection.NONE =>
                                                  const Icon(
                                                    Icons
                                                        .mobiledata_off_rounded,
                                                    color: Colors.blue,
                                                  ),
                                              },
                                            ),
                                            DataCell(
                                              Text(
                                                '${x.amount} ${context.loc.egp}'
                                                    .toArabicNumber(context),
                                              ),
                                            ),
                                            DataCell(
                                              Icon(
                                                x.auto_add
                                                    ? Icons.check
                                                    : Icons.close,
                                                color: x.auto_add
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                            DataCell(
                                              Text(x.added_by.email),
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
            tooltip: context.loc.addBookkeepingEntry,
            heroTag: UniqueKey(),
            onPressed: () async {
              //@permission
              final _perm = context.read<PxAuth>().isActionPermitted(
                    PermissionEnum.User_Bookkeeping_Add,
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
              final _bookkeepingDto = await showDialog<BookkeepingItemDto?>(
                context: context,
                builder: (context) {
                  return AddBookkeepingEntryDialog();
                },
              );
              if (_bookkeepingDto == null) {
                return;
              }
              if (context.mounted) {
                await shellFunction(
                  context,
                  toExecute: () async {
                    await b.addBookkeepingEntry(_bookkeepingDto);
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
