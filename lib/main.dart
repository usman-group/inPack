import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: UserPanel(),
));

class UserPanel extends StatefulWidget {
  const UserPanel({Key? key}) : super(key: key);

  @override
  State<UserPanel> createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  int _receivedCounter = 0, _sharedCounter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6E4B3F),
      appBar: AppBar(
        title: const Icon(Icons.smoking_rooms),
        centerTitle: true,
        backgroundColor: Colors.black38,
      ),
      body: SafeArea(
        child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Column(children: [
              const Padding(padding: EdgeInsets.only(top: 20)),
              const CircleAvatar(backgroundImage: AssetImage('assets/Pavel.jpg'),
                radius: 40,),
              const Padding(padding: EdgeInsets.only(top: 10)),
              const Text('Pavel Makarov', style: TextStyle(color: Colors.white,
                fontSize: 30, fontFamily: 'Gantari'), ),
              Row(
                children: const [
                  Icon(Icons.mail_outline, color: Colors.white,),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text('psp.pasha.makarov.ru', style: TextStyle(color: Colors.white),),
                ],),
              Text('Роздано: $_sharedCounter', style: const TextStyle(color: Colors.white),),
              Text('Получено: $_receivedCounter', style: const TextStyle(color: Colors.white),),
            ],)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            ++_sharedCounter;
          });
        },
        backgroundColor: Colors.black38,
        child: const Icon(Icons.send),
      ),
    );
  }
}
