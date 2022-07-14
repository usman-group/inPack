import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({Key? key, required this.passwordController})
      : super(key: key);
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return TextField(
        autocorrect: false,
        autofillHints: const [AutofillHints.password],
        controller: passwordController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          labelText: 'Password',
          suffixIcon: Icon(Icons.cancel),
        ),
        keyboardType: TextInputType.emailAddress,
        obscureText: true);
  }
}
