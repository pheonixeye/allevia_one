import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/bookkeeping_api.dart';
import 'package:allevia_one/models/bookkeeping/bookkeeping_item_dto.dart';
import 'package:flutter/material.dart';

class PxOneVisitBookkeeping extends ChangeNotifier {
  final BookkeepingApi api;

  PxOneVisitBookkeeping({required this.api}) {
    _init();
  }

  ApiResult<List<BookkeepingItemDto>>? _result;
  ApiResult<List<BookkeepingItemDto>>? get result => _result;

  Future<void> _init() async {
    _result = await api.fetchBookkeepingOfOneVisit();
    notifyListeners();
  }

  Future<void> retry() async => await _init();
}
