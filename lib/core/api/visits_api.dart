import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/bookkeeping_api.dart';
import 'package:allevia_one/core/api/constants/pocketbase_helper.dart';
import 'package:allevia_one/core/logic/bookkeeping_transformer.dart';
import 'package:allevia_one/errors/code_to_error.dart';
import 'package:allevia_one/models/visit_data/visit_data_dto.dart';
import 'package:allevia_one/models/visits/_visit.dart';
import 'package:allevia_one/models/visits/visit_create_dto.dart';

class VisitsApi {
  VisitsApi();

  late final String collection = 'visits';

  late final String visit_data_collection = 'visit__data';

  static final String _expand =
      'patient_id, clinic_id, added_by_id, added_by_id.account_type_id, added_by_id.app_permissions_ids, visit_status_id, visit_type_id, patient_progress_status_id, doc_id, doc_id.speciality_id';

  final _now = DateTime.now();

  Future<ApiResult<List<Visit>>> fetctVisitsOfASpecificDate({
    required int page,
    required int perPage,
    DateTime? visit_date,
  }) async {
    visit_date = visit_date ?? _now;
    final _date_of_visit =
        DateTime(visit_date.year, visit_date.month, visit_date.day);
    final _date_after_visit =
        DateTime(visit_date.year, visit_date.month, visit_date.day + 1);

    final _dateOfVisitFormatted =
        DateFormat('yyyy-MM-dd', 'en').format(_date_of_visit);
    final _dateAfterVisitFormatted =
        DateFormat('yyyy-MM-dd', 'en').format(_date_after_visit);
    try {
      // print(_todayFormatted);
      final _result = await PocketbaseHelper.pb.collection(collection).getList(
            page: page,
            perPage: perPage,
            filter:
                "visit_date >= '$_dateOfVisitFormatted' && visit_date <= '$_dateAfterVisitFormatted'",
            expand: _expand,
            sort: '-patient_entry_number',
          );

      // prettyPrint(_result);

      final _visits = _result.items.map((e) {
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

  Future<void> addNewVisit(VisitCreateDto dto) async {
    final _result = await PocketbaseHelper.pb.collection(collection).create(
          body: dto.toJson(),
          expand: _expand,
        );
    await PocketbaseHelper.pb.collection(visit_data_collection).create(
          body: VisitDataDto.initial(
            visit_id: _result.id,
            patient_id: dto.patient_id,
            clinic_id: dto.clinic_id,
          ).toJson(),
        );

    //todo: parse result
    final _visit = Visit.fromRecordModel(_result);

    //todo: initialize transformer
    final _bk_transformer = BookkeepingTransformer(
      item_id: _visit.id,
      collection_id: collection,
    );

    //todo: initialize bk_item
    final _item = _bk_transformer.fromVisitCreate(_visit);

    //todo: send bookkeeping request
    await BookkeepingApi().addBookkeepingItem(_item);
  }

  Future<void> updateVisit(Visit visit, String key, dynamic value) async {
    final _response = await PocketbaseHelper.pb.collection(collection).update(
          visit.id,
          body: {
            key: value,
          },
          expand: _expand,
        );

    //todo: parse result
    final _old_visit = visit;
    final _updated_visit = Visit.fromRecordModel(_response);

    //todo: initialize transformer
    final _bk_transformer = BookkeepingTransformer(
      item_id: visit.id,
      collection_id: collection,
    );

    //todo: initialize bk_item
    final _item = _bk_transformer.fromVisitUpdate(_old_visit, _updated_visit);

    //todo: send bookkeeping request
    await BookkeepingApi().addBookkeepingItem(_item);
  }

  // Future<UnsubscribeFunc> todayVisitsSubscription(
  //   void Function(RecordSubscriptionEvent) callback,
  // ) async {
  //   final visit_date = _now;
  //   final _date_of_visit =
  //       DateTime(visit_date.year, visit_date.month, visit_date.day);
  //   final _date_after_visit =
  //       DateTime(visit_date.year, visit_date.month, visit_date.day + 1);

  //   final _dateOfVisitFormatted =
  //       DateFormat('yyyy-MM-dd', 'en').format(_date_of_visit);
  //   final _dateAfterVisitFormatted =
  //       DateFormat('yyyy-MM-dd', 'en').format(_date_after_visit);

  //   final sub = await PocketbaseHelper.pb.collection(collection).subscribe(
  //         '*',
  //         callback,
  //         filter:
  //             "visit_date >= '$_dateOfVisitFormatted' && visit_date < '$_dateAfterVisitFormatted'",
  //         expand: _expand,
  //       );
  //   return sub;
  // }
}
