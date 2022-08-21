import 'package:flutter/material.dart';
import 'package:in_pack/utils/validators.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  const PasswordFormField(
      {super.key, required this.passwordController, required this.formKey});

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: Validator.password,
        onChanged: (_) {
          widget.formKey.currentState!.validate();
        },
        autocorrect: false,
        autofillHints: const [AutofillHints.password],
        controller: widget.passwordController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          labelText: 'Пароль',
          suffixIcon: GestureDetector(
            onTap: (() {
              setState(() {
                _showPassword = !_showPassword;
              });
            }),
            child: _showPassword
                ? const Icon(Icons.elderly_woman_outlined)
                : const Icon(Icons.remove_red_eye_rounded),
          ),
        ),
        keyboardType: TextInputType.visiblePassword,
        obscureText: !_showPassword);
  }
}
