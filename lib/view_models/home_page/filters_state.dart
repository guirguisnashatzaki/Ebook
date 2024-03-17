part of 'filters_cubit.dart';

@immutable
abstract class FiltersState {}

class FiltersInitial extends FiltersState {}

class FiltersAdded extends FiltersState {
  final List<String> categories;

  FiltersAdded(this.categories);
}

class FiltersRemoved extends FiltersState {
  final List<String> categories;

  FiltersRemoved(this.categories);
}
