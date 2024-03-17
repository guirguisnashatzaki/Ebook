import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ebook/constants.dart';
import 'package:ebook/helpers/auth_helper.dart';
import 'package:ebook/helpers/fire_storage_helper.dart';
import 'package:ebook/helpers/firestore_helper.dart';
import 'package:ebook/helpers/sharred_prefs_helper.dart';
import 'package:ebook/helpers/toastHelper.dart';
import 'package:ebook/models/Book.dart';
import 'package:ebook/models/User.dart';
import 'package:ebook/view_models/home_page/books_cubit.dart';
import 'package:ebook/view_models/home_page/filters_cubit.dart';
import 'package:ebook/view_models/home_page/voice_text_button_cubit.dart';
import 'package:ebook/widgets/myAlert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_models/loading_cubit.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage({Key? key,required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> bookCategories = [
    "Horror",
    "Literary fiction",
    "Mystery",
    "Romance",
    "Science fiction",
    "Fantasy",
    "History",
    "Adventure",
    "Novel",
    "Thriller",
    "Memoir",
    "Short story",
    "Biography",
    "Classics",
    "Religion"
  ];

  List<bool> chosenFilters = [];

  List<String> myFilters = [];

  bool isLoading = false;
  
  List<Book> books = [];

  final player = AudioPlayer();
  String voiceButtonText = "Play voice";
  List<String> voiceTextButtons = [];
  Future<void> playAudioFromUrl(String url) async {
    await player.play(UrlSource(url));
  }

  TextEditingController reviewController = TextEditingController();
  SharredPrefsHelper sharredPrefsHelper = SharredPrefsHelper();

  late bool isAdmin;



  @override
  void initState() {
    isAdmin = widget.user.role == admin;
    chosenFilters = List.generate(bookCategories.length, (index) => false);
    books = BlocProvider.of<BooksCubit>(context).getBooks(myFilters);
    //voiceTextButtons = BlocProvider.of<VoiceTextButtonCubit>(context).setInitialy(List.generate(books.length, (index) => "Play voice"));



    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height/8,
        title: const Text("EBook",style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.red,
        leading: IconButton(
          onPressed: (){
            AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              dialogType: DialogType.error,
              title: "Are you sure you want sign out?",
              btnCancelOnPress: (){},
              btnOkOnPress: () async {
                await sharredPrefsHelper.logout();
                AuthHelper authHelper = AuthHelper();
                await authHelper.signOut().then((state){
                  ToastHelper.showMyToast(state.message);
                  if(!state.isError){
                    Navigator.of(context).popAndPushNamed(landingPage);
                  }
                });
              }
            ).show();
          },
          icon: const Icon(Icons.logout,color: Colors.white,size: 35),
        ),
        centerTitle: true,
        actions: isAdmin ? [
          IconButton(onPressed: () async {
            await Navigator.of(context).pushNamed(addBook,arguments: [widget.user,Book(name: "")]);
            books = BlocProvider.of<BooksCubit>(context).getBooks(myFilters);
            voiceTextButtons = List.generate(books.length, (index) => "Play voice");
          }, icon: const Icon(Icons.library_add,color: Colors.white,size: 35),
          ),
          IconButton(onPressed: (){
            Navigator.pushNamed(context,usersRequest,arguments: widget.user);
          }, icon: const Icon(Icons.person_add,color: Colors.white,size: 35))
        ]: null,
      ),
      body: BlocBuilder<BooksCubit,BooksState>(
        builder: (BuildContext context, state) {
          if(state is BooksError){
            ToastHelper.showMyToast("Error while loading books");
            books = (state).books;
            return const Center(
              child: Text("There no books"),
            );
          }else if(state is BooksLoaded){
            books = (state).books;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [

                      BlocBuilder<FiltersCubit,FiltersState>(
                        builder: (BuildContext context, state) {
                          if(state is FiltersAdded){
                            myFilters = (state).categories;
                          }

                          if(state is FiltersRemoved){
                            myFilters = (state).categories;
                          }

                          books = BlocProvider.of<BooksCubit>(context).getBooks(myFilters);


                          voiceTextButtons = List.generate(books.length, (index) => "Play voice");

                          return myFilters.isEmpty? const SizedBox.shrink():Container(
                            margin: const EdgeInsets.all(25),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: List.generate(myFilters.length, (index){
                                return Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.red,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        myFilters[index],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          chosenFilters[bookCategories.indexOf(myFilters[index])] = false;
                                          myFilters.remove(myFilters[index]);
                                          BlocProvider.of<FiltersCubit>(context).removeCat(myFilters);
                                        },
                                        child: const Icon(Icons.clear,color: Colors.white,),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),


                          );
                        },
                      ),

                      Container(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 2.5,
                              shrinkWrap: true,
                              children: List.generate(books.length, (index){
                                return Container(
                                  height: MediaQuery.of(context).size.height/4,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                          colors: [
                                            Colors.red,
                                            Colors.white
                                          ],
                                          begin: Alignment.centerRight,
                                          end: Alignment.centerLeft
                                      )
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/4,
                                          height: MediaQuery.of(context).size.height/2.4,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(books[index].coverPageLink.toString()),
                                                  fit: BoxFit.fill
                                              ),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width/4,
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  width: MediaQuery.of(context).size.width/4,
                                                  child: FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          books[index].name.toString(),
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 45
                                                          ),
                                                        ),
                                                        widget.user.role == admin ? IconButton(
                                                            onPressed: (){
                                                              showDialog(
                                                                context: context,
                                                                builder: (BuildContext dialogContext) {
                                                                  return AlertDialog(
                                                                    backgroundColor: Colors.white,
                                                                    contentPadding: const EdgeInsets.all(0),
                                                                    content: Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          borderRadius: BorderRadius.circular(20)
                                                                      ),
                                                                      width: MediaQuery.of(context).size.width/3,
                                                                      height: MediaQuery.of(context).size.height/4,
                                                                      padding: const EdgeInsets.all(10),
                                                                      child: ListView(
                                                                        children: [
                                                                          ListTile(
                                                                            title: const Text("Add Review",style: TextStyle(color: Colors.red),),
                                                                            leading: const Icon(Icons.comment,color: Colors.red,),
                                                                            onTap:(){
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    contentPadding: const EdgeInsets.all(0),
                                                                                    content: Container(
                                                                                      padding: const EdgeInsets.all(10),
                                                                                      decoration: BoxDecoration(
                                                                                          color: Colors.white,
                                                                                          borderRadius: BorderRadius.circular(20)
                                                                                      ),
                                                                                      child: TextFormField(
                                                                                        controller: reviewController,
                                                                                        decoration: InputDecoration(
                                                                                            border: InputBorder.none,
                                                                                            hintText: "Add Review",
                                                                                            suffixIconColor: Colors.red,
                                                                                            suffix: IconButton(
                                                                                              onPressed: () async {
                                                                                                Book book = books[index];
                                                                                                if(book.review!.isEmpty){
                                                                                                  book.review = reviewController.text;
                                                                                                }else{
                                                                                                  book.review = "${book.review!}#${reviewController.text}";
                                                                                                }
                                                                                                FirestoreHelper firestoreHelper = FirestoreHelper();
                                                                                                await firestoreHelper.updateBook(book).then((value){
                                                                                                  if(!value.isError){
                                                                                                    ToastHelper.showMyToast("Review added");
                                                                                                    Navigator.of(context).pop();
                                                                                                  }
                                                                                                });
                                                                                              },
                                                                                              icon: const Icon(Icons.check,color: Colors.red,),
                                                                                            )
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              ).then((value) async {
                                                                                books = BlocProvider.of<BooksCubit>(context).getBooks(myFilters);
                                                                                voiceTextButtons = List.generate(books.length, (index) => "Play voice");
                                                                                // await getBooks(myFilters).then((value){
                                                                                //   ToastHelper.showMyToast("Books updated");
                                                                                // });
                                                                              });
                                                                            },
                                                                          ),
                                                                          ListTile(
                                                                            title: const Text("Update",style: TextStyle(color: Colors.red)),
                                                                            leading: const Icon(Icons.update,color: Colors.red,),
                                                                            onTap: () async {
                                                                              Navigator.of(context).pop(context);
                                                                              await Navigator.of(context).pushNamed(addBook,arguments: [widget.user,books[index]]).then((value) async {
                                                                                books = BlocProvider.of<BooksCubit>(context).getBooks(myFilters);
                                                                                voiceTextButtons = List.generate(books.length, (index) => "Play voice");
                                                                              });
                                                                            },
                                                                          ),
                                                                          ListTile(
                                                                            title: const Text("Delete",style: TextStyle(color: Colors.red)),
                                                                            leading: const Icon(Icons.delete,color: Colors.red,),
                                                                            onTap: (){
                                                                              //TODO

                                                                              AwesomeDialog(
                                                                                  context: context,
                                                                                  animType: AnimType.scale,
                                                                                  dialogType: DialogType.error,
                                                                                  title: "Are you sure you want delete this book?",
                                                                                  btnCancelOnPress: (){},
                                                                                  btnOkOnPress: () async {
                                                                                    Navigator.pop(context);
                                                                                    BlocProvider.of<LoadingCubit>(context).setIsLoading(true);
                                                                                    FirestoreHelper firestore = FirestoreHelper();
                                                                                    FireStorageHelper fireStorege = FireStorageHelper();
                                                                                    await fireStorege.deleteFolder(books[index].name.toString()).then((state){
                                                                                      if(!state.isError){
                                                                                        firestore.deleteBook(books[index].name.toString()).then((storeState){
                                                                                          ToastHelper.showMyToast(state.message);
                                                                                        });
                                                                                      }
                                                                                    });

                                                                                    Future.delayed(
                                                                                      const Duration(seconds: 1),
                                                                                          (){
                                                                                            books = BlocProvider.of<BooksCubit>(context).getBooks(myFilters);
                                                                                          },
                                                                                    );


                                                                                    voiceTextButtons = List.generate(books.length, (index) => "Play voice");
                                                                                    Future.delayed(
                                                                                      const Duration(seconds: 1),
                                                                                          () => BlocProvider.of<LoadingCubit>(context).setIsLoading(false),
                                                                                    );
                                                                                  }
                                                                              ).show();
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            icon: const Icon(Icons.settings,color: Colors.white,)
                                                        ) : const SizedBox.shrink()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10,),
                                                Container(
                                                  alignment: Alignment.centerLeft,
                                                  width: MediaQuery.of(context).size.width/4,
                                                  child: FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: ElevatedButton(
                                                        onPressed: (){
                                                          if(widget.user.state == accepted){
                                                            Navigator.of(context).pushNamed(pdfShow,arguments: books[index]);
                                                          }else{
                                                            AwesomeDialog(
                                                              context: context,
                                                              dialogType: DialogType.info,
                                                              title: 'Your account has not been activated yet',
                                                              btnCancelOnPress: () {},
                                                            ).show();
                                                          }
                                                        },
                                                        child: const Text("Show PDF",style: TextStyle(color: Colors.red),)
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10,),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width/4,
                                                  height: 35,
                                                  child: FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          child: ElevatedButton(
                                                              onPressed: () async {

                                                                if(books[index].voiceLink != ""){
                                                                  if(widget.user.state == accepted){
                                                                    //TODO:Voice
                                                                    if(voiceTextButtons[index] == "Play voice"){
                                                                      playAudioFromUrl(books[index].voiceLink.toString());
                                                                      BlocProvider.of<VoiceTextButtonCubit>(context).flipText(index,voiceTextButtons);
                                                                    }else{
                                                                      BlocProvider.of<VoiceTextButtonCubit>(context).flipText(index,voiceTextButtons);
                                                                      player.pause();
                                                                    }
                                                                  }else{
                                                                    AwesomeDialog(
                                                                      context: context,
                                                                      dialogType: DialogType.info,
                                                                      title: 'Your account has not been activated yet',
                                                                      btnCancelOnPress: () {},
                                                                    ).show();
                                                                  }
                                                                }


                                                              },
                                                              child: BlocBuilder<VoiceTextButtonCubit,VoiceTextButtonState>(
                                                                builder: (BuildContext context, state) {
                                                                  if(state is VoiceTextButtonPlay){
                                                                    voiceTextButtons = (state).voiceTextButtons;
                                                                  }else if(state is VoiceTextButtonStop){
                                                                    voiceTextButtons = (state).voiceTextButtons;
                                                                  }else if(state is VoiceTextButtonInit){
                                                                    voiceTextButtons = (state).voiceTextButtons;
                                                                  }else{
                                                                    voiceTextButtons = List.generate(books.length, (index) => "Play voice");
                                                                  }
                                                                  return Text(voiceTextButtons[index],style: const TextStyle(color: Colors.red),);
                                                                },
                                                              )
                                                          ),
                                                        ),
                                                        const SizedBox(width: 15,),
                                                        books[index].voiceLink == "" ?const Text("No voice found for this book",style: TextStyle(color: Colors.white),) : const SizedBox(width: 200,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10,),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width/4,
                                                  height: 35,
                                                  child: FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.centerLeft,
                                                          child: ElevatedButton(
                                                              onPressed: (){
                                                                if(widget.user.state == accepted){
                                                                  if(books[index].review != ""){
                                                                    showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        return AlertDialog(
                                                                          backgroundColor: Colors.transparent,
                                                                          alignment: Alignment.bottomCenter,
                                                                          content: Container(
                                                                            width: MediaQuery.of(context).size.width,
                                                                            height: MediaQuery.of(context).size.height/2,
                                                                            decoration: const BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                                                            ),
                                                                            child: ListView(
                                                                              children: List.generate(books[index].review!.split("#").length, (review){
                                                                                return ListTile(
                                                                                  title: Text(books[index].review!.split("#")[review]),
                                                                                );
                                                                              }),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                }else{
                                                                  AwesomeDialog(
                                                                    context: context,
                                                                    dialogType: DialogType.info,
                                                                    title: 'Your account has not been activated yet',
                                                                    btnCancelOnPress: () {},
                                                                  ).show();
                                                                }
                                                              },
                                                              child: const Text("Reviews",style: TextStyle(color: Colors.red),)
                                                          ),
                                                        ),
                                                        const SizedBox(width: 15,),
                                                        books[index].review == "" ? const Text("No reviews found for this book",style: TextStyle(color: Colors.white),) : const SizedBox(width: 200,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10,),
                                                Row(
                                                  children: List.generate(books[index].category!.split(",").length, (cat){
                                                    return Container(
                                                      margin: const EdgeInsets.only(right: 5),
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(15),
                                                        color: Colors.white,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            books[index].category!.split(",")[cat],
                                                            style: const TextStyle(
                                                                color: Colors.red,
                                                                fontSize: 20
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<LoadingCubit,LoadingState>(
                  builder: (BuildContext context, LoadingState state) {
                    if(state is Loading){
                      isLoading = (state).isLoading;
                    }else if(state is LoadingStopped){
                      isLoading = (state).isLoading;
                    }
                    return isLoading ? const Positioned(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      ),
                    ):const SizedBox.shrink();
                  },
                ),
              ],
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          List<bool>? resChosenFilters = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return FilterAlert(
                bookCategories: bookCategories,
                chosenFilters: chosenFilters,
              );
            },
          );

          List<String> filters = [];
          int index = 0;
          for (var element in resChosenFilters!) {
            if(element){
              filters.add(bookCategories[index]);
            }
            index++;
          }

          myFilters.clear();
          chosenFilters = resChosenFilters ?? chosenFilters;

          BlocProvider.of<FiltersCubit>(context).addCat(filters);
        },
        child: const Icon(Icons.filter_alt,color: Colors.red,),
      ),
    );
  }
}