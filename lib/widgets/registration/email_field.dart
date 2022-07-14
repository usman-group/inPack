import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({Key? key, required this.emailController}) : super(key: key);
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      autofillHints: const [AutofillHints.email],
      autofocus: true,
      controller: emailController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      textInputAction: TextInputAction.next,
    );
  }
}
