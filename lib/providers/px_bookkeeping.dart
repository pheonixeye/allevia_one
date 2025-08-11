import 'package:flutter/material.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/bookkeeping_api.dart';
import 'package:allevia_one/models/bookkeeping/bookkeeping_item.dart';
import 'package:allevia_one/models/bookkeeping/bookkeeping_item_dto.dart';

class PxBookkeeping extends ChangeNotifier {
  final BookkeepingApi api;

  PxBookkeeping({required this.api}) {
    _fetchDetailedItems();
  }

  final _now = DateTime.now();

  ApiResult<List<BookkeepingItem>>? _result;
  ApiResult<List<BookkeepingItem>>? get result => _result;

  late DateTime _from = DateTime(_now.year, _now.month, 1);
  DateTime get from => _from;

  late DateTime _to = DateTime(_now.year, _now.month + 1, 1);
  DateTime get to => _to;

  Future<void> _fetchDetailedItems() async {
    _result = await api.fetchDetailedItems(from: from, to: to);
    notifyListeners();
  }

  Future<void> retry() async => await _fetchDetailedItems();

  Future<void> changeDate({
    required DateTime from,
    required DateTime to,
  }) async {
    _from = from;
    _to = to;
    notifyListeners();
    await _fetchDetailedItems();
  }

  Future<void> addBookkeepingEntry(BookkeepingItemDto dto) async {
    await api.addBookkeepingItem(dto);
    await _fetchDetailedItems();
  }
}
