import 'package:equatable/equatable.dart';
import 'package:allevia_one/models/app_constants/account_type.dart';
import 'package:allevia_one/models/app_constants/app_permission.dart';

class User extends Equatable {
  final String id;
  final String email;
  final AccountType account_type;
  final List<AppPermission> app_permissions;

  const User({
    required this.id,
    required this.email,
    required this.account_type,
    required this.app_permissions,
  });

  User copyWith({
    String? id,
    String? email,
    AccountType? account_type,
    List<AppPermission>? app_permissions,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      account_type: account_type ?? this.account_type,
      app_permissions: app_permissions ?? this.app_permissions,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'account_type': account_type.toJson(),
      'app_permissions': app_permissions.map((x) => x.toJson()).toList(),
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      account_type:
          AccountType.fromJson(map['account_type'] as Map<String, dynamic>),
      app_permissions: List<AppPermission>.from(
        (map['app_permissions'] as List<dynamic>).map<AppPermission>(
          (x) => AppPermission.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, email, account_type, app_permissions];
}
