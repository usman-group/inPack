import 'package:flutter/material.dart';

class UserPanel extends StatelessWidget {
  const UserPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
        Column(children: [
          const Padding(padding: EdgeInsets.only(top: 20)),
          const CircleAvatar(backgroundImage: AssetImage('assets/Pavel.jpg'),
            radius: 40,),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Text('Pavel Makarov', style: const TextStyle(color: Colors.white,
              fontSize: 30, fontFamily: 'Gantari'), ),
          Row(
            children: const [
              Icon(Icons.mail_outline, color: Colors.white,),
              Padding(padding: EdgeInsets.only(left: 10)),
              Text('psp.pasha.makarov.ru', style: TextStyle(color: Colors.white),),
            ],),
          Text('Роздано: 0', style: const TextStyle(color: Colors.white),),
          Text('Получено: 0', style: const TextStyle(color: Colors.white),),
        ],)],
      ),
    );
  }
}

