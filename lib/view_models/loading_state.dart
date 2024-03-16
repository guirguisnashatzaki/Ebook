part of 'loading_cubit.dart';

@immutable
abstract class LoadingState {}

class LoadingInitial extends LoadingState {}

class Loading extends LoadingState {
  final bool isLoading;

  Loading(this.isLoading);
}

class LoadingStopped extends LoadingState {
  final bool isLoading;

  LoadingStopped(this.isLoading);
}
