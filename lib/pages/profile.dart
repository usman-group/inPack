
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_pack/bloc/authorisation_bloc.dart';
import 'package:in_pack/models/cigarette_pack.dart';
import 'package:in_pack/models/user.dart';
import 'package:in_pack/repositories/user_repository.dart';
import 'package:in_pack/widgets/auth_btn.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final UserRepository _userRepository;
  late final AuthorisationBloc _authorisationBloc;

  @override
  void initState() {
    _authorisationBloc = context.read<AuthorisationBloc>();
    _userRepository = context.read<UserRepository>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const padding = Padding(padding: EdgeInsets.only(bottom: 20));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(
          child: Text('Профиль'),
        ),
      ),
      body: FutureBuilder<User?>(
        future: _userRepository.currentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('Хуйня какая-то надо починить'),
              );
            } else {
              final currentUser = snapshot.data!;
              return Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        padding,
                        _avatarBuilder(currentUser),
                        padding,
                        _nicknameBuilder(currentUser.name),
                        _rankBuilder(currentUser.rank),
                        const Padding(padding: EdgeInsets.only(bottom: 50),),
                        const PackSelector(),
                        // _logoBuilder(currentUser.currentPack?.logo),
                        padding,
                      ],
                    ),
                    const Expanded(
                        child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Чтобы изменить что-либо просто коснитесь этого',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ))
                  ],
                ),
              );
            }
          }
          return const Center(
              child: Text('Что-то пошло не так...',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));
        },
      ),
      persistentFooterButtons: [
        Center(
          child: Button(
              onPressed: () {
                _authorisationBloc.add(LogOut(context: context));
              },
              title: 'Выйти из аккаунта'),
        ),
      ],
    );
  }

  Widget _avatarBuilder(User user) {
    const double radius = 70;
    return GestureDetector(
      onTap: () {
        _showSelectAvatarForm(user);
      },
      child: user.imageUrl == null
          ? const CircleAvatar(
              radius: radius,
              backgroundImage:
                  AssetImage('assets/images/default_profile_image.jpg'),
            )
          : CircleAvatar(
            radius: radius,
            backgroundImage: CachedNetworkImageProvider(
                user.imageUrl!,
                errorListener: (){throw 'Ошибка при загрузке изображения';},
              ),
          ),
    );
  }

  Widget _nicknameBuilder(String? nickname) {
    return GestureDetector(
      onTap: _showChangeNameForm,
      child: Text(
        nickname ?? 'Безымянный стрелок',
        style: const TextStyle(fontFamily: 'Roboto', fontSize: 30),
      ),
    );
  }

  void _showChangeNameForm() {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Изменение имени'),
              content: Form(
                  key: formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value == '') return 'Имя не может быть пустым';
                    },
                    keyboardType: TextInputType.name,
                    controller: controller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  )),
              actions: [
                Button(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      _userRepository
                          .updateCurrentUser(name: controller.text)
                          .then((value) {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      });
                    },
                    title: 'Изменить')
              ],
            ));
  }

  void _showChangeAvatarForm(User user, ImageSource source) async {
    final xImage = await ImagePicker().pickImage(source: source);
    if (xImage == null) return null;
    final Image image = Image.memory(await xImage.readAsBytes());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выбранная картинка:'),
        content: image,
        actions: [
          Button(
              onPressed: () async {
                await FirebaseStorage.instance
                    .ref()
                    .child('images/${user.id}')
                    .putFile(File(xImage.path));
                final String imageUrl = await FirebaseStorage.instance
                    .ref()
                    .child('images/${user.id}')
                    .getDownloadURL();

                _userRepository
                    .updateCurrentUser(imageUrl: imageUrl)
                    .then((value) => setState(() {
                          Navigator.of(context).pop();
                        }))
                    .onError<FirebaseException>(
                        (error, stackTrace) => throw '$error');
              },
              title: 'Изменить аватарку')
        ],
      ),
    );
  }

  Widget _rankBuilder(Rank rank) {
    return Text(
      rank.name,
      style: const TextStyle(color: Colors.grey, fontSize: 15),
    );
  }

  void _showSelectAvatarForm(User user) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Смена аватарки'),
              content: const Text('Выберите откуда хотите загрузить авку'),
              actions: [
                Button(
                    onPressed: () {
                      _showChangeAvatarForm(user, ImageSource.gallery);
                    },
                    title: 'Галерея'),
                Button(
                    onPressed: () {
                      _showChangeAvatarForm(user, ImageSource.camera);
                    },
                    title: 'Камера')
              ]);
        });
  }
}

class PackSelector extends StatefulWidget {
  const PackSelector({Key? key}) : super(key: key);

  @override
  State<PackSelector> createState() => _PackSelectorState();
}

class _PackSelectorState extends State<PackSelector> {
  Widget currentValue = CigarettePack.cigarettePacks[0].logo;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Widget>(
      alignment: Alignment.center,
      underline: const SizedBox(),
      value: currentValue,
      onChanged: (value) {
        setState(() {
          currentValue = value!;
        });
      },
      items: CigarettePack.cigarettePacks
          .map((e) => DropdownMenuItem<Widget>(
                value: e.logo,
                child: SizedBox(
                  // width: MediaQuery.of(context).size.width * 0.8,
                  child: e.logo,
                ),
              ))
          .toList(),
    );
  }
}
