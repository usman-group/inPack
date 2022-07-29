import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_pack/utils/navbar_page.dart';

const String defaultImage =
    'https://sun9-47.userapi.com/c10668/u118752696/a_be977d28.jpg';

/// Widget of profile page with edit capabilities
class ProfilePage extends StatefulWidget implements NavigationBarPage {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  @override
  Icon get icon => const Icon(Icons.account_circle);

  @override
  String get label => 'Профиль';
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    _userName = ValueNotifier<String>(currentUser.displayName ?? 'Нет имени');
    _userImageUrl = ValueNotifier<String>(currentUser.photoURL ?? defaultImage);
    super.initState();
  }

  final User currentUser = FirebaseAuth.instance.currentUser!;
  late ValueNotifier<String> _userName;
  late ValueNotifier<String> _userImageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          color: Colors.brown[500],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              _avatarBuilderWithUrl(),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              _nicknameBuilder(),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              _emailBuilder(),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
            ],
          ),
        ),
        _signOutBuilder(),
      ],
    );
  }

  Widget _signOutBuilder() {
    return CupertinoButton(
      onPressed: () async {
        FirebaseAuth.instance.signOut();
      },
      color: Colors.white54,
      child: const Text(
        'Выйти нахуй из аккаунта',
        style: TextStyle(color: Colors.black, fontFamily: 'SF'),
      ),
    );
  }

  Widget _emailBuilder() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.mail_outline,
          color: Colors.white,
        ),
        const Padding(padding: EdgeInsets.only(left: 10)),
        Text(
          currentUser.email!,
          style: const TextStyle(color: Colors.white, fontFamily: 'SF'),
        ),
      ],
    );
  }

  Widget _nicknameBuilder() {
    final editButton = Positioned(
      bottom: -4,
      right: 0,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.brown,
        child: CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: _showChangeNicknameDialog,
            icon: const Icon(
              Icons.edit,
              color: Colors.black,
              size: 16,
            ),
          ),
        ),
      ),
    );
    final nickname = Center(
      child: ValueListenableBuilder<String>(
        valueListenable: _userName,
        builder: (BuildContext context, String value, Widget? child) {
          return Text(
            value,
            style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Consolas'),
          );
        },
      ),
    );
    return Container(
      height: 70,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.brown[800],
      ),
      child: Stack(fit: StackFit.expand, children: [
        nickname,
        editButton,
      ]),
    );
  }

  Widget _avatarBuilderWithUrl() {
    return Stack(children: <Widget>[
      ValueListenableBuilder<String>(
        valueListenable: _userImageUrl,
        builder: (BuildContext context, String value, Widget? child) =>
            CircleAvatar(
          backgroundImage: NetworkImage(value),
          radius: 40,
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: CircleAvatar(
          radius: 15,
          backgroundColor: Colors.brown[500],
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () => _showUpdateImageDialog(),
              icon: const Icon(
                Icons.add_a_photo,
                size: 15,
              ),
              color: Colors.black,
            ),
          ),
        ),
      )
    ]);
  }

  // TODO: UI
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
                          // TODO: Check that url is valid
                          if (newUrl != '') {
                            _userImageUrl.value = newUrl;
                            Navigator.of(context).pop();
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .set({'imageUrl': newUrl});
                            await user.updatePhotoURL(newUrl);
                          } else {
                            // TODO: Show incorrect image dialog
                            print('Incorrect Url');
                          }
                        },
                        child: const Text('Изменить')),
                  ],
                ),
              ],
            ));
  }

  // TODO: UI
  Future _showChangeNicknameDialog() {
    String userName = '';
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить ник'),
        content: const Text('Введите новый ник и нажмите Усман'),
        actions: [
          TextField(
            onChanged: (text) => userName = text,
            autofocus: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена')),
              TextButton(
                  onPressed: () {
                    if (userName != '' && userName.length < 20) {
                      _userName.value = userName;
                      Navigator.of(context).pop();
                      FirebaseAuth.instance.currentUser!
                          .updateDisplayName(_userName.value);
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({'firstName': _userName.value});
                    } else {
                      // TODO: Show incorrect nickname dialog
                      print('Incorrect Nickname');
                    }
                  },
                  child: const Text('Усман')),
            ],
          ),
        ],
      ),
    );
  }
}
