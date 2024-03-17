part of 'categories_cubit.dart';

@immutable
abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesAdded extends CategoriesState {
  final List<String> categories;

  CategoriesAdded(this.categories);
}

class CategoriesRemoved extends CategoriesState {
  final List<String> categories;

  CategoriesRemoved(this.categories);
}