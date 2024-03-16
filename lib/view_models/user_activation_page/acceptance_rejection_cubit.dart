import 'package:bloc/bloc.dart';
import 'package:ebook/helpers/firestore_helper.dart';

import 'package:meta/meta.dart';

import '../../models/User.dart';

part 'acceptance_rejection_state.dart';

class AcceptanceRejectionCubit extends Cubit<AcceptanceRejectionState> {

  FirestoreHelper firestoreHelper = FirestoreHelper();

  AcceptanceRejectionCubit() : super(AcceptanceRejectionInitial());

  // acceptOrReject(User user){
  //   String rej = "Rejection";
  //   String acc = "Activation";
  //   firestoreHelper.updateUser(user).then((value){
  //     if(value.isError){
  //       ToastHelper.showMyToast("Rejection Failed");
  //     }else{
  //       ToastHelper.showMyToast("Rejection Succeed");
  //     }
  //   });
  // }

}
