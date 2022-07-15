import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
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
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int idx) {
              types.User user = snapshot.data![idx];
              return _userBuilder(user: user);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 10,
                thickness: 4,
              );
            },
          );
        }));
  }

  Widget _userBuilder({required types.User user}) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(user.imageUrl ?? defaultImage),
        ),
        const Padding(padding: EdgeInsets.only(right: 10)),
        Text(user.firstName ?? 'NoName'),
        const Padding(padding: EdgeInsets.only(right: 2)),
        Text(user.lastName ?? 'NoLastName'),
      ],
    );
  }
}
