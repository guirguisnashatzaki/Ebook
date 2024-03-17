import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../constants.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../helpers/sharred_prefs_helper.dart';
import '../../models/User.dart';
import '../../objects/NetworkState.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {

  bool isValid = false;
  FirestoreHelper firestoreHelper = FirestoreHelper();
  AuthHelper authHelper = AuthHelper();
  SharredPrefsHelper prefs = SharredPrefsHelper();

  RegisterCubit() : super(RegisterInitial());

  validate(String email,String pass,String username,String confirmPass){
    if(email.isEmpty || pass.isEmpty || username.isEmpty || confirmPass.isEmpty){
      emit(RegisterValidationError());
    } else if(pass != confirmPass){
      emit(RegisterPasswordError());
    } else{
      authHelper.signUp(email, pass).then((signUpState){
        if(signUpState.isError){
          emit(RegisterError(signUpState));
        }else{
          User user = User(
              username: username,
              state: pending,
              password: pass,
              role: normalUser,
              email: email
          );
          firestoreHelper.addUser(user).then((state) async {
            if(!state.isError){
              SharredPrefsHelper prefs = SharredPrefsHelper();
              await prefs.login(user.email.toString()).then((value){
                NetworkState myState = state;
                myState.data = user;
                emit(RegisterValidated(myState));
              });
            }else{
              emit(RegisterError(state));
            }
          });
        }
      });
    }
  }
}