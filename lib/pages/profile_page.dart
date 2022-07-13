import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_pack/widgets/profile/profile_picture.dart';

const String defaultImage = 'https://sun9-47.userapi.com/c10668/u118752696/a_be977d28.jpg';

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
          ProfilePicture(profileNetworkImage: NetworkImage(_userImageUrl ?? defaultImage)),
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
