import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'book_text_state.dart';

class BookTextCubit extends Cubit<BookTextState> {
  String text = "Add Book pdf";

  BookTextCubit() : super(BookTextInitial("Add Book pdf"));

  setAdded(String value){
    emit(BookTextAdded(value));
  }

  setUpdate(String val){
    text = val;
    emit(BookTextUpdate(text));
  }
}