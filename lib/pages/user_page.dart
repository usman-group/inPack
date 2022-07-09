import 'package:flutter/material.dart';

class UserPanel extends StatefulWidget {
  const UserPanel({Key? key}) : super(key: key);

  @override
  State<UserPanel> createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 20)),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/Pavel.jpg'),
              radius: 40,
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Text(
              'Name',
              style: const TextStyle(
                  color: Colors.white, fontSize: 30, fontFamily: 'Gantari'),
            ),
            Row(
              children: [
                Icon(
                  Icons.mail_outline,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  'Email@email.com',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Text(
              'Роздано: 0',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Получено: 0',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        )
      ],
    );
  }
}
