// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:allevia_one/extensions/number_translator.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:allevia_one/providers/px_app_constants.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class VisitProgressionCard extends StatefulWidget {
  const VisitProgressionCard({
    super.key,
    required this.item,
  });
  final Visit item;

  @override
  State<VisitProgressionCard> createState() => _VisitProgressionCardState();
}

class _VisitProgressionCardState extends State<VisitProgressionCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxAppConstants, PxLocale>(
      builder: (context, a, l, _) {
        while (a.constants == null) {
          return LinearProgressIndicator();
        }
        Color _buildColor() {
          final _progressId = widget.item.patient_progress_status.id;
          if (_progressId == a.has_not_attended_yet.id) {
            return Colors.red.shade200;
          }
          if (_progressId == a.in_waiting.id) {
            return Colors.amber.shade200;
          }
          if (_progressId == a.in_consultation.id) {
            return Colors.green.shade200;
          }
          if (_progressId == a.done_consultation.id) {
            return Colors.blue.shade200;
          }
          return Colors.white;
        }

        return Card.outlined(
          elevation: 6,
          color: _buildColor(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Row(
                spacing: 16,
                children: [
                  FloatingActionButton.small(
                    heroTag: UniqueKey(),
                    onPressed: null,
                    child: Text('${widget.item.patient_entry_number}'
                        .toArabicNumber(context)),
                  ),
                  Text(widget.item.patient.name),
                  Text(
                    '(${l.isEnglish ? widget.item.visit_type.name_en : widget.item.visit_type.name_ar})',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
