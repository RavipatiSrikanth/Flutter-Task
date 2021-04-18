import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/screens/login.dart';
import 'package:provider/provider.dart';

import 'blocs/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //     appBarTheme: AppBarTheme(brightness: Brightness.light, elevation: 0),
        //     visualDensity: VisualDensity.adaptivePlatformDensity),
        home: LoginPage(),
      ),
    );
  }
}
