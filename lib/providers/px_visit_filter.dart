import 'package:allevia_one/models/visits/concised_visit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/visit_filter_api.dart';
import 'package:allevia_one/models/visits/_visit.dart';

class PxVisitFilter extends ChangeNotifier {
  final VisitFilterApi api;

  PxVisitFilter({
    required this.api,
  }) {
    _fetchConcisedVisitsOfDateRange();
  }

  static ApiResult<Visit>? _expandedVisit;
  ApiResult<Visit>? get expandedVisit => _expandedVisit;

  ApiResult<List<ConcisedVisit>>? _concisedVisits;
  ApiResult<List<ConcisedVisit>>? get concisedVisits => _concisedVisits;

  final _now = DateTime.now();

  late DateTime _from = DateTime(_now.year, _now.month, 1);
  DateTime get from => _from;

  late DateTime _to = DateTime(_now.year, _now.month + 1, 1);
  DateTime get to => _to;

  String get formattedFrom => DateFormat('yyyy-MM-dd', 'en').format(from);
  String get formattedTo =>
      DateFormat('yyyy-MM-dd', 'en').format(to.copyWith(day: to.day + 1));

  Future<void> _fetchConcisedVisitsOfDateRange() async {
    _concisedVisits = await api.fetctConcisedVisitsOfDateRange(
      from: formattedFrom,
      to: formattedTo,
    );
    notifyListeners();
  }

  Future<void> retry() async => await _fetchConcisedVisitsOfDateRange();

  Future<void> changeDate({
    required DateTime from,
    required DateTime to,
  }) async {
    _from = from;
    _to = to;
    notifyListeners();
    await _fetchConcisedVisitsOfDateRange();
  }

  Future<void> fetchOneExpandedVisit(String visit_id) async {
    _expandedVisit = await api.fetchOneExpandedVisit(visit_id);
    notifyListeners();
  }

  Future<void> nullifyExpandedVisit() async {
    _expandedVisit = null;
    notifyListeners();
  }
}
