part of 'book_text_cubit.dart';

@immutable
abstract class BookTextState {}

class BookTextInitial extends BookTextState {
  final String text;

  BookTextInitial(this.text);
}

class BookTextAdded extends BookTextState {
  final String text;

  BookTextAdded(this.text);
}

class BookTextUpdate extends BookTextState {
  final String text;

  BookTextUpdate(this.text);
}