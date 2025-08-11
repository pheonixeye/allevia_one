import 'package:pocketbase/pocketbase.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/constants/pocketbase_helper.dart';
import 'package:allevia_one/errors/code_to_error.dart';
import 'package:allevia_one/models/visits/_visit.dart';

class VisitFilterApi {
  VisitFilterApi();

  late final String collection = 'visits';

  static final String _expand =
      'patient_id, clinic_id, added_by_id, added_by_id.account_type_id, added_by_id.app_permissions_ids, visit_status_id, visit_type_id, patient_progress_status_id';

  Future<ApiResult<List<Visit>>> fetctVisitsOfDateRange({
    required String from,
    required String to,
  }) async {
    try {
      final _response =
          await PocketbaseHelper.pb.collection(collection).getFullList(
                filter: "visit_date >= '$from' && visit_date <= '$to'",
                sort: '-visit_date',
                expand: _expand,
              );

      final _visits = _response.map((e) {
        return Visit.fromRecordModel(e);
      }).toList();

      return ApiDataResult<List<Visit>>(data: _visits);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }
}
