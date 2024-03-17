part of 'cover_text_cubit.dart';

@immutable
abstract class CoverTextState {}

class CoverTextInitial extends CoverTextState {
  final String text;

  CoverTextInitial(this.text);
}

class CoverTextAdded extends CoverTextState {
  final String text;

  CoverTextAdded(this.text);
}

class CoverTextUpdate extends CoverTextState {
  final String text;

  CoverTextUpdate(this.text);
}
