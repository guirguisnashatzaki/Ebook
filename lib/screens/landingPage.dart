import 'package:ebook/helpers/auth_helper.dart';
import 'package:ebook/helpers/firestore_helper.dart';
import 'package:ebook/helpers/sharred_prefs_helper.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/User.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  SharredPrefsHelper sharredPrefsHelper = SharredPrefsHelper();

  @override
  Future<void> didChangeDependencies() async {
    await sharredPrefsHelper.getPrefs();
    await sharredPrefsHelper.checkLog().then((value){
      if(value.isNotEmpty){
        FirestoreHelper firestoreHelper = FirestoreHelper();
        firestoreHelper.getUserByEmail(value).then((state){
          if(!state.isError){
            Navigator.of(context).popAndPushNamed(home,arguments: state.data as User);
          }
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/7,vertical: MediaQuery.of(context).size.height/9),
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red,
              Colors.white
            ]
          ),
        ),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Container(
            padding: const EdgeInsets.all(15),
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
            child: Column(
              children: [
                const SizedBox(height: 50,),
                Center(
                  child: RichText(
                    text: const TextSpan(
                      text: "E",
                      style: TextStyle(
                        fontSize: 200,
                        color: Colors.red
                      ),
                      children: [
                        TextSpan(
                          text: "book",
                          style: TextStyle(
                            fontSize: 200,
                            color: Colors.black
                          )
                        )
                      ]
                    ),
                  )
                ),
                const SizedBox(height: 50,),
                const Center(
                  child: Text(
                    "In order to enjoy reading and listening books you have to obtain an account",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15,horizontal: 20))
                        ),
                        onPressed: (){
                          Navigator.of(context).pushNamed(login);
                        },
                        child: const Text("Login",style: TextStyle(fontSize: 25,color: Colors.white),)
                    ),
                    const SizedBox(width: 50,),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15,horizontal: 20))
                        ),
                        onPressed: (){
                          Navigator.of(context).pushNamed(register);
                        },
                        child: const Text("Register",style: TextStyle(fontSize: 25,color: Colors.white),)
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
