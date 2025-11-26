import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/extensions/number_translator.dart';
import 'package:allevia_one/models/doctor.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:allevia_one/widgets/themed_popupmenu_btn.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

class DoctorAccountCard extends StatelessWidget {
  const DoctorAccountCard({
    super.key,
    required this.doctor,
    required this.index,
  });
  final Doctor doctor;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<PxLocale>(
      builder: (context, l, _) {
        return Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.top,
              leading: FloatingActionButton.small(
                heroTag: doctor,
                onPressed: null,
                child: Text('${index + 1}'.toArabicNumber(context)),
              ),
              title: Row(
                children: [
                  Text(l.isEnglish ? doctor.name_en : doctor.name_ar),
                  Text(' - '),
                  Text(
                    '(${l.isEnglish ? doctor.speciality.name_en : doctor.speciality.name_ar})',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  Text(context.loc.phone),
                  Text(' - '),
                  Text.rich(
                    TextSpan(
                      text: doctor.phone.toArabicNumber(context),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          web.window.open('tel://+2${doctor.phone}', '_blank');
                        },
                    ),
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              trailing: ThemedPopupmenuBtn<void>(
                tooltip: context.loc.settings,
                icon: const Icon(Icons.menu),
                itemBuilder: (context) {
                  return [];
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
