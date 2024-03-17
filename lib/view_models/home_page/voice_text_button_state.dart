part of 'voice_text_button_cubit.dart';

@immutable
abstract class VoiceTextButtonState {}

class VoiceTextButtonInitial extends VoiceTextButtonState {}

class VoiceTextButtonPlay extends VoiceTextButtonState {
  final List<String> voiceTextButtons;

  VoiceTextButtonPlay(this.voiceTextButtons);
}

class VoiceTextButtonStop extends VoiceTextButtonState {
  final List<String> voiceTextButtons;

  VoiceTextButtonStop(this.voiceTextButtons);
}

class VoiceTextButtonInit extends VoiceTextButtonState {
  final List<String> voiceTextButtons;

  VoiceTextButtonInit(this.voiceTextButtons);
}
