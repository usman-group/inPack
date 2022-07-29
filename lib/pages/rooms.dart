import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:in_pack/pages/chat.dart';
import 'package:in_pack/pages/profile.dart';
import 'package:in_pack/utils/navbar_page.dart';

class RoomsPage extends StatefulWidget implements NavigationBarPage {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  State<RoomsPage> createState() => _RoomsPageState();

  @override
  Icon get icon => const Icon(Icons.chat_bubble_outline);

  @override
  String get label => 'Чат';
}

class _RoomsPageState extends State<RoomsPage> {
  final usersCollection =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List>(
        stream: FirebaseChatCore.instance.users(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              alignment: Alignment.center,
              child: Text('Ошибка (((((9( : ${snapshot.error.toString()}'),
            );
          } else if (!snapshot.hasData) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            } else {
              return Container(
                alignment: Alignment.center,
                child: const Text(
                  'Нет пользователей',
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
          }
          return Container(
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int idx) {
                  types.User user = snapshot.data![idx];
                  return _userBuilder(user: user);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Padding(padding: EdgeInsets.only(bottom: 7))),
          );
        }));
  }

  Widget _userBuilder({required types.User user}) {
    return GestureDetector(
      onTap: () => _createAndMoveToRoom(user),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.brown[800],
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(user.imageUrl ?? defaultImage),
              radius: 27,
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Text(
              user.firstName ?? 'NoName',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Consolas',
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _createAndMoveToRoom(types.User otherUser) async {
    await FirebaseChatCore.instance.createRoom(otherUser).then((room) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => ChatPage(room: room))));
    });
  }
}
