part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginValidated extends LoginState {
  final NetworkState state;

  LoginValidated(this.state);
}

class LoginValidationError extends LoginState {}

class LoginError extends LoginState {
  final NetworkState state;

  LoginError(this.state);
}
