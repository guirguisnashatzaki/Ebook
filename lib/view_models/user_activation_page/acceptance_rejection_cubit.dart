import 'package:bloc/bloc.dart';
import 'package:ebook/helpers/firestore_helper.dart';

import 'package:meta/meta.dart';

import '../../models/User.dart';

part 'acceptance_rejection_state.dart';

class AcceptanceRejectionCubit extends Cubit<AcceptanceRejectionState> {

  FirestoreHelper firestoreHelper = FirestoreHelper();

  AcceptanceRejectionCubit() : super(AcceptanceRejectionInitial());

  reject(User user){
    firestoreHelper.updateUser(user).then((value){
      if(value.isError){
        emit(AcceptanceRejectionError());
      }else{
        emit(AcceptanceRejectionRejected());
      }
    });
  }

  accept(User user){
    firestoreHelper.updateUser(user).then((value){
      if(value.isError){
        emit(AcceptanceRejectionError());
      }else{
        emit(AcceptanceRejectionAccepted());
      }
    });
  }

}
