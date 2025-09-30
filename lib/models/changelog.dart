// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ChangelogEntry extends Equatable {
  final String ar;
  final String en;

  const ChangelogEntry({
    required this.ar,
    required this.en,
  });

  @override
  List<Object> get props => [
        ar,
        en,
      ];
}

class Changelog extends Equatable {
  final String version;
  final List<ChangelogEntry> entries;

  const Changelog({
    required this.version,
    required this.entries,
  });

  @override
  List<Object> get props => [
        version,
        entries,
      ];

  factory Changelog.v001() {
    return Changelog(
      version: '0.0.1',
      entries: [
        ChangelogEntry(
          ar: 'الاصدار الاول',
          en: 'Initial Release',
        ),
      ],
    );
  }
  factory Changelog.v002() {
    return Changelog(
      version: '0.0.2',
      entries: [
        ChangelogEntry(
          ar: 'اكتمال تنفيذ مستندات المريض.',
          en: 'Patient Documents Implementation Complete.',
        ),
        ChangelogEntry(
          ar: 'تمت إضافة زر التحديث في صفحة الزيارات اليومية.',
          en: 'Added Refresh Button In Today Visits Page.',
        ),
      ],
    );
  }

  factory Changelog.v003() {
    return Changelog(
      version: '0.0.3',
      entries: [
        ChangelogEntry(
          ar: 'تمت إضافة تقويم لمراجعة الزيارات الشهرية.',
          en: 'Added Calender For Monthly Visits Review.',
        ),
        ChangelogEntry(
          ar: 'تمت إضافة طباعة الإيصالات للزيارات.',
          en: 'Added Reciept Printing For Visits.',
        ),
      ],
    );
  }
  factory Changelog.v004() {
    return Changelog(
      version: '0.0.4',
      entries: [
        ChangelogEntry(
          ar: 'تمت إضافة ورقة الرسم إلى صفحة النماذج في زيارات اليوم، يمكنك الآن استخدام أي صورة / صور افتراضية كخلفية للرسم / التعيين فوقها وحفظ هذه الصورة كجزء من مستندات المريض.',
          en: 'Added Drawing Sheet To Forms Page In Today Visits, You Can Now Use Any Image / Default Images As A Background For Drawing / Mapping Over It And Save This Image As A part Of The Patient Documents.',
        ),
      ],
    );
  }
  factory Changelog.v0044() {
    return Changelog(
      version: '0.0.4+4',
      entries: [
        ChangelogEntry(
          ar: 'اصلاح خطا برمجي يمنع الزيارت من الفتح بعد تغيير مواعيد العيادات',
          en: 'Hotfix: Visits Not Opening',
        ),
        ChangelogEntry(
          ar: 'تم اضافة امكانية طباعة ملف اكسيل بالزيارات مع حساب ايرادات الزيارات',
          en: 'Added Printing An Excel File With Visits & Calculate Visits Income.',
        ),
      ],
    );
  }
}

final List<Changelog> CHANGELOG = [
  Changelog.v004(),
  Changelog.v003(),
  Changelog.v002(),
  Changelog.v001(),
];
