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
      notifyListeners();
    } catch (e) {
      _auth = null;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loginWithToken() async {
    try {
      _auth = await api.loginWithToken();
      notifyListeners();
      dprint('token from api: ${_auth?.token.substring(20, 25)}');
    } catch (e) {
      _auth = null;
      notifyListeners();
      rethrow;
    }
  }

  void logout() {
    try {
      api.logout();
      _auth = null;
    } catch (e) {
      dprint(e.toString());
    }
  }

  bool get isLoggedIn => _auth != null;

  String get doc_id => _auth!.record.id;

  static String get doc_id_static_getter => _auth!.record.id;
}
