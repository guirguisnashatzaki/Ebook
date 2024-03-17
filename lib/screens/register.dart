import 'package:ebook/helpers/firestore_helper.dart';
import 'package:ebook/models/User.dart';
import 'package:ebook/view_models/register_page/register_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../helpers/auth_helper.dart';
import '../helpers/sharred_prefs_helper.dart';
import '../helpers/toastHelper.dart';
import '../objects/NetworkState.dart';
import '../view_models/loading_cubit.dart';
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

                            BlocProvider.of<LoadingCubit>(context).setIsLoading(true);

                            String email = emailController.text.toString();
                            String pass = passController.text.toString();
                            String username = usernameController.text.toString();
                            String confirmPass = confirmPassController.text.toString();

                            BlocProvider.of<RegisterCubit>(context).validate(email, pass, username, confirmPass);

                            Future.delayed(
                              const Duration(seconds: 1),
                                  () => BlocProvider.of<LoadingCubit>(context).setIsLoading(false),
                            );

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

            BlocBuilder<RegisterCubit,RegisterState>(
              builder: (BuildContext context, state) {
                if(state is RegisterValidationError){
                  ToastHelper.showMyToast("One of the fields are empty");
                }

                if(state is RegisterPasswordError){
                  ToastHelper.showMyToast("Passwords are not the same");
                }

                if(state is RegisterValidated){
                  ToastHelper.showMyToast("User got");
                  Future.delayed(
                    const Duration(seconds: 1),
                        () => Navigator.popAndPushNamed(context, home,arguments: (state).state.data as User),
                  );
                }

                if(state is RegisterError){
                  ToastHelper.showMyToast("Registration Error");
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}