import 'package:flutter/material.dart';
import 'package:allevia_one/core/api/constants_api.dart';
import 'package:allevia_one/models/app_constants/account_type.dart';
import 'package:allevia_one/models/app_constants/_app_constants.dart';
import 'package:allevia_one/models/app_constants/app_permission.dart';
import 'package:allevia_one/models/app_constants/patient_progress_status.dart';
import 'package:allevia_one/models/app_constants/subscription_plan.dart';
import 'package:allevia_one/models/app_constants/visit_status.dart';
import 'package:allevia_one/models/app_constants/visit_type.dart';

class PxAppConstants extends ChangeNotifier {
  final ConstantsApi api;

  PxAppConstants({required this.api}) {
    _init();
  }

  static AppConstants? _constants;
  AppConstants? get constants => _constants;

  Future<void> _init() async {
    if (_constants != null) {
      return;
    }
    _constants = await api.fetchConstants();
    notifyListeners();
  }

//account types
  AccountType get doctorAccountType =>
      _constants!.accountTypes.firstWhere((acc) => acc.name_en == 'Doctor');

  AccountType get assistantAccountType =>
      _constants!.accountTypes.firstWhere((acc) => acc.name_en == 'Assistant');
//visit statuses
  VisitStatus get attended =>
      _constants!.visitStatus.firstWhere((vs) => vs.name_en == 'Attended');

  VisitStatus get notAttended =>
      _constants!.visitStatus.firstWhere((vs) => vs.name_en == 'Not Attended');

  List<VisitStatus> get visitStatuses => [attended, notAttended];
//visit Types
  VisitType get consultation =>
      _constants!.visitType.firstWhere((vt) => vt.name_en == 'Consultation');

  VisitType get followup =>
      _constants!.visitType.firstWhere((vt) => vt.name_en == 'Follow Up');

  VisitType get procedure =>
      _constants!.visitType.firstWhere((vt) => vt.name_en == 'Procedure');

  List<VisitType> get visitTypes => [consultation, followup, procedure];
  //subscription plans
  SubscriptionPlan? get trial =>
      _constants?.subscriptionPlan.firstWhere((sp) => sp.name_en == 'Trial');

  SubscriptionPlan? get monthly =>
      _constants?.subscriptionPlan.firstWhere((sp) => sp.name_en == 'Monthly');

  SubscriptionPlan? get halfAnnual => _constants?.subscriptionPlan
      .firstWhere((sp) => sp.name_en == 'Half Annual');

  SubscriptionPlan? get annual =>
      _constants?.subscriptionPlan.firstWhere((sp) => sp.name_en == 'Annual');

  List<SubscriptionPlan> get validSubscriptions =>
      _constants?.subscriptionPlan != null
          ? [
              monthly!,
              halfAnnual!,
              annual!,
            ]
          : [];
//patient progress status
  PatientProgressStatus get in_waiting => _constants!.patientProgressStatus
      .firstWhere((e) => e.name_en == 'In Waiting');
  PatientProgressStatus get in_consultation => _constants!.patientProgressStatus
      .firstWhere((e) => e.name_en == 'In Consultation');
  PatientProgressStatus get done_consultation =>
      _constants!.patientProgressStatus
          .firstWhere((e) => e.name_en == 'Done Consultation');
  PatientProgressStatus get has_not_attended_yet =>
      _constants!.patientProgressStatus
          .firstWhere((e) => e.name_en == 'Has Not Attended Yet');

  List<PatientProgressStatus> get patientProgressStatuses => [
        in_waiting,
        in_consultation,
        done_consultation,
        has_not_attended_yet,
      ];
//app permissions
  AppPermission get admin =>
      _constants!.appPermission.firstWhere((e) => e.name_en == 'Admin');
  AppPermission get user =>
      _constants!.appPermission.firstWhere((e) => e.name_en == 'User');
}
