import 'package:ebook/objects/NetworkState.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthHelper{

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<NetworkState> signUp(String email,String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return NetworkState(false, "You have registered",credential);
    } on FirebaseAuthException catch (e) {
      return NetworkState(true, e.code,null);
    } catch (e) {
      return NetworkState(true, "Error while registering",null);
    }
  }

  Future<NetworkState> logIn(String email,String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return NetworkState(false, "You have Logged in",credential);
    } on FirebaseAuthException catch (e) {
      return NetworkState(true, e.code,null);
    } catch (e) {
      return NetworkState(true, "Error while Logging",null);
    }
  }

  Future<NetworkState> signOut() async {
    try{
      await auth.signOut();
      return NetworkState(false, "You have signed out",null);
    }catch(e){
      return NetworkState(true, "Error while signing out",null);
    }
  }
}


