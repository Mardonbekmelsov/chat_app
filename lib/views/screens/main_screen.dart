import 'dart:math';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/firebase_auth_services.dart';
import 'package:chat_app/services/users_firebase_services.dart';
import 'package:chat_app/views/screens/chat_room_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final UsersFirebaseServices usersFirebaseServices = UsersFirebaseServices();
  String? curUser;

  Future<void> setUser() async {
    curUser = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  void initState() {
    super.initState();

    setUser().then((value) {
      setState(() {});
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Screen"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuthServices.logout();
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: curUser == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: usersFirebaseServices.getUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("Userlar topilmadi"),
                  );
                }

                final users = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = UserModel.fromQuery(users[index]);
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatRoomScreen(
                                    user1: curUser!, user2: user)));
                      },
                      minTileHeight: 65,
                      leading: Container(
                        height: 50,
                        width: 50,
                        // clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(
                                255,
                                Random().nextInt(255),
                                170 + Random().nextInt(85),
                                Random().nextInt(255)),
                            shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "${user.name[0]}${user.surname[0]}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      title: curUser! == user.userId
                          ? const Text(
                              "Saved Messages",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w900),
                            )
                          : Text(
                              user.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w900),
                            ),
                    );
                  },
                );
              }),
    );
  }
}
