part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterValidated extends RegisterState {
  final NetworkState state;

  RegisterValidated(this.state);
}

class RegisterValidationError extends RegisterState {}

class RegisterError extends RegisterState {
  final NetworkState state;

  RegisterError(this.state);
}

class RegisterPasswordError extends RegisterState {}
