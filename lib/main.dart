import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/views/screens/login_screen.dart';
import 'package:chat_app/views/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
 await  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const LoginScreen();
                  }
                  return const MainScreen();
                }),
          );
  }
}