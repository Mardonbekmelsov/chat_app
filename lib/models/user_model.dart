import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userId;
  String name;
  String surname;

  UserModel({required this.userId, required this.name, required this.surname});

  factory UserModel.fromQuery(QueryDocumentSnapshot query){
    return UserModel(userId: query['userId'], name: query['name'], surname: query['surname']);
  }
}