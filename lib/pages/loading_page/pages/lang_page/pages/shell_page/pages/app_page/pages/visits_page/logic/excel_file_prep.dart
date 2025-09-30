import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/bookkeeping_api.dart';
import 'package:allevia_one/models/bookkeeping/bookkeeping_item_dto.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

class ExcelFilePrep {
  final List<Visit> visits;
  ExcelFilePrep(this.visits) {
    _initSheet();
  }

  final visits_sheet = 'visits';

  static const List<String> _columns = [
    'مسلسل',
    "تاريخ الزيارة",
    "اسم المريض",
    "موبايل",
    "الطبيب المعالج",
    "نوع الزيارة",
    "حالة الزيارة",
    "مسئول التسجيل",
    "اجمالي المدفوع",
  ];

  late final Excel _excel = Excel.createExcel();
  late final Sheet _visitsSheet = _excel[visits_sheet];

  void _initSheet() {
    //delete default sheet
    _excel.delete('Sheet1');
    //set is arabic
    _visitsSheet.isRTL = true;
    _excel.setDefaultSheet(visits_sheet);
    _visitsSheet.setDefaultColumnWidth(15);
    //insert columns
    for (var i = 0; i < _columns.length; i++) {
      _visitsSheet.insertColumn(i);
    }

    //insert header row
    _visitsSheet.appendRow([..._columns.map((e) => TextCellValue(e))]);
  }

  Future<void> _appendVisits() async {
    for (final visit in visits) {
      final _amount = await _fetchAndCalculateVisitBookkeepingEntries(visit.id);
      _visitsSheet.appendRow([
        ..._columns.map((e) {
          final _index = _columns.indexOf(e);
          return switch (_index) {
            0 => TextCellValue('${_index + 1}'),
            1 => TextCellValue(
                DateFormat('dd - MM - yyyy', 'ar').format(visit.visit_date)),
            2 => TextCellValue(visit.patient.name),
            3 => TextCellValue(visit.patient.phone),
            4 => TextCellValue(visit.doctor.name_ar),
            5 => TextCellValue(visit.visit_type.name_ar),
            6 => TextCellValue(visit.visit_status.name_ar),
            7 => TextCellValue(visit.added_by.email),
            8 => TextCellValue(_amount.toString()),
            _ => TextCellValue(''),
          };
        })
      ]);
    }
    _visitsSheet.setColumnWidth(0, 8);
    _visitsSheet.setColumnWidth(2, 30);
    _visitsSheet.setColumnWidth(7, 30);

    for (var i = 0; i < _columns.length; i++) {
      for (var j = 0; j < visits.length + 1; j++) {
        _visitsSheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: j))
            .cellStyle = CellStyle(
          horizontalAlign: HorizontalAlign.Center,
        );
      }
    }
  }

  Future<List<int>?> save() async {
    await _appendVisits();
    return _excel.save(
      fileName:
          '${DateFormat('dd_MM_yyyy__hh__mm', 'en').format(DateTime.now())}.xlsx',
    );
  }

  Future<double> _fetchAndCalculateVisitBookkeepingEntries(
    String visit_id,
  ) async {
    final _api = BookkeepingApi(visit_id: visit_id);
    final _result = await _api.fetchBookkeepingOfOneVisit();
    if (_result is ApiDataResult<List<BookkeepingItemDto>>) {
      final _data = _result.data
          .map((e) => e.amount)
          .toList()
          .fold<double>(0, (a, b) => a + b);
      return _data;
    }
    return 0;
  }
}
