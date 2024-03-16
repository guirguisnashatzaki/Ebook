import 'package:ebook/helpers/auth_helper.dart';
import 'package:ebook/helpers/sharred_prefs_helper.dart';
import 'package:ebook/helpers/toastHelper.dart';
import 'package:ebook/objects/NetworkState.dart';
import 'package:ebook/view_models/login_page/login_cubit.dart';
import 'package:ebook/widgets/custom_text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../helpers/firestore_helper.dart';
import '../models/User.dart';
import '../view_models/loading_cubit.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
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
                    const Center(child: Text("Login",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.red),)),
                    const SizedBox(height: 20,),
                    customTextFormField(controller: emailController, icon: const Icon(Icons.email), text: "Email", isPass: false),
                    customTextFormField(controller: passController, icon: const Icon(Icons.key), text: "Password", isPass: true),
                    const SizedBox(height: 50,),
                    Center(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.red),
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15,horizontal: 20))
                          ),
                          onPressed: () {

                            BlocProvider.of<LoadingCubit>(context).setIsLoading(true);

                            String email = emailController.text.toString();
                            String pass = passController.text.toString();

                            BlocProvider.of<LoginCubit>(context).validate(email, pass);

                            Future.delayed(
                                const Duration(seconds: 1),
                                () => BlocProvider.of<LoadingCubit>(context).setIsLoading(false),
                            );

                          },
                          child: const Text("Login",style: TextStyle(fontSize: 25,color: Colors.white),)
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: "If you have not registered yet ",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            ),
                            children: [
                              TextSpan(
                                  recognizer:isLoading?null: TapGestureRecognizer()
                                    ?..onTap = () {
                                      Navigator.popAndPushNamed(context, register);
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
            BlocBuilder<LoginCubit,LoginState>(
              builder: (BuildContext context, state) {
                if(state is LoginError){
                  ToastHelper.showMyToast((state).state.message);
                }
                if(state is LoginValidationError){
                  ToastHelper.showMyToast("One of the fields are empty");
                }
                if(state is LoginValidated){
                  ToastHelper.showMyToast("User got");
                  Future.delayed(
                    const Duration(seconds: 1),
                    () => Navigator.popAndPushNamed(context, home,arguments: (state).state.data as User),
                  );
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