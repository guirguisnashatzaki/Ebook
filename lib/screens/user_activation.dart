import 'package:ebook/constants.dart';
import 'package:ebook/helpers/firestore_helper.dart';
import 'package:ebook/helpers/toastHelper.dart';
import 'package:ebook/view_models/loading_cubit.dart';
import 'package:ebook/view_models/user_activation_page/acceptance_rejection_cubit.dart';
import 'package:ebook/view_models/user_activation_page/get_users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/User.dart';

class UserActivation extends StatefulWidget {
  User user;
  UserActivation({Key? key,required this.user}) : super(key: key);

  @override
  State<UserActivation> createState() => _UserActivationState();
}

class _UserActivationState extends State<UserActivation> {

  Map<String,Color> colors = {
    pending : Colors.black,
    accepted : Colors.green,
    rejected : Colors.red
  };

  bool isLoading = false;
  late List<User> users;

  @override
  void initState() {
    users = BlocProvider.of<GetUsersCubit>(context).getUsers();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height/8,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.red,
        title: const Text("Users Requests",style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),

      body: Stack(
        children: [
          BlocBuilder<GetUsersCubit,GetUsersState>(
            builder: (BuildContext context, GetUsersState state) {
              if(state is GetUsersLoaded){
                users = (state).users;
                if(users.isEmpty){
                  return const Center(
                    child: Text(
                        "There is no users"
                    ),
                  );
                }else{
                  return Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: List.generate(users.length, (index){
                        return users[index].role == admin ? const SizedBox.shrink() :
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.white
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(users[index].username.toString(),
                                style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Row(
                                children: [
                                  Text(users[index].state.toString(),
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: colors[users[index].state],
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  users[index].state == pending ? const SizedBox(width: 50,):const SizedBox.shrink(),
                                  users[index].state == pending ? Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green
                                    ),
                                    child: IconButton(onPressed: (){
                                      BlocProvider.of<LoadingCubit>(context).setIsLoading(true);
                                      User user = User(
                                          email: users[index].email,
                                          role: users[index].role,
                                          password: users[index].password,
                                          username: users[index].username,
                                          state: accepted
                                      );

                                      FirestoreHelper firestoreHelper = FirestoreHelper();
                                      firestoreHelper.updateUser(user).then((value){
                                        if(value.isError){
                                          ToastHelper.showMyToast("Activation Failed");
                                        }else{
                                          ToastHelper.showMyToast("Activation Succeed");
                                        }
                                        BlocProvider.of<LoadingCubit>(context).setIsLoading(false);
                                        users = BlocProvider.of<GetUsersCubit>(context).getUsers();
                                      });

                                    }, icon: const Icon(Icons.check,color: Colors.white,)),
                                  ): const SizedBox.shrink(),
                                  users[index].state == pending ? const SizedBox(width: 10,): const SizedBox.shrink(),
                                  users[index].state == pending ? Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red
                                    ),
                                    child: IconButton(onPressed: (){

                                      BlocProvider.of<LoadingCubit>(context).setIsLoading(true);

                                      User user = User(
                                          email: users[index].email,
                                          role: users[index].role,
                                          password: users[index].password,
                                          username: users[index].username,
                                          state: rejected
                                      );

                                      FirestoreHelper firestoreHelper = FirestoreHelper();
                                      firestoreHelper.updateUser(user).then((value){
                                        if(value.isError){
                                          ToastHelper.showMyToast("Rejection Failed");
                                        }else{
                                          ToastHelper.showMyToast("Rejection Succeed");
                                        }
                                        BlocProvider.of<LoadingCubit>(context).setIsLoading(false);
                                        users = BlocProvider.of<GetUsersCubit>(context).getUsers();
                                      });
                                    }, icon: const Icon(Icons.clear,color: Colors.white,)),
                                  ): const SizedBox.shrink(),
                                ],
                              )

                            ],
                          ),
                        );
                      }),
                    ),
                  );
                }
              }else{
                return const Center(child: CircularProgressIndicator(color: Colors.red,));
              }
            },
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
          )
        ],
      ),

    );
  }
}