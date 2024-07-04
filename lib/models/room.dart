import 'package:cloud_firestore/cloud_firestore.dart';

class Room{
  String roomId;
  List messages;

  Room({required this.roomId, required this.messages});

  factory Room.fromQuery(QueryDocumentSnapshot query){
    return Room(roomId: query.id, messages: query['messages']);
  }
}