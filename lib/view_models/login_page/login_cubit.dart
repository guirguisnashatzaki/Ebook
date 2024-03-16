import 'package:bloc/bloc.dart';
import 'package:ebook/helpers/firestore_helper.dart';
import 'package:meta/meta.dart';

import '../../helpers/auth_helper.dart';
import '../../helpers/sharred_prefs_helper.dart';
import '../../models/User.dart';
import '../../objects/NetworkState.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {

  bool isValid = false;
  FirestoreHelper firestoreHelper = FirestoreHelper();
  AuthHelper authHelper = AuthHelper();
  SharredPrefsHelper prefs = SharredPrefsHelper();

  LoginCubit() : super(LoginInitial());

  validate(String email,String pass) {
    if(email.isEmpty || pass.isEmpty){
      emit(LoginValidationError());
    }else{
      authHelper.logIn(email, pass).then((loginState){

        if(!loginState.isError){
          firestoreHelper.getUserByEmail(email).then((state) async {

            if(!state.isError){
              await prefs.getPrefs();
              await prefs.login((state.data as User).email.toString()).then((value){
                emit(LoginValidated(state));
              });
            }else{
              emit(LoginError(state));
            }
          });
        }else{
          emit(LoginError(loginState));
        }
      });


    }
  }


}
