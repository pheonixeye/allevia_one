import 'package:allevia_one/extensions/number_translator.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:allevia_one/providers/px_app_constants.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PreviousVisitViewCard extends StatelessWidget {
  const PreviousVisitViewCard({
    super.key,
    required this.item,
    required this.index,
    this.showIndexNumber = true,
  });
  final Visit item;
  final int index;
  final bool showIndexNumber;
  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Column(
                spacing: 8,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      FloatingActionButton.small(
                        onPressed: null,
                        heroTag: UniqueKey(),
                        child: showIndexNumber
                            ? Text('${index + 1}'.toArabicNumber(context))
                            : SizedBox(),
                      ),
                      Text(
                        DateFormat('dd - MM - yyyy', l.lang)
                            .format(item.visit_date),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 50.0),
                    child: Row(
                      spacing: 8,
                      children: [
                        Text(
                          l.isEnglish ? 'Doctor:' : 'دكتور:',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          l.isEnglish
                              ? item.doctor.name_en
                              : item.doctor.name_ar,
                        ),
                        Text(
                          l.isEnglish ? 'CLinic:' : 'عيادة:',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          l.isEnglish
                              ? item.clinic.name_en
                              : item.clinic.name_ar,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsetsDirectional.only(start: 50.0),
                child: Row(
                  spacing: 8,
                  children: [
                    Text(
                      l.isEnglish ? 'Visit:' : 'نوع الزيارة:',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Text(
                      l.isEnglish
                          ? item.visit_type.name_en
                          : item.visit_type.name_ar,
                    ),
                    Text(
                      l.isEnglish ? 'Attendance:' : 'الحضور:',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    if (item.visit_status.id ==
                        context.read<PxAppConstants>().attended.id)
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    else
                      const Icon(
                        Icons.close,
                        color: Colors.red,
                      )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
