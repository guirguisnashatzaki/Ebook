import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook/models/Book.dart';
import 'package:ebook/objects/NetworkState.dart';

import '../models/User.dart';

class FirestoreHelper{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<NetworkState> addUser(User user) async {
    try{
      await firestore.collection("Users").add(user.toMap());
      return NetworkState(false, "User added",null);
    }
    catch(e){
      return NetworkState(true, e.toString(),null);
    }
  }

  Future<NetworkState> addBook(Book book) async {
    try{
      await firestore.collection("Books").add(book.toMap());
      return NetworkState(false, "Book added",null);
    }
    catch(e){
      return NetworkState(true, e.toString(),null);
    }
  }
  
  Future<NetworkState> getBooks() async {
    try{
      QuerySnapshot<Map<String, dynamic>> books = await firestore.collection("Books").get().then((books){
        return books;
      });

      List<Book> myBooks = [];
      for (var element in books.docs) {
        myBooks.add(Book.fromDocument(element));
      }
      return NetworkState(false, "Books downloaded", myBooks);
    }catch(e){
      return NetworkState(true, "Error while getting books", null);
    }
  }

  Future<NetworkState> getUsers() async {
    try{
      QuerySnapshot<Map<String, dynamic>> users = await firestore.collection("Users").get().then((users){
        return users;
      });

      List<User> myUsers = [];
      for (var element in users.docs) {
        myUsers.add(User.fromDocument(element));
      }
      return NetworkState(false, "Books downloaded", myUsers);
    }catch(e){
      return NetworkState(true, "Error while getting books", null);
    }
  }

  Future<String> getUserDocId(String email) async {
    try{
      QuerySnapshot<Map<String, dynamic>> users = await firestore.collection("Users").get().then((users){
        return users;
      });

      String id = "";
      for (var element in users.docs) {
        if(element['email'] == email){
          id = element.id;
        }
      }
      return id;
    }catch(e){
      return "Error";
    }
  }

  Future<String> getBookDocId(String name) async {
    try{
      QuerySnapshot<Map<String, dynamic>> books = await firestore.collection("Books").get().then((books){
        return books;
      });

      String id = "";
      for (var element in books.docs) {
        if(element['name'] == name){
          id = element.id;
        }
      }
      return id;
    }catch(e){
      return "Error";
    }
  }

  Future<NetworkState> updateUser(User user) async {
    try{
      String id = await getUserDocId(user.email.toString());
      await firestore.collection("Users").doc(id).update(user.toMap());
      return NetworkState(false, "User updated",null);
    }
    catch(e){
      return NetworkState(true, e.toString(),null);
    }
  }

  Future<NetworkState> updateBook(Book book) async {
    try{
      String id = await getBookDocId(book.name.toString());
      await firestore.collection("Books").doc(id).update(book.toMap());
      return NetworkState(false, "Book updated",null);
    }
    catch(e){
      return NetworkState(true, e.toString(),null);
    }
  }

  Future<NetworkState> deleteBook(String bookName) async {
    try{
      String id = await getBookDocId(bookName.toString());
      await firestore.collection("Books").doc(id).delete();
      return NetworkState(false, "Book deleted",null);
    }
    catch(e){
      return NetworkState(true, e.toString(),null);
    }
  }

  Future<NetworkState> deleteUser(String userEmail) async {
    try{
      String id = await getUserDocId(userEmail.toString());
      await firestore.collection("Users").doc(id).delete();
      return NetworkState(false, "User deleted",null);
    }
    catch(e){
      return NetworkState(true, e.toString(),null);
    }
  }

  Future<NetworkState> getUserByEmail(String email) async {
    try{
      QuerySnapshot<Map<String, dynamic>> users = await firestore.collection("Users").get().then((users){
        return users;
      });

      User selectedUser = User();
      for (var element in users.docs) {
        if(element['email'] == email){
          selectedUser = User.fromDocument(element);
        }
      }
      return NetworkState(false, "User account data are here", selectedUser);
    }catch(e){
      return NetworkState(true, "Error while getting user", null);
    }
  }
}