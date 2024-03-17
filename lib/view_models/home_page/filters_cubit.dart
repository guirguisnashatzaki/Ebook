import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'filters_state.dart';

class FiltersCubit extends Cubit<FiltersState> {

  List<String> categories = [];

  FiltersCubit() : super(FiltersInitial());

  addCat(List<String> cats){
    categories = cats;
    emit(FiltersAdded(categories));
  }

  removeCat(List<String> cats){
    categories = cats;
    emit(FiltersRemoved(categories));
  }
}
