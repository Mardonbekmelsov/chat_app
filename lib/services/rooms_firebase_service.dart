import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class RoomsFirebaseService {
  final roomsCollection = FirebaseFirestore.instance.collection("rooms");
   final productsImageStorage=FirebaseStorage.instance;

  Stream<DocumentSnapshot> getMessages(String user1, String user2) async* {
    final doc = await roomsCollection.doc(user1 + user2).get();
    if (doc.exists) {
      yield* roomsCollection.doc(user1 + user2).snapshots();
    } else {
      final doc2 = await roomsCollection.doc(user2 + user1).get();
      if (doc2.exists) {
        yield* roomsCollection.doc(user2 + user1).snapshots();
      } else {
        roomsCollection.doc(user2 + user1).set({'messages': []});
        yield* roomsCollection.doc().snapshots();
      }
    }
  }

   void sendMessage(String userId, String message,File? imageFile,String user1, String user2) async {

    if (imageFile!=null){
      final imageReference = productsImageStorage
        .ref()
        .child("messages")
        .child("images")
        .child("$UniqueKey.jpg");
    final uploadTask = imageReference.putFile(
      imageFile,
    );

    uploadTask.snapshotEvents.listen((status) {
      //? faylni yuklash holati
       // running - yuklanmoqda; success - yuklandi; error - xatolik

      //? faylni yuklash foizi
      // double percentage =
      //     (status.bytesTransferred / imageFile.lengthSync()) * 100;

      // print("$percentage%");
    });

    await uploadTask.whenComplete(() async {
      final imageUrl = await imageReference.getDownloadURL();
     final doc= await roomsCollection.doc(user1+user2).get();
    if(doc.exists){
      final messages=doc['messages'];
      messages.add({
        "senderId":userId,
        "message": message,
        "image":imageUrl,
      });
      roomsCollection.doc(user1+user2).set({'messages': messages});
    } else {
      final doc2= await roomsCollection.doc(user2+user1).get();
      final messages=doc2['messages'];
      messages.add({
        "senderId":userId,
        "message": message,
        "image":imageUrl
      });
      roomsCollection.doc(user2+user1).set({'messages': messages});
    }
    });
    } else {
      final doc= await roomsCollection.doc(user1+user2).get();
    if(doc.exists){
      final messages=doc['messages'];
      messages.add({
        "senderId":userId,
        "message": message,
        "image":"noimage"
      });
      roomsCollection.doc(user1+user2).set({'messages': messages});
    } else {
      final doc2= await roomsCollection.doc(user2+user1).get();
      final messages=doc2['messages'];
      messages.add({
        "senderId":userId,
        "message": message,
        "image":"noimage"
      });
      roomsCollection.doc(user2+user1).set({'messages': messages});
    }
    }

    
   }
}
