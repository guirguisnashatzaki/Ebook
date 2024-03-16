import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String? name;
  String? authorName;
  String? coverPageLink;
  String? bookLink;
  String? category;
  String? review;
  String? voiceLink;

  Book({this.name, this.authorName, this.coverPageLink, this.bookLink,this.category,this.review,this.voiceLink});

  factory Book.fromDocument(DocumentSnapshot snapshot){
    String name = "";
    String authorName = "";
    String coverPageLink = "";
    String bookLink = "";
    String category = "";
    String review = "";
    String voiceLink = "";


    try{
      name = snapshot.get("name");
    }catch(e){}

    try{
      authorName = snapshot.get("authorName");
    }catch(e){}

    try{
      coverPageLink = snapshot.get("coverPageLink");
    }catch(e){}

    try{
      bookLink = snapshot.get("bookLink");
    }catch(e){}

    try{
      category = snapshot.get("category");
    }catch(e){}

    try{
      review = snapshot.get("review");
    }catch(e){}

    try{
      voiceLink = snapshot.get("voiceLink");
    }catch(e){}

    return Book(
      name: name,
      authorName: authorName,
      bookLink: bookLink,
      coverPageLink: coverPageLink,
      category: category,
      review: review,
      voiceLink: voiceLink
    );
  }

  Map<String, String> toMap() {
    return {
      "name": name ?? "",
      "authorName": authorName ?? "",
      "coverPageLink": coverPageLink ?? "",
      "bookLink": bookLink ?? "",
      "category": category ?? "",
      "review": review ?? "",
      "voiceLink": voiceLink ?? ""
    };
  }
}