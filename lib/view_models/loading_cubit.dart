import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {

  LoadingCubit() : super(LoadingInitial());

  setIsLoading(bool value){
    if(value){
      emit(Loading(true));
    }else{
      emit(LoadingStopped(false));
    }
  }
}