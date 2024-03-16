part of 'get_users_cubit.dart';

@immutable
abstract class GetUsersState {}

class GetUsersInitial extends GetUsersState {}

class GetUsersLoaded extends GetUsersState{
  final List<User> users;

  GetUsersLoaded(this.users);
}

class GetUsersLoading extends GetUsersState{
  final bool isLoading;

  GetUsersLoading(this.isLoading);
}

class GetUsersNotLoading extends GetUsersState{
  final bool isLoading;

  GetUsersNotLoading(this.isLoading);
}
