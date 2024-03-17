import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'voice_text_state.dart';

class VoiceTextCubit extends Cubit<VoiceTextState> {

  String text = "Add voice (Optional)";

  VoiceTextCubit() : super(VoiceTextInitial("Add voice (Optional)"));

  setAdded(String value){
    emit(VoiceTextAdded(value));
  }

  setUpdate(String val){
    text = val;
    emit(VoiceTextUpdate(text));
  }
}
