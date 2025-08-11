import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/visit_filter_api.dart';
import 'package:allevia_one/models/visits/_visit.dart';

class PxVisitFilter extends ChangeNotifier {
  final VisitFilterApi api;

  PxVisitFilter({required this.api}) {
    _fetchVisitsOfDateRange();
  }

  ApiResult<List<Visit>>? _visits;
  ApiResult<List<Visit>>? get visits => _visits;

  int _page = 1;
  int get page => _page;

  static const perPage = 10;

  final _now = DateTime.now();

  late DateTime _from = DateTime(_now.year, _now.month, 1);
  DateTime get from => _from;

  late DateTime _to = DateTime(_now.year, _now.month + 1, 1);
  DateTime get to => _to;

  String get formattedFrom => DateFormat('yyyy-MM-dd', 'en').format(from);
  String get formattedTo =>
      DateFormat('yyyy-MM-dd', 'en').format(to.copyWith(day: to.day + 1));

  Future<void> _fetchVisitsOfDateRange() async {
    _visits = await api.fetctVisitsOfDateRange(
      // page: page,
      // perPage: perPage,
      from: formattedFrom,
      to: formattedTo,
    );
    notifyListeners();
  }

  Future<void> retry() async => await _fetchVisitsOfDateRange();

  Future<void> changeDate({
    required DateTime from,
    required DateTime to,
  }) async {
    _from = from;
    _to = to;
    _page = 1;
    notifyListeners();
    await _fetchVisitsOfDateRange();
  }

  Future<void> nextPage() async {
    if ((_visits as ApiDataResult<List<Visit>>).data.length < perPage) {
      return;
    }
    _page++;
    notifyListeners();
    await _fetchVisitsOfDateRange();
  }

  Future<void> previousPage() async {
    if (_page <= 1) {
      return;
    }
    _page--;
    notifyListeners();
    await _fetchVisitsOfDateRange();
  }
}
