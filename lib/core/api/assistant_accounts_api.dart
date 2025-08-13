import 'package:allevia_one/core/api/_api_result.dart';
import 'package:allevia_one/core/api/constants/pocketbase_helper.dart';
import 'package:allevia_one/errors/code_to_error.dart';
import 'package:allevia_one/models/user/user.dart';
import 'package:pocketbase/pocketbase.dart';

class AssistantAccountsApi {
  const AssistantAccountsApi();

  static const String collection = 'users';

  static const _expandList = [
    'account_type_id',
    'app_permissions_ids',
  ];

  static final _expand = _expandList.join(',');

  Future<ApiResult<User>> createAssistantAccount(
    User account,
    String password,
    String passwordConfirm,
  ) async {
    try {
      final result = await PocketbaseHelper.pb.collection(collection).create(
        body: {
          ...account.toJson(),
          'verified': false,
          'emailVisibility': true,
          'password': password,
          'passwordConfirm': passwordConfirm,
        },
        expand: _expand,
      );

      final _account = User.fromJson(result.toJson());

      return ApiDataResult(data: _account);
    } on ClientException catch (e) {
      return ApiErrorResult<User>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<ApiResult<List<User>>> fetchAssistantAccounts(
      String assistantAccountTypeId) async {
    try {
      final result = await PocketbaseHelper.pb.collection(collection).getList(
            filter: "account_type_id = '$assistantAccountTypeId'",
            expand: _expand,
          );

      final _accounts =
          result.items.map((e) => User.fromJson(e.toJson())).toList();

      return ApiDataResult<List<User>>(data: _accounts);
    } on ClientException catch (e) {
      return ApiErrorResult<List<User>>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> addAccountPermission(
    String account_id,
    String permission_id,
  ) async {
    await PocketbaseHelper.pb.collection(collection).update(
      account_id,
      body: {
        'app_permissions_ids+': permission_id,
      },
    );
  }

  Future<void> removeAccountPermission(
    String account_id,
    String permission_id,
  ) async {
    await PocketbaseHelper.pb.collection(collection).update(
      account_id,
      body: {
        'app_permissions_ids': permission_id,
      },
    );
  }

  Future<void> deleteAccount(String account_id) async {
    await PocketbaseHelper.pb.collection(collection).delete(
          account_id,
        );
  }
}
