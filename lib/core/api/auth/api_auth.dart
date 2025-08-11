import 'package:pocketbase/pocketbase.dart';
import 'package:allevia_one/core/api/auth/auth_exception.dart';
import 'package:allevia_one/core/api/constants/pocketbase_helper.dart';
import 'package:allevia_one/functions/dprint.dart';
import 'package:allevia_one/models/dto_create_doctor_account.dart';
import 'package:allevia_one/utils/shared_prefs.dart';

class AuthApi {
  const AuthApi();

  Future<RecordModel?> createAccount(DtoCreateDoctorAccount dto) async {
    try {
      final result = await PocketbaseHelper.pb.collection('users').create(
            body: dto.toJson(),
          );

      await PocketbaseHelper.pb.collection('doctors').create(
        body: {
          'id': result.id,
          'speciality_id': dto.speciality.id,
          'name_en': dto.name_en,
          'name_ar': dto.name_ar,
          'phone': dto.phone,
          'email': dto.email,
        },
      );

      await PocketbaseHelper.pb
          .collection('users')
          .requestVerification(result.getStringValue('email'));
      return result;
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }
  }

  //# normal login flow
  Future<RecordAuth?> loginWithEmailAndPassword(
    String email,
    String password, [
    bool rememberMe = false,
  ]) async {
    RecordAuth? _result;
    try {
      _result = await PocketbaseHelper.pb
          .collection('users')
          .authWithPassword(email, password);
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }

    if (rememberMe) {
      try {
        await asyncPrefs.setString('token', _result.token);
      } catch (e) {
        dprint("couldn't save token => ${e.toString()}");
      }
    }
    return _result;
  }

  //# remember me login flow
  Future<RecordAuth?> loginWithToken() async {
    RecordAuth? result;
    String? _token;
    try {
      _token = await asyncPrefs.getString('token');
    } catch (e) {
      dprint("couldn't fetch token => ${e.toString()}");
      return null;
    }
    PocketbaseHelper.pb.authStore.save(_token!, null);
    try {
      result = await PocketbaseHelper.pb.collection('users').authRefresh();
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }

    return result;
  }

  Future<void> requestResetPassword(String email) async {
    try {
      await PocketbaseHelper.pb.collection('users').requestPasswordReset(email);
    } on ClientException catch (e) {
      dprint(e.toString());
      throw AuthException(e);
    }
  }

  void logout() {
    PocketbaseHelper.pb.authStore.clear();
    asyncPrefs.remove('token');
  }
}
