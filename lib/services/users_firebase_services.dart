import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersFirebaseServices {
  final userCollection = FirebaseFirestore.instance.collection("users");
  void addUser(String userId, String name, String surname) {
    userCollection.add({
      'userId': userId,
      'name': name,
      'surname': surname,
    });
  }

  Stream<QuerySnapshot> getUsers() async* {
    yield* userCollection.snapshots();
  }

  Future<UserModel> getUserById(String userId) async {
    final user = await userCollection.doc(userId).get();
    return UserModel(
        name: "ashbcjhb", surname: user['surname'], userId: user['userId']);
  }
}
