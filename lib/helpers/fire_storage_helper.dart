import 'dart:typed_data';
import 'package:ebook/objects/NetworkState.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStorageHelper{

  final storageRef = FirebaseStorage.instance.ref();

  Future<NetworkState> putFile(Uint8List file,String folderName,String name,String type) async {
    try {

      SettableMetadata metadata = SettableMetadata(
        contentType: ""
      );
      switch(type){
        case "pdf":
          metadata = SettableMetadata(
            contentType: "application/pdf"
          );
          break;
        case "png"||"jpg"||"jpeg":
          metadata = SettableMetadata(
              contentType: "image/$type"
          );
          break;
        case "mp3":
          metadata = SettableMetadata(
              contentType: "audio/$type"
          );
          break;
        default:
          break;
      }

      await storageRef.child("$folderName/$name.$type").putData(file,metadata);
      String url = await storageRef.child("$folderName/$name.$type").getDownloadURL();
      return NetworkState(false, "File updated", url);
    } on FirebaseException catch (e) {
      return NetworkState(true, e.code, null);
    }
  }

  Future<NetworkState> deleteFolder(String name) async {
    try{
      ListResult list = await storageRef.child("$name/").listAll();
      for (var item in list.items) {
        await item.delete();
      }
      return NetworkState(false, "Book files Deleted", null);
    } on FirebaseException catch (e) {
      return NetworkState(true, e.code, null);
    }
    catch(e){
      return NetworkState(true, "Error while deleting book", null);
    }
  }

  Future<NetworkState> deleteBookFile(String name) async {
    try{
      ListResult list = await storageRef.child("$name/").listAll();
      for (var item in list.items) {
        if(item.name.split(".").last == "pdf"){
          await item.delete();
        }
      }
      return NetworkState(false, "Book file Deleted", null);
    } on FirebaseException catch (e) {
      return NetworkState(true, e.code, null);
    }
    catch(e){
      return NetworkState(true, "Error while deleting book file", null);
    }
  }

  Future<NetworkState> deleteVoiceFile(String name) async {
    try{
      ListResult list = await storageRef.child("$name/").listAll();
      for (var item in list.items) {
        if(item.name.split(".").last == "mp3"){
          await item.delete();
        }
      }
      return NetworkState(false, "Voice file Deleted", null);
    } on FirebaseException catch (e) {
      return NetworkState(true, e.code, null);
    }
    catch(e){
      return NetworkState(true, "Error while deleting voice file", null);
    }
  }

  Future<NetworkState> deleteCoverFile(String name) async {
    try{
      ListResult list = await storageRef.child("$name/").listAll();
      for (var item in list.items) {
        if(item.name.split(".").last == "png" ||item.name.split(".").last == "jpg" ||item.name.split(".").last == "jpeg"){
          await item.delete();
        }
      }
      return NetworkState(false, "Cover file Deleted", null);
    } on FirebaseException catch (e) {
      return NetworkState(true, e.code, null);
    }
    catch(e){
      return NetworkState(true, "Error while deleting cover file", null);
    }
  }


}