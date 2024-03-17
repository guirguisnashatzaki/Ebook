import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../helpers/firestore_helper.dart';
import '../../models/Book.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {

  FirestoreHelper fireStoreHelper = FirestoreHelper();
  List<Book> books = [];

  BooksCubit() : super(BooksInitial());

  List<Book> getBooks(List<String> filters) {
    fireStoreHelper.getBooks().then((value){
      if(value.isError){
        books = [];
        emit(BooksError(books));
      }else{
        if(filters.isEmpty){
          books = value.data as List<Book>;
          emit(BooksLoaded(books));
        }else{
          List<Book> myBooks = [];
          for (var element in (value.data as List<Book>)) {
            var cats = element.category!.split(",");
            for (var cat in cats) {
              if(filters.contains(cat)){
                myBooks.add(element);
                break;
              }
            }
          }
          books = myBooks;
          emit(BooksLoaded(books));
        }

      }
    });

    return books;
  }

}
