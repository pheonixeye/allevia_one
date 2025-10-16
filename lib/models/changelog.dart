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

  factory Changelog.v0045() {
    return Changelog(
      version: '0.0.4+5',
      entries: [
        ChangelogEntry(
          ar: 'اصلاح خطا برمجي يمنع اضافة النموذج المرسوم',
          en: 'Hotfix: Patient Documents Not Being Added Correctly',
        ),
      ],
    );
  }
  factory Changelog.v005() {
    return Changelog(
      version: '0.0.5',
      entries: [
        ChangelogEntry(
          ar: 'تمت إضافة مؤشر يشير إلى أن جدول العيادة مشغول أثناء إضافة زيارة جديدة.',
          en: 'Added Indicator That a Clinic Schedule Is Occupied While Adding a New Visit.',
        ),
        ChangelogEntry(
          ar: 'تمت إضافة تكامل خادم WhatsApp، يمكنك الآن إرسال بطاقة هوية المريض عبر WhatsApp مباشرة.',
          en: 'Added Whatsapp Server Integration, You Can Now Send The Patient Id Card Via Whatsapp Directly.',
        ),
      ],
    );
  }
  factory Changelog.v006() {
    return Changelog(
      version: '0.0.6',
      entries: [
        ChangelogEntry(
          ar: 'تمت إضافة القدرة على تغيير موعد الزيارة في زيارات اليوم.',
          en: 'Added The Ability To Change Visit Schedule In Today Visits.',
        ),
        ChangelogEntry(
          ar: 'يمكنك الآن إضافة الخصومات مباشرة إلى الزيارة في صفحة زيارات اليوم.',
          en: 'You Can Now Add Disounts Direclty To A Visit In Today Visits Page.',
        ),
        ChangelogEntry(
          ar: 'تمت إضافة حالة تقدم الزيارة الجديدة بناءً على طلب الدكتور أحمد => "ملغاة".',
          en: 'A New Visit Progress Status Is Added As Requsted By Doctor Ahmed => "Canceled".',
        ),
      ],
    );
  }
}

final List<Changelog> CHANGELOG = [
  Changelog.v005(),
  Changelog.v0045(),
  Changelog.v0044(),
  Changelog.v004(),
  Changelog.v003(),
  Changelog.v002(),
  Changelog.v001(),
];
