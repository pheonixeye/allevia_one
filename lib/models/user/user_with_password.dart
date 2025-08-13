// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:allevia_one/models/user/user.dart';

class UserWithPassword extends Equatable {
  final User user;
  final String password;
  final String confirmPassword;

  const UserWithPassword({
    required this.user,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [
        user,
        password,
        confirmPassword,
      ];
}
