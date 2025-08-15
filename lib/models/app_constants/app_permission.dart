import 'package:equatable/equatable.dart';

class AppPermission extends Equatable {
  final String id;
  final String name_en;
  final String name_ar;

  const AppPermission({
    required this.id,
    required this.name_en,
    required this.name_ar,
  });

  AppPermission copyWith({
    String? id,
    String? name_en,
    String? name_ar,
  }) {
    return AppPermission(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
    };
  }

  factory AppPermission.fromJson(Map<String, dynamic> map) {
    return AppPermission(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name_en, name_ar];
}

enum PermissionEnum {
  Admin,
  User,
  User_Patient_AddNew, //done
  User_Patient_EditInfo, //done
  User_Patient_AddNewVisit, //done
  User_Patient_PreviousVisits, //done
  User_Patient_InfoCard, //done
  User_Patient_Call, //done
  User_Patient_Whatsapp, //done
  User_Patient_Email, //done
  User_Patient_Forms, //done
  User_Visits_Read,
  User_Bookkeeping_Read,
  User_Bookkeeping_Add,
  User_AccountSettings_Read,
  User_AccountSettings_Modify,
  User_TodayVisits_Read,
  User_TodayVisits_Modify,
  User_TodayVisits_EnterVisit,
  User_Clinics_Read,
  User_Clinics_Modify,
  User_Clinics_Add,
  User_Clinics_Activity,
  User_Clinics_Schedule,
  User_Clinics_Prescription,
  User_Clinics_Store,
  User_Clinics_Delete,
  User_SupplyMovements_Read,
  User_SupplyMovement_Add,
  User_Subscription_Read,
  User_Subscription_Modify,
  // User_AssistantAccounts_Read,
  // User_AssistantAccounts_Modify,
  // User_AssistantAccounts_Delete,
  User_Forms_Read,
  User_Forms_Add,
  User_Forms_Modify,
  User_Forms_Delete;

  factory PermissionEnum.fromString(String value) {
    return PermissionEnum.values.firstWhere((x) => x.name == value);
  }
}

class PermissionWithPermission extends Equatable {
  final AppPermission permission;
  final bool isAllowed;

  const PermissionWithPermission({
    required this.permission,
    required this.isAllowed,
  });

  @override
  List<Object> get props => [
        permission,
        isAllowed,
      ];
}
