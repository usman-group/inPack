import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User currentUser = FirebaseAuth.instance.currentUser!;
  late ValueNotifier<String> _userName;
  late ValueNotifier<NetworkImage> _profileImage;

  @override
  void initState() {
    _userName = ValueNotifier<String>(currentUser.displayName ?? 'Нет имени');
    _profileImage = ValueNotifier<NetworkImage>(NetworkImage(FirebaseAuth
            .instance.currentUser?.photoURL ??
        'http://sun9-77.userapi.com/s/v1/if1/_hMsF113Bel6q-EzkgvZVb156c35SDK58rmszJ_yVbvHhKNd8hBcIhuNS3Wbg6QXhwTdZQ.jpg?size=200x200&quality=96&crop=133,25,534,534&ava=1'));
    super.initState();
  }

  void _changeNicknameDialog(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить ник'),
        content:
        const Text('Введите новый ник и нажмите Усман'),
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
                    .then((value) =>
                    Navigator.of(context).pop());
              },
              child: const Text('Усман')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 20)),
          ValueListenableBuilder(
              valueListenable: _profileImage,
              builder: (context, NetworkImage value, child) {
                return CircleAvatar(
                  backgroundImage: value,
                  radius: 40,
                );
              }),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder<String?>(
                  valueListenable: _userName,
                  builder:
                      (BuildContext context, String? value, Widget? child) {
                    return Text(value.toString());
                  }),
              IconButton(
                  onPressed: _changeNicknameDialog,
                  icon: const Icon(Icons.smoking_rooms_sharp))
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.mail_outline,
                color: Colors.white,
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Text(FirebaseAuth.instance.currentUser!.email!),
            ],
          ),
          MaterialButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
            },
            color: Colors.white,
            elevation: 0,
            child: const Text('Выйти нахуй'),
          )
        ],
      );
  }
}
