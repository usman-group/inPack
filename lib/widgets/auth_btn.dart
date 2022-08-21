import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({Key? key, required this.onPressed, required this.title}) : super(key: key);
  final void Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.brown,
      onPressed: onPressed,
      minWidth: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
