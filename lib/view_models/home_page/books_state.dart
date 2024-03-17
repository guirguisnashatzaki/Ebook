part of 'books_cubit.dart';

@immutable
abstract class BooksState {}

class BooksInitial extends BooksState {}

class BooksLoaded extends BooksState{
  final List<Book> books;

  BooksLoaded(this.books);
}

class BooksError extends BooksState{
  final List<Book> books;

  BooksError(this.books);
}