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
    filterDiscounts();
  }

  Future<void> retry() async => await _init();

  Future<void> addBookkeepingEntry(BookkeepingItemDto dto) async {
    await api.addBookkeepingItem(dto);
    await _init();
  }

  List<BookkeepingItemDto>? _visitDiscounts;
  List<BookkeepingItemDto>? get visitDiscounts => _visitDiscounts;

  void filterDiscounts() {
    if (_result != null && _result is ApiDataResult<List<BookkeepingItemDto>>) {
      final _items = (_result as ApiDataResult<List<BookkeepingItemDto>>).data;
      _visitDiscounts =
          _items.where((e) => e.item_name.contains('discount')).toList();
      notifyListeners();
    }
  }

  double? get discountTotal =>
      _visitDiscounts?.map((e) => e.amount).fold<double>(0, (a, b) => a + b);
}
