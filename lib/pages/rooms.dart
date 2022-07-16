import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:in_pack/pages/chat.dart';
import 'package:in_pack/pages/profile.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  State<RoomsPage> createState() => _RoomsPageState();
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
              child:
                  Text('Ошибочка вышла какая-то ${snapshot.error.toString()}'),
            );
          } else if (!snapshot.hasData) {
            return Container(
              alignment: Alignment.center,
              child: const Text('Нет пользователей'),
            );
          }
          return Container(
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int idx) {
                types.User user = snapshot.data![idx];
                return _userBuilder(user: user);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 10,
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.black,
                );
              },
            ),
          );
        }));
  }

  Widget _userBuilder({required types.User user}) {
    return GestureDetector(
      onTap: () => _moveToRoom(user),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white10,
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(user.imageUrl ?? defaultImage),
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Text(user.firstName ?? 'NoName'),
          ],
        ),
      ),
    );
  }

  void _moveToRoom(types.User otherUser) async {
    print('TAS:LKFJL:KAJSFJKDS:FLJSKLF');
    await FirebaseChatCore.instance.createRoom(otherUser).then((room) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => ChatPage(room: room))));
    });
  }
}
