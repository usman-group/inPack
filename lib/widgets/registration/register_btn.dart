import 'package:flutter/material.dart';

class RegisterButton extends StatefulWidget {
  const RegisterButton({Key? key, required this.registerMethod})
      : super(key: key);
  final VoidCallback registerMethod;

  @override
  State<RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          widget.registerMethod();
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          child: Text(
            'Регистрация',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ));
  }
}
