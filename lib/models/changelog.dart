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
}

final List<Changelog> CHANGELOG = [
  Changelog.v003(),
  Changelog.v002(),
  Changelog.v001(),
];
