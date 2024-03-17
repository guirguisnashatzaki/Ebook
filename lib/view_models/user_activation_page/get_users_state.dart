part of 'get_users_cubit.dart';

@immutable
abstract class GetUsersState {}

class GetUsersInitial extends GetUsersState {}

class GetUsersLoaded extends GetUsersState{
  final List<User> users;

  GetUsersLoaded(this.users);
}