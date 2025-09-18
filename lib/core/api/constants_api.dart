import 'dart:convert';

import 'package:allevia_one/models/app_constants/document_type.dart';
import 'package:hive_ce/hive.dart';
import 'package:allevia_one/core/api/constants/pocketbase_helper.dart';
import 'package:allevia_one/models/app_constants/account_type.dart';
import 'package:allevia_one/models/app_constants/_app_constants.dart';
import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/models/app_constants/patient_progress_status.dart';
import 'package:allevia_one/models/app_constants/subscription_plan.dart';
import 'package:allevia_one/models/app_constants/visit_status.dart';
import 'package:allevia_one/models/app_constants/visit_type.dart';

class ConstantsApi {
  const ConstantsApi();
  static final _n = DateTime.now();
  static const _perPage = 200;

  static const String account_types = 'account_types';
  static const String visit_status = 'visit_status';
  static const String visit_type = 'visit_type';
  static const String subscription_plan = 'subscription_plans';
  static const String patient_progress_status = 'patient_progress_status';
  static const String app_permissions = 'app_permissions';
  static const String document_type = 'document_type';

  static const String collection = 'constants';
  static String collectionSaveDate = 'constants_save_date';

  static final _box = Hive.box<String>(collection);
  static final _boxSaveDate = Hive.box<String>(collectionSaveDate);

  Future<AppConstants> fetchConstants() async {
    AppConstants? _constants;

    // await Hive.openBox<String>(collection);
    // await Hive.openBox<String>(collectionSaveDate);

    // if (_boxSaveDate.get(collectionSaveDate) != null &&
    //     _boxSaveDate.isNotEmpty) {
    //   final _saveDate = DateTime.parse(_boxSaveDate.get(collectionSaveDate)!);
    //   if (_saveDate.add(const Duration(days: 7)).isAfter(_n)) {
    //     _box.clear();
    //     await _boxSaveDate.put(collectionSaveDate,
    //         DateTime(_n.year, _n.month, _n.day).toIso8601String());
    //   }
    // }
    // if (_box.get(collection) != null && _box.isNotEmpty) {
    //   try {
    //     _constants =
    //         AppConstants.fromJson((json.decode(_box.get(collection)!)));
    //     return _constants;
    //   } catch (e) {
    //     //TODO:
    //     print('Saved Constants Could Not Be Parsed.');
    //     _constants = null;
    //   }
    // }

    late final List<AccountType> accountTypes;
    late final List<VisitStatus> visitStatus;
    late final List<VisitType> visitType;
    late final List<SubscriptionPlan> subscriptionPlan;
    late final List<PatientProgressStatus> patientProgressStatus;
    late final List<AppPermission> appPermission;
    late final List<DocumentType> documentType;

    final _accountTypesRequest =
        PocketbaseHelper.pb.collection(account_types).getList(
              perPage: _perPage,
            );

    final _visitStatusRequest =
        PocketbaseHelper.pb.collection(visit_status).getList(
              perPage: _perPage,
            );

    final _visitTypeRequest =
        PocketbaseHelper.pb.collection(visit_type).getList(
              perPage: _perPage,
            );

    final _subscriptionPlanRequest =
        PocketbaseHelper.pb.collection(subscription_plan).getList(
              perPage: _perPage,
            );

    final _patientProgressStatusRequest =
        PocketbaseHelper.pb.collection(patient_progress_status).getList(
              perPage: _perPage,
            );

    final _appPermissionRequest =
        PocketbaseHelper.pb.collection(app_permissions).getList(
              perPage: _perPage,
            );

    final _documentTypeRequest =
        PocketbaseHelper.pb.collection(document_type).getList(
              perPage: _perPage,
            );

    final _result = await Future.wait([
      _accountTypesRequest,
      _visitStatusRequest,
      _visitTypeRequest,
      _subscriptionPlanRequest,
      _patientProgressStatusRequest,
      _appPermissionRequest,
      _documentTypeRequest,
    ]);

    accountTypes =
        _result[0].items.map((e) => AccountType.fromJson(e.toJson())).toList();

    visitStatus =
        _result[1].items.map((e) => VisitStatus.fromJson(e.toJson())).toList();

    visitType =
        _result[2].items.map((e) => VisitType.fromJson(e.toJson())).toList();

    subscriptionPlan = _result[3]
        .items
        .map((e) => SubscriptionPlan.fromJson(e.toJson()))
        .toList();

    patientProgressStatus = _result[4]
        .items
        .map((e) => PatientProgressStatus.fromJson(e.toJson()))
        .toList();

    appPermission = _result[5]
        .items
        .map((e) => AppPermission.fromJson(e.toJson()))
        .toList();
    documentType =
        _result[6].items.map((e) => DocumentType.fromJson(e.toJson())).toList();

    _constants = AppConstants(
      accountTypes: accountTypes,
      visitStatus: visitStatus,
      visitType: visitType,
      subscriptionPlan: subscriptionPlan,
      patientProgressStatus: patientProgressStatus,
      appPermission: appPermission,
      documentType: documentType,
    );

    // await _box.put(collection, json.encode(_constants.toJson()));
    // await _boxSaveDate.put(collectionSaveDate,
    //     DateTime(_n.year, _n.month, _n.day).toIso8601String());

    return _constants;
  }
}
