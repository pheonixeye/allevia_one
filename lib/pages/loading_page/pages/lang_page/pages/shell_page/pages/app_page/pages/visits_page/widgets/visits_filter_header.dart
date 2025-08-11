import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/extensions/number_translator.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/providers/px_visit_filter.dart';
import 'package:provider/provider.dart';

class VisitsFilterHeader extends StatefulWidget {
  const VisitsFilterHeader({super.key});

  @override
  State<VisitsFilterHeader> createState() => _VisitsFilterHeaderState();
}

class _VisitsFilterHeaderState extends State<VisitsFilterHeader> {
  late final TextEditingController _fromController;
  late final TextEditingController _toController;

  @override
  void initState() {
    super.initState();
    final _s = context.read<PxVisitFilter>();
    final _l = context.read<PxLocale>();
    _fromController = TextEditingController(
        text: DateFormat('dd - MM - yyyy', _l.lang).format(_s.from));
    _toController = TextEditingController(
        text: DateFormat('dd - MM - yyyy', _l.lang).format(_s.to));
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer2<PxVisitFilter, PxLocale>(
        builder: (context, v, l, _) {
          return ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(context.loc.visits),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Text(context.loc.from),
                        Text(' : '),
                        Text(
                          DateFormat('dd - MM - yyyy', l.lang).format(v.from),
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        Text('  '),
                        Text(context.loc.to),
                        Text(' : '),
                        Text(
                          DateFormat('dd - MM - yyyy', l.lang).format(v.to),
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Builder(
                    builder: (context) {
                      while (v.visits == null) {
                        return CupertinoActivityIndicator();
                      }
                      final _length =
                          (v.visits as ApiDataResult<List<Visit>>).data.length;
                      return Text('($_length)'.toArabicNumber(context));
                    },
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
                            DateFormat('dd - MM - yyyy', l.lang).format(_from);
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await v.changeDate(
                                from: _from,
                                to: v.to,
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
                            DateFormat('dd - MM - yyyy', l.lang).format(_to);
                        if (context.mounted) {
                          await shellFunction(
                            context,
                            toExecute: () async {
                              await v.changeDate(
                                from: v.from,
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
          );
        },
      ),
    );
  }
}
