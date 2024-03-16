import 'package:ebook/helpers/firestore_helper.dart';
import 'package:ebook/models/User.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../helpers/auth_helper.dart';
import '../helpers/sharred_prefs_helper.dart';
import '../helpers/toastHelper.dart';
import '../objects/NetworkState.dart';
import '../widgets/custom_text_form_field.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    usernameController.dispose();
    confirmPassController.dispose();
    super.dispose();
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
                    const Center(child: Text("Register",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.red),)),
                    const SizedBox(height: 20,),
                    customTextFormField(controller: emailController, icon: const Icon(Icons.email), text: "Email", isPass: false),
                    customTextFormField(controller: usernameController, icon: const Icon(Icons.person), text: "Username", isPass: false),
                    customTextFormField(controller: passController, icon: const Icon(Icons.key), text: "Password", isPass: true),
                    customTextFormField(controller: confirmPassController, icon: const Icon(Icons.key), text: "Confirm Password", isPass: true),
                    const SizedBox(height: 50,),
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

                            String email = emailController.text.toString();
                            String pass = passController.text.toString();
                            String username = usernameController.text.toString();
                            String confirmPass = confirmPassController.text.toString();

                            if(email.isEmpty || pass.isEmpty || username.isEmpty || confirmPass.isEmpty){
                              ToastHelper.showMyToast("One of the fields are empty");
                            } else if(pass != confirmPass){
                              ToastHelper.showMyToast("Passwords are not the same");
                            } else{
                              AuthHelper authHelper = AuthHelper();
                              NetworkState registerState = await authHelper.signUp(email, pass);

                              ToastHelper.showMyToast(registerState.message);

                              if(!registerState.isError){
                                FirestoreHelper firestoreHelper = FirestoreHelper();

                                User user = User(
                                  username: username,
                                  state: pending,
                                  password: pass,
                                  role: normalUser,
                                  email: email
                                );

                                firestoreHelper.addUser(user).then((state) async {

                                  ToastHelper.showMyToast(state.message);

                                  if(!state.isError){
                                    SharredPrefsHelper prefs = SharredPrefsHelper();
                                    await prefs.login(user.email.toString()).then((value){
                                      Navigator.popAndPushNamed(context, home,arguments: user);
                                    });
                                  }
                                });
                              }

                            }

                            setState(() {
                              isLoading = false;
                            });

                          },
                          child: const Text("Register",style: TextStyle(fontSize: 25,color: Colors.white),)
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: "If you have an account ",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            ),
                            children: [
                              TextSpan(
                                  recognizer:isLoading?null: TapGestureRecognizer()
                                    ?..onTap = () {
                                      Navigator.popAndPushNamed(context, login);
                                    },
                                  text: "Click here",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red,
                                      decoration: TextDecoration.underline))
                            ]),
                      ),
                    )
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
            ):const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}