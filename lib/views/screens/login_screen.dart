import 'package:chat_app/services/firebase_auth_services.dart';
import 'package:chat_app/views/screens/main_screen.dart';
import 'package:chat_app/views/screens/reset_password_screen.dart';

import 'register_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  bool isLoading = false;

  String? email;
  String? password;

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      try {
        await firebaseAuthServices.signIn(email!, password!);

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return MainScreen();
            },
          ),
        );
      } on Exception catch (e) {
        String message = e.toString();
        if (e.toString().contains("EMAIL_EXISTS")) {
          message = "Email mavjud";
        }
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Xatolik"),
              content: Text(message),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kirish"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 30),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Elektron pochta",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Iltimos elektron pochtangizni kiriting";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  //? save email
                  email = newValue;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Parol",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Iltimos parolingizni kiriting";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  //? save password
                  password = newValue;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : FilledButton(
                      onPressed: submit,
                      child: const Text("KIRISH"),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return RegisterScreen();
                      },
                    ),
                  );
                },
                child: const Text("Ro'yxatdan O'tish"),
              ),
              const SizedBox(),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordScreen()));
                  },
                  child: const Text(
                    "Reset password",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purpleAccent,
                        fontSize: 18),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
