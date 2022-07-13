import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:in_pack/utils/show_error_dialog.dart';

// For the testing purposes, you should probably use https://pub.dev/packages/uuid.
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatPanel extends StatefulWidget {
  const ChatPanel({super.key});

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {

  @override
  void initState() {
    // createUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UsersPage();
  }


}


class UsersPage extends StatelessWidget {
  UsersPage({Key? key}) : super(key: key);

  // Create a user with an ID of UID if you don't use `FirebaseChatCore.instance.users()` stream
  final _fUser = FirebaseAuth.instance.currentUser;

  createUser(BuildContext context) async{
    try {
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: 'John',
          id: _fUser!.uid, // UID from Firebase Authentication
          imageUrl: 'https://i.pravatar.cc/300',
          lastName: 'Doe',
        ),
      );
    } catch (e){
      showErrorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        initialData: const [],
        builder: (context, snapshot) {
          return Text(snapshot.data.toString());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await createUser(context),
        child: const Icon(Icons.plus_one),
      ),
    );
  }
}