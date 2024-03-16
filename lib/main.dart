import 'dart:io';

import 'package:ebook/helpers/fire_storage_helper.dart';
import 'package:ebook/objects/NetworkState.dart';
import 'package:ebook/screens/PDFShow.dart';
import 'package:ebook/screens/addBook.dart';
import 'package:ebook/screens/home_page.dart';
import 'package:ebook/screens/landingPage.dart';
import 'package:ebook/screens/login.dart';
import 'package:ebook/screens/register.dart';
import 'package:ebook/screens/user_activation.dart';
import 'package:ebook/view_models/loading_cubit.dart';
import 'package:ebook/view_models/login_page/login_cubit.dart';
import 'package:ebook/view_models/user_activation_page/acceptance_rejection_cubit.dart';
import 'package:ebook/view_models/user_activation_page/get_users_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'constants.dart';
import 'firebase_options.dart';
import 'models/Book.dart';
import 'models/User.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(appRouter: AppRouter(),));
}

class MyApp extends StatelessWidget {
  MyApp({super.key,required this.appRouter});

  final AppRouter appRouter;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}

class AppRouter {

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landingPage:
        return MaterialPageRoute(
            builder: (_) => const LandingPage());
      case login:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (BuildContext context) => LoginCubit(),
                ),
                BlocProvider(
                  create: (BuildContext context) => LoadingCubit(),
                ),
              ],
              child: const Login(),
            ));
      case register:
        return MaterialPageRoute(
            builder: (_) => const Register());
      case home:
        User user = settings.arguments as User;
        return MaterialPageRoute(
            builder: (_) => HomePage(user: user,));
      case addBook:
        User user = (settings.arguments as List)[0] as User;
        Book? book = (settings.arguments as List)[1] as Book;
        return MaterialPageRoute(
            builder: (_) => AddBook(user: user,book: book,));
      case usersRequest:
        User user = settings.arguments as User;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (BuildContext context) => GetUsersCubit(),
                ),
                BlocProvider(
                  create: (BuildContext context) => LoadingCubit(),
                ),
                BlocProvider(
                  create: (BuildContext context) => AcceptanceRejectionCubit(),
                )
              ],
                child: UserActivation(user: user,)
            )
        );
      case pdfShow:
        Book book = settings.arguments as Book;
        return MaterialPageRoute(
            builder: (_) => PDFShow(book: book,));
    }
    return null;
  }
}