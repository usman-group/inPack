import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
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
        stream: FirebaseChatCore.instance.rooms(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            throw 'Error in get rooms';
          }
          if (!snapshot.hasData &&
              snapshot.connectionState != ConnectionState.done) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }
          if ((!snapshot.hasData || snapshot.data == []) &&
              snapshot.connectionState == ConnectionState.done) {
            return Container(
              alignment: Alignment.center,
              child: const Text(
                'Вы пока ни с кем не общались, поищите кого-нибудь на карте',
                style: TextStyle(fontSize: 20),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data != []) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int idx) {
                    types.Room room = snapshot.data![idx];
                    return _roomBuilder(room);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Padding(padding: EdgeInsets.only(bottom: 7))),
            );
          }
          throw 'Error in getting rooms';
        }));
  }

  Widget _roomBuilder(types.Room room) {
    final types.User otherUser = room.users[0];
    final types.Message? lastMessage = room.lastMessages?.last;
    String? lastMessageText = lastMessage?.type == types.MessageType.text
        ? (lastMessage as types.TextMessage).text
        : null;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: ((context) => ChatPage(room: room)),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.brown[800],
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(otherUser.imageUrl ?? defaultImage),
              radius: 27,
            ),
            const Padding(padding: EdgeInsets.only(right: 10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  otherUser.firstName ?? 'NoName',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Consolas',
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  lastMessageText ?? 'Нет сообщений',
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
