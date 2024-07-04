import 'package:chat_app/services/firebase_auth_services.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final FirebaseAuthServices firebaseAuth = FirebaseAuthServices();

  ResetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: "Enter Email"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              firebaseAuth.resetPassword(emailController.text);
              Navigator.pop(context);
            },
            child: const Text("Send Link"),
          ),
        ],
      ),
    );
  }
}