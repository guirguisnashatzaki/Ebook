import 'package:bloc/bloc.dart';
import 'package:ebook/helpers/firestore_helper.dart';
import 'package:ebook/models/User.dart';
import 'package:meta/meta.dart';

part 'get_users_state.dart';

class GetUsersCubit extends Cubit<GetUsersState> {

  FirestoreHelper fireStoreHelper = FirestoreHelper();
  List<User> users = [];

  GetUsersCubit() : super(GetUsersInitial());

  List<User> getUsers() {
    fireStoreHelper.getUsers().then((state){
      if(state.isError){
        return [];
      }else{
        users = state.data as List<User>;
        emit(GetUsersLoaded(users));
        return state.data as List<User>;
      }
    });

    return users;
  }
}