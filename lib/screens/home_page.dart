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
import 'package:ebook/widgets/myAlert.dart';
import 'package:ebook/widgets/voiceDialog.dart';
import 'package:flutter/material.dart';

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

  final player = AudioPlayer();
  String voiceButtonText = "Play voice";
  Future<void> playAudioFromUrl(String url) async {
    await player.play(UrlSource(url));
  }

  TextEditingController reviewController = TextEditingController();
  SharredPrefsHelper sharredPrefsHelper = SharredPrefsHelper();

  Future<List<Book>> getBooks(List<String> filters) async {
    FirestoreHelper firestoreHelper = FirestoreHelper();
    return await firestoreHelper.getBooks().then((value){
      if(value.isError){
        ToastHelper.showMyToast("Error while loading books");
        return [];
      }else{
        if(filters.isEmpty){
          return value.data as List<Book>;
        }else{
          List<Book> books = [];
          for (var element in (value.data as List<Book>)) {
            var cats = element.category!.split(",");
            for (var cat in cats) {
              if(filters.contains(cat)){
                books.add(element);
                break;
              }
            }
          }
          return books;
        }

      }
    });
  }

  late bool isAdmin;



  @override
  void initState() {
    isAdmin = widget.user.role == admin;
    chosenFilters = List.generate(bookCategories.length, (index) => false);
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
            await Navigator.of(context).pushNamed(addBook,arguments: [widget.user,null]);
            setState(() {});
          }, icon: const Icon(Icons.library_add,color: Colors.white,size: 35),
          ),
          IconButton(onPressed: (){
            Navigator.pushNamed(context,usersRequest,arguments: widget.user);
          }, icon: const Icon(Icons.person_add,color: Colors.white,size: 35))
        ]: null,
      ),
      body: FutureBuilder(
        future: getBooks(myFilters),
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
          if(snapshot.hasData){
            if(snapshot.data!.isEmpty){
              return const Center(
                child: Text("There no books"),
              );
            }else{
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        myFilters.isEmpty? const SizedBox.shrink():Container(
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
                                            setState(() {
                                              chosenFilters[bookCategories.indexOf(myFilters[index])] = false;
                                              myFilters.remove(myFilters[index]);
                                            });
                                          },
                                          child: const Icon(Icons.clear,color: Colors.white,),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                              )
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
                              children: List.generate(snapshot.data!.length, (index){
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
                                                image: NetworkImage(snapshot.data![index].coverPageLink.toString()),
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
                                                        snapshot.data![index].name.toString(),
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
                                                              builder: (BuildContext context) {
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
                                                                                              Book book = snapshot.data![index];
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
                                                                              await getBooks(myFilters).then((value){
                                                                                ToastHelper.showMyToast("Books updated");
                                                                              });
                                                                            });
                                                                          },
                                                                        ),
                                                                        ListTile(
                                                                          title: const Text("Update",style: TextStyle(color: Colors.red)),
                                                                          leading: const Icon(Icons.update,color: Colors.red,),
                                                                          onTap: () async {
                                                                            Navigator.of(context).pop(context);
                                                                            await Navigator.of(context).pushNamed(addBook,arguments: [widget.user,snapshot.data![index]]).then((value) async {
                                                                              await getBooks(myFilters);
                                                                              setState(() {});
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
                                                                                  setState(() {
                                                                                    isLoading = true;
                                                                                  });
                                                                                  FirestoreHelper firestore = FirestoreHelper();
                                                                                  FireStorageHelper fireStorege = FireStorageHelper();
                                                                                  await fireStorege.deleteFolder(snapshot.data![index].name.toString()).then((state){
                                                                                    ToastHelper.showMyToast(state.message);
                                                                                    if(!state.isError){
                                                                                      firestore.deleteBook(snapshot.data![index].name.toString()).then((storeState){
                                                                                        ToastHelper.showMyToast(state.message);
                                                                                      });
                                                                                    }
                                                                                  });
                                                                                  await getBooks(myFilters);
                                                                                  setState(() {
                                                                                    isLoading = false;
                                                                                  });
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
                                                          Navigator.of(context).pushNamed(pdfShow,arguments: snapshot.data![index]);
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
                                                              if(widget.user.state == accepted){
                                                               //TODO:Voice
                                                                if(voiceButtonText == "Play voice"){
                                                                  playAudioFromUrl(snapshot.data![index].voiceLink.toString());
                                                                  setState(() {
                                                                    voiceButtonText = "Stop voice";
                                                                  });
                                                                }else{
                                                                  setState(() {
                                                                    voiceButtonText = "Play voice";
                                                                  });
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
                                                            },
                                                            child: Text(voiceButtonText,style: const TextStyle(color: Colors.red),)
                                                        ),
                                                      ),
                                                      const SizedBox(width: 15,),
                                                      snapshot.data![index].voiceLink == "" ?const Text("No voice found for this book",style: TextStyle(color: Colors.white),) : const SizedBox(width: 200,)
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
                                                                if(snapshot.data![index].review != ""){
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
                                                                            children: List.generate(snapshot.data![index].review!.split("#").length, (review){
                                                                              return ListTile(
                                                                                title: Text(snapshot.data![index].review!.split("#")[review]),
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
                                                      snapshot.data![index].review == "" ? const Text("No reviews found for this book",style: TextStyle(color: Colors.white),) : const SizedBox(width: 200,)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10,),
                                              Row(
                                                children: List.generate(snapshot.data![index].category!.split(",").length, (cat){
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
                                                                snapshot.data![index].category!.split(",")[cat],
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
                  isLoading ? const Positioned(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                  ):const SizedBox.shrink()
                ],
              );
            }
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

          setState(() {
            myFilters.clear();
            chosenFilters = resChosenFilters ?? chosenFilters;
            myFilters.addAll(filters);
          });

          await getBooks(myFilters);


        },
        child: const Icon(Icons.filter_alt,color: Colors.red,),
      ),
    );
  }
}