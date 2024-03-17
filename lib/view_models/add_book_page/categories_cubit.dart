import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {

  List<String> categories = [];

  CategoriesCubit() : super(CategoriesInitial());

  setUpdateList(List<String> cats){
    categories.addAll(cats);
  }

  addCat(String val,List<String> cats){
    categories.add(val);
    emit(CategoriesAdded(categories));
  }

  removeCat(String val,List<String> cats){
    categories.remove(val);
    emit(CategoriesRemoved(categories));
  }

}