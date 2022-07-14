import 'package:flutter/material.dart';

class SignInButton extends StatefulWidget {
  const SignInButton({Key? key, required this.signInMethod}) : super(key: key);
  final VoidCallback signInMethod;

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          widget.signInMethod();
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          child: Text(
            'Войти',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ));
  }
}
