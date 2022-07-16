import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String defaultImage =
    'https://sun9-47.userapi.com/c10668/u118752696/a_be977d28.jpg';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User currentUser = FirebaseAuth.instance.currentUser!;
  late ValueNotifier<String> _userName;
  late String? _userImageUrl;

  @override
  void initState() {
    _userName = ValueNotifier<String>(currentUser.displayName ?? 'Нет имени');
    _userImageUrl = FirebaseAuth.instance.currentUser!.photoURL;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _avatarBuilderWithUrl(url: _userImageUrl ?? defaultImage),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder<String?>(
                valueListenable: _userName,
                builder: (BuildContext context, String? value, Widget? child) {
                  return Text(value.toString());
                }),
            IconButton(
                onPressed: _showChangeNicknameDialog,
                icon: const Icon(Icons.smoking_rooms_sharp))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mail_outline,
              color: Colors.white,
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Text(FirebaseAuth.instance.currentUser!.email!),
          ],
        ),
        CupertinoButton(
          onPressed: () async {
            FirebaseAuth.instance.signOut();
          },
          color: Colors.white,
          child: const Text(
            'Выйти нахуй',
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    );
  }

  Widget _avatarBuilderWithUrl({required String? url}) {
    return Stack(children: <Widget>[
      CircleAvatar(
        backgroundImage: NetworkImage(url ?? defaultImage),
        radius: 40,
      ),
      Positioned(
        bottom: -10,
        right: -10,
        child: IconButton(
          onPressed: () {
            _showUpdateImageDialog();
            setState(() {});
          },
          icon: const Icon(CupertinoIcons.add_circled_solid),
          color: Colors.white,
        ),
      )
    ]);
  }

  Future _showUpdateImageDialog() {
    String newUrl = '';
    final User user = FirebaseAuth.instance.currentUser!;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Изменение авы'),
              content: const Text('Введите url картинки'),
              actions: [
                TextField(
                  autofocus: true,
                  onChanged: (text) {
                    newUrl = text;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Отмена')),
                    ElevatedButton(
                        onPressed: () async {
                          if (newUrl != '') {
                            Navigator.of(context).pop();
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .set({'imageUrl': newUrl});
                            await user.updatePhotoURL(newUrl);
                          } else {}
                        },
                        child: const Text('Изменить')),
                  ],
                ),
              ],
            ));
  }

  void _showChangeNicknameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить ник'),
        content: const Text('Введите новый ник и нажмите Усман'),
        actions: [
          TextField(
            onChanged: (text) => _userName.value = text,
          ),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена')),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser!
                    .updateDisplayName(_userName.value)
                    .then((value) => Navigator.of(context).pop());
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({'firstName': _userName.value});
              },
              child: const Text('Усман')),
        ],
      ),
    );
  }
}
