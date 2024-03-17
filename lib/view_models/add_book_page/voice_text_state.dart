part of 'voice_text_cubit.dart';

@immutable
abstract class VoiceTextState {}

class VoiceTextInitial extends VoiceTextState {
  final String text;

  VoiceTextInitial(this.text);
}

class VoiceTextAdded extends VoiceTextState {
  final String text;

  VoiceTextAdded(this.text);
}

class VoiceTextUpdate extends VoiceTextState {
  final String text;

  VoiceTextUpdate(this.text);
}