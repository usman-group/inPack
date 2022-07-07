import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_pack/registration_panel.dart';

class UserPanel extends StatefulWidget {

  const UserPanel({Key? key}) : super(key: key);

  @override
  State<UserPanel> createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  String? _email = '';

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        _email = FirebaseAuth.instance.currentUser?.email;
      }
    });
    return Row(mainAxisAlignment: MainAxisAlignment.center,children: [
        Column(children: [
          const Padding(padding: EdgeInsets.only(top: 20)),
          const CircleAvatar(backgroundImage: AssetImage('assets/Pavel.jpg'),
            radius: 40,),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Text('Pavel Makarov', style: const TextStyle(color: Colors.white,
              fontSize: 30, fontFamily: 'Gantari'), ),
          Row(
            children: [
              Icon(Icons.mail_outline, color: Colors.white,),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text(_email!, style: TextStyle(color: Colors.white),),
            ],),
          Text('Роздано: 0', style: const TextStyle(color: Colors.white),),
          Text('Получено: 0', style: const TextStyle(color: Colors.white),),
        ],)],
      );
  }
}

