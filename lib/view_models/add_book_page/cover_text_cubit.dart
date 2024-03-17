import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cover_text_state.dart';

class CoverTextCubit extends Cubit<CoverTextState> {

  String text = "Add cover";


  CoverTextCubit() : super(CoverTextInitial("Add cover"));

  setAdded(String value){
    emit(CoverTextAdded(value));
  }

  setUpdate(String val){
    text = val;
    emit(CoverTextUpdate(text));
  }
}
