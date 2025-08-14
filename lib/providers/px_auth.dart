import 'package:allevia_one/constants/app_business_constants.dart';
import 'package:allevia_one/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:allevia_one/core/api/auth/api_auth.dart';
import 'package:allevia_one/functions/dprint.dart';
import 'package:allevia_one/models/dto_create_doctor_account.dart';

class PxAuth extends ChangeNotifier {
  final AuthApi api;

  PxAuth({
    required this.api,
  });

  static RecordAuth? _auth;
  RecordAuth? get authModel => _auth;

  static User? _user;
  User? get user => _user;

  Future<void> createAccount(DtoCreateDoctorAccount dto) async {
    await api.createAccount(dto);
  }

  Future<void> loginWithEmailAndPassword(
    String email,
    String password, [
    bool rememberMe = false,
  ]) async {
    try {
      final result =
          await api.loginWithEmailAndPassword(email, password, rememberMe);
      _auth = result;
      _user = User.fromRecordModel(_auth!.record);
      notifyListeners();
    } catch (e) {
      _auth = null;
      _user = null;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loginWithToken() async {
    try {
      _auth = await api.loginWithToken();
      _user = User.fromRecordModel(_auth!.record);
      notifyListeners();
      dprint('token from api: ${_auth?.token.substring(20, 25)}');
    } catch (e) {
      _auth = null;
      _user = null;
      notifyListeners();
      rethrow;
    }
  }

  void logout() {
    try {
      api.logout();
      _auth = null;
      _user = null;
    } catch (e) {
      dprint(e.toString());
    }
  }

  bool get isLoggedIn => _auth != null;

  String get doc_id => _auth!.record.id;

  static String get doc_id_static_getter => _auth!.record.id;

  static bool get isUserNotDoctor =>
      _user?.account_type.id == AppBusinessConstants.ASSISTANT_ACCOUNT_TYPE_ID;
}
