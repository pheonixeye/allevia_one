import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/extensions/number_translator.dart';
import 'package:allevia_one/models/bookkeeping/bookkeeping_item_dto.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_one_visit_bookkeeping.dart';
import 'package:allevia_one/widgets/central_error.dart';
import 'package:allevia_one/widgets/central_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecieptPrepareDialog extends StatefulWidget {
  const RecieptPrepareDialog({
    super.key,
    required this.visit,
  });
  final Visit visit;

  @override
  State<RecieptPrepareDialog> createState() => _RecieptPrepareDialogState();
}

class _RecieptPrepareDialogState extends State<RecieptPrepareDialog> {
  final List<String> _state = [];

  @override
  Widget build(BuildContext context) {
    return Consumer2<PxOneVisitBookkeeping, PxLocale>(
      builder: (context, b, l, _) {
        while (b.result == null) {
          return const CentralLoading();
        }
        while (b.result is ApiErrorResult) {
          return CentralError(
            code: (b.result as ApiErrorResult).errorCode,
            toExecute: b.retry,
          );
        }
        final _data =
            (b.result as ApiDataResult<List<BookkeepingItemDto>>).data;
        return AlertDialog(
          title: Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: context.loc.printReciept,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: '(${widget.visit.patient.name})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton.outlined(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(8),
          insetPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final _item = _data[index];
                return Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CheckboxListTile(
                      secondary: FloatingActionButton.small(
                        onPressed: null,
                        heroTag: UniqueKey(),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_item.item_name),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "${_item.amount.toString().toArabicNumber(context)} ${context.loc.egp}"),
                      ),
                      value: _state.contains(_item.id),
                      onChanged: (val) {
                        setState(() {
                          if (_state.contains(_item.id)) {
                            _state.remove(_item.id);
                          } else {
                            _state.add(_item.id);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.all(8),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, true);
              },
              label: Text(context.loc.printReciept),
              icon: Icon(
                Icons.print_rounded,
                color: Colors.green.shade100,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, null);
              },
              label: Text(context.loc.cancel),
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
