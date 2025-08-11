import 'package:pocketbase/pocketbase.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/constants/pocketbase_helper.dart';
import 'package:allevia_one/errors/code_to_error.dart';
import 'package:allevia_one/models/supplies/clinic_inventory_item.dart';

class ClinicInventoryApi {
  final String clinic_id;
  final String doc_id;

  ClinicInventoryApi({required this.clinic_id, required this.doc_id});

  late final String collection = '${doc_id}__clinic__supplies';

  final String _expand = 'supply_id';

  Future<ApiResult<List<ClinicInventoryItem>>>
      fetchClinicInventoryItems() async {
    try {
      final _response =
          await PocketbaseHelper.pb.collection(collection).getFullList(
                filter: "clinic_id = '$clinic_id'",
                expand: _expand,
              );

      final _items =
          _response.map((e) => ClinicInventoryItem.fromRecordModel(e)).toList();

      return ApiDataResult<List<ClinicInventoryItem>>(data: _items);
    } on ClientException catch (e) {
      return ApiErrorResult<List<ClinicInventoryItem>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<ClinicInventoryItem>>> addNewInventoryItems(
    List<ClinicInventoryItem> items,
  ) async {
    final List<ClinicInventoryItem> _itemsAddResult = [];
    for (final item in items) {
      try {
        final _response =
            await PocketbaseHelper.pb.collection(collection).create(
                  body: item.toJson(),
                );
        final _item = ClinicInventoryItem.fromRecordModel(_response);
        _itemsAddResult.add(_item);
      } catch (e) {
        final _response =
            await PocketbaseHelper.pb.collection(collection).update(
                  item.id,
                  body: item.toJson(),
                );
        final _item = ClinicInventoryItem.fromRecordModel(_response);
        _itemsAddResult.add(_item);
      }
    }
    return ApiDataResult<List<ClinicInventoryItem>>(data: _itemsAddResult);
  }

  //#last step
  Future<void> updateInventoryItemAvailableQuantity({
    required ClinicInventoryItem inventoryItem,
  }) async {
    await PocketbaseHelper.pb.collection(collection).update(
      inventoryItem.id,
      body: {
        'available_quantity': inventoryItem.available_quantity,
      },
    );
  }
}
