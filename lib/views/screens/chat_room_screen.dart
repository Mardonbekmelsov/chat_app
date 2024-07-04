import 'dart:io';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/rooms_firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoomScreen extends StatefulWidget {
  final String user1;
  final UserModel user2;

  const ChatRoomScreen({super.key, required this.user1, required this.user2});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  File? imageFile;
  final RoomsFirebaseService roomsFirebaseService = RoomsFirebaseService();

  final TextEditingController messageController = TextEditingController();

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
        imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        requestFullMetadata: false,
        imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final curUser = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: curUser == widget.user2.userId
              ? const Text(
                  "Saved Messages",
                  style: TextStyle(fontWeight: FontWeight.w900),
                )
              : Text(
                  "${widget.user2.name} ${widget.user2.surname}",
                  style: const TextStyle(fontWeight: FontWeight.w900),
                )),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: roomsFirebaseService.getMessages(
                  widget.user1, widget.user2.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text("xabarlar mavjud emas"),
                  );
                }

                final List messages = snapshot.data!['messages'];
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: message['senderId'] == curUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        message['image'] != 'noimage'
                            ? Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: message['senderId'] == curUser
                                        ? Colors.blue.shade200
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      width: 150,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.network(
                                        message['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    if (message['message'].isNotEmpty)
                                      const SizedBox(
                                        height: 7,
                                      ),
                                    if (message['message'].isNotEmpty)
                                      Text(
                                        message['message'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                  ],
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: message['senderId'] == curUser
                                      ? Colors.blue.shade200
                                      : Colors.grey.shade200,
                                ),
                                child: Text(
                                  message['message'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            // height: 50,
            width: double.infinity,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (imageFile != null)
                  Container(
                    height: 100,
                    width: 100,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: messageController,
                    decoration: InputDecoration(
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.image),
                            onPressed: () {
                              openGallery();
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              openCamera();
                            },
                            icon: const Icon(
                              Icons.camera,
                            ),
                          ),
                        ],
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          roomsFirebaseService.sendMessage(
                              widget.user1,
                              messageController.text,
                              imageFile,
                              widget.user1,
                              widget.user2.userId);
                          messageController.clear();
                          if (imageFile != null) {
                            setState(() {
                              imageFile = null;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                        ),
                      ),
                      hintText: "Send a message",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
