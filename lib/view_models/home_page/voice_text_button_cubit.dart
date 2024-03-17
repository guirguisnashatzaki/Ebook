import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';



part 'voice_text_button_state.dart';

class VoiceTextButtonCubit extends Cubit<VoiceTextButtonState> {

  String text = "Play voice";
  List<String> voiceTextButtons = [];

  VoiceTextButtonCubit() : super(VoiceTextButtonInitial());

  flipText(int index,List<String> texts,){

    voiceTextButtons = texts;

    if(voiceTextButtons[index] == "Play voice"){
      voiceTextButtons[index] = "Stop voice";
      emit(VoiceTextButtonStop(voiceTextButtons));
    }else{
      voiceTextButtons[index] = "Play voice";
      emit(VoiceTextButtonPlay(voiceTextButtons));
    }
  }

  setInitialy(List<String> lsit){
    voiceTextButtons = lsit;
    emit(VoiceTextButtonInit(voiceTextButtons));
  }
}
