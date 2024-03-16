import 'dart:typed_data';
import 'package:ebook/helpers/fire_storage_helper.dart';
import 'package:ebook/helpers/firestore_helper.dart';
import 'package:ebook/models/Book.dart';
import 'package:ebook/models/User.dart';
import 'package:ebook/widgets/custom_text_form_field_disabled.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../helpers/toastHelper.dart';
import '../widgets/custom_text_form_field.dart';

class AddBook extends StatefulWidget {
  User user;
  Book? book;
  AddBook({Key? key,required this.user,this.book}) : super(key: key);

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {

  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  String title = "Add Book";
  String bookName = "Add book pdf";
  String coverName = "Add cover";
  String voiceName = "Add voice (Optional)";
  bool nameEnabled = true;
  String? bookLink;
  String? coverLink;
  String? voiceLink;
  String buttonText = "Add";
  bool isLoading = false;
  Uint8List? book;
  Uint8List? coverPage;
  Uint8List? voice;

  List<String> categories = [];
  List bookCategories = [
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

  @override
  void initState() {
    if(widget.book != null){
      nameController.text = widget.book!.name.toString();
      authorController.text = widget.book!.authorName.toString();
      nameEnabled = false;
      categories.addAll(widget.book!.category!.split(","));
      title = "Update Book";
      buttonText = "Update";
      bookName = "Add another book pdf or leave it";
      coverName = "Add another cover or leave it";
      voiceName = "Add another voice or leave it";
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    authorController.dispose();
    super.dispose();
  }

  pickPdfBook() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf'
      ]
    );

    if (result != null) {
      book = result.files.first.bytes;
      setState(() {
        bookName = result.files.first.name;
      });
    }
  }

  pickCoverPage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg','png','jpeg'
        ]
    );

    if (result != null) {
      coverPage = result.files.first.bytes;
      setState(() {
        coverName = result.files.first.name;
      });
    }
  }

  pickVoice() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'mp3'
        ]
    );

    if (result != null) {
      voice = result.files.first.bytes;
      setState(() {
        voiceName = result.files.first.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/5,vertical: MediaQuery.of(context).size.height/8),
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.red,
                Colors.white
              ]
          ),
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(
                    color: Colors.white,
                    width: 1
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 7
                  )
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(child: Text(title,style: const TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.red),)),
                    const SizedBox(height: 20,),
                    customTextFormFieldDiabled(controller: nameController, icon: const Icon(Icons.email), text: "Name", isPass: false, enabled: nameEnabled,),
                    customTextFormField(controller: authorController, icon: const Icon(Icons.person), text: "Author Name", isPass: false),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.all(25),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                await pickPdfBook();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.upload),
                                    Text("Add file")
                                  ],
                                ),
                              )
                            ),
                            const SizedBox(width: 10,),
                            Text(bookName),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.all(25),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () async {
                                  await pickCoverPage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 1
                                      ),
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.upload),
                                      Text("Add file")
                                    ],
                                  ),
                                )
                            ),
                            const SizedBox(width: 10,),
                            Text(coverName),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.all(25),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () async {
                                  await pickVoice();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 1
                                      ),
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.upload),
                                      Text("Add file")
                                    ],
                                  ),
                                )
                            ),
                            const SizedBox(width: 10,),
                            Text(voiceName),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.all(25),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                width: 1
                            ),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
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
                                            children: List.generate(bookCategories.length, (index){
                                              return ListTile(
                                                title: Text(bookCategories[index].toString()),
                                                onTap: (){
                                                  categories.add(bookCategories[index]);
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                              );
                                            }),
                                          ),
                                        ),
                                      );
                                    },
                                );
                              },
                                child: const Icon(Icons.add_circle_outline)
                            ),
                            const SizedBox(width: 20,),
                            categories.isEmpty? const Text("Add Categories") :Row(
                              children: List.generate(categories.length, (index){
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
                                        categories[index],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          categories.remove(categories[index]);
                                          setState(() {});
                                        },
                                        child: const Icon(Icons.clear,color: Colors.white,),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                    ),

                    Center(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.red),
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15,horizontal: 20))
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });

                            if(widget.book == null){
                              String name = nameController.text.toString();
                              String author = authorController.text.toString();

                              if(author.isEmpty || name.isEmpty || book == null || coverPage == null || categories.isEmpty){
                                ToastHelper.showMyToast("One of the fields are empty");
                              }else{
                                FireStorageHelper fireStorageHelper = FireStorageHelper();
                                await fireStorageHelper.putFile(book!, name,bookName, bookName.split(".").last).then((bookState) async {
                                  if(bookState.isError){
                                    ToastHelper.showMyToast("Error while uploading book pdf");
                                  }else{
                                    ToastHelper.showMyToast("Book uploaded");
                                    bookLink = bookState.data as String;
                                    await fireStorageHelper.putFile(coverPage!,name, coverName, coverName.split(".").last).then((coverState) async {
                                      if(coverState.isError){
                                        ToastHelper.showMyToast("Error while uploading cover");
                                      }else{
                                        ToastHelper.showMyToast("Cover page uploaded");
                                        coverLink = coverState.data as String;
                                        if(voice != null){
                                          await fireStorageHelper.putFile(voice!, name,voiceName, voiceName.split(".").last).then((voiceState){
                                            if(voiceState.isError){
                                              ToastHelper.showMyToast("Error while uploading voice");
                                            }else{
                                              ToastHelper.showMyToast("Voice uploaded");
                                              voiceLink = voiceState.data as String;
                                            }
                                          });
                                        }

                                        FirestoreHelper fireStoreHelper = FirestoreHelper();

                                        Book book = Book(
                                            name: name,
                                            voiceLink: voiceLink ?? "",
                                            review: "",
                                            category: categories.join(","),
                                            coverPageLink: coverLink ?? "",
                                            bookLink:  bookLink ?? "",
                                            authorName: author
                                        );

                                        await fireStoreHelper.addBook(book).then((addBookState){
                                          ToastHelper.showMyToast(addBookState.message);
                                          if(!addBookState.isError){
                                            Navigator.pop(context);
                                          }
                                        });

                                      }

                                    });
                                  }

                                });
                              }

                              setState(() {
                                isLoading = false;
                              });
                            }else{
                              String name = nameController.text.toString();
                              String author = authorController.text.toString();
                              FireStorageHelper fireStorage = FireStorageHelper();
                              FirestoreHelper firestore = FirestoreHelper();

                              Book myBook = Book(
                                  authorName: author,
                                  name: name,
                                  bookLink: widget.book!.bookLink,
                                  coverPageLink: widget.book!.coverPageLink,
                                  voiceLink: widget.book!.voiceLink,
                                category: widget.book!.category,
                                review: widget.book!.review
                              );

                              if(author.isEmpty || categories.isEmpty){
                                ToastHelper.showMyToast("Don't leave author name or the categories empty");
                              }else{
                                if(book != null){
                                  await fireStorage.deleteBookFile(name).then((state) async {
                                    ToastHelper.showMyToast(state.message);
                                    if(!state.isError){
                                      await fireStorage.putFile(book!, name, bookName, "pdf").then((addBookState){
                                        ToastHelper.showMyToast(addBookState.message);
                                        if(!addBookState.isError){
                                          myBook.bookLink = addBookState.data as String;
                                        }
                                      });
                                    }
                                  });
                                }

                                if(coverPage != null){
                                  await fireStorage.deleteCoverFile(name).then((state) async {
                                    ToastHelper.showMyToast(state.message);
                                    if(!state.isError){
                                      await fireStorage.putFile(coverPage!, name, coverName, coverName.split(".").last).then((addCoverState){
                                        ToastHelper.showMyToast(addCoverState.message);
                                        if(!addCoverState.isError){
                                          myBook.coverPageLink = addCoverState.data as String;
                                        }
                                      });
                                    }
                                  });
                                }

                                if(voice != null && widget.book!.voiceLink!.isEmpty){
                                  await fireStorage.putFile(voice!, name, voiceName, voiceName.split(".").last).then((addVoiceState){
                                    ToastHelper.showMyToast(addVoiceState.message);
                                    if(!addVoiceState.isError){
                                      myBook.voiceLink = addVoiceState.data as String;
                                    }
                                  });
                                }else if(voice != null && widget.book!.voiceLink!.isNotEmpty){
                                  await fireStorage.deleteVoiceFile(name).then((state) async {
                                    ToastHelper.showMyToast(state.message);
                                    if(!state.isError){
                                      await fireStorage.putFile(voice!, name, voiceName, voiceName.split(".").last).then((addVoiceState){
                                        ToastHelper.showMyToast(addVoiceState.message);
                                        if(!addVoiceState.isError){
                                          myBook.voiceLink = addVoiceState.data as String;
                                        }
                                      });
                                    }
                                  });
                                }

                                myBook.category = categories.join(",");

                                await firestore.updateBook(myBook).then((updateState){
                                  ToastHelper.showMyToast(updateState.message);
                                  if(!updateState.isError){
                                    Navigator.of(context).pop();
                                  }
                                });
                              }

                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: Text(buttonText,style: const TextStyle(fontSize: 25,color: Colors.white),)
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
            isLoading ? const Positioned(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            ):const SizedBox.shrink(),
            Positioned(
              top: 40,
              left: 40,
              child: IconButton(
                icon: const Icon(Icons.arrow_back,color: Colors.red,),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
