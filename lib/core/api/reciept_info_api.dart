import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/constants/pocketbase_helper.dart';
import 'package:allevia_one/errors/code_to_error.dart';
import 'package:allevia_one/models/reciept_info.dart';
import 'package:pocketbase/pocketbase.dart';

class RecieptInfoApi {
  const RecieptInfoApi();
  static const _collection = 'reciept_info';

  Future<ApiResult<List<RecieptInfo>>> fetchRecieptInfo() async {
    try {
      final _response =
          await PocketbaseHelper.pb.collection(_collection).getList(
                sort: '-created',
              );

      final info =
          _response.items.map((e) => RecieptInfo.fromJson(e.toJson())).toList();

      return ApiDataResult<List<RecieptInfo>>(data: info);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> addRecieptInfo(RecieptInfo reciept_info) async {
    await PocketbaseHelper.pb.collection(_collection).create(
          body: reciept_info.toJson(),
        );
  }

  Future<void> deleteRecieptInfo(String id) async {
    await PocketbaseHelper.pb.collection(_collection).delete(id);
  }

  Future<void> updateRecieptInfo(RecieptInfo reciept_info) async {
    await PocketbaseHelper.pb.collection(_collection).update(
      reciept_info.id,
      body: {
        ...reciept_info.toJson(),
      },
    );
  }
}
