import 'package:chat_app/services/users_firebase_services.dart';
import 'package:chat_app/views/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final formKey = GlobalKey<FormState>();

  UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();
  bool isLoading = false;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  String? name;
  String? surname;

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });
      try {
        usersFirebaseServices.addUser(userId, name!, surname!);

        Navigator.pushReplacement(
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
        title: const Text("Create Account"),
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
                  labelText: "First Name",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Iltimos ismingizni kiriting";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  //? save email
                  name = newValue;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Last Name",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Iltimos familiyangizni kiriting";
                  }

                  return null;
                },
                onSaved: (newValue) {
                  //? save password
                  surname = newValue;
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
            ],
          ),
        ),
      ),
    );
  }
}
