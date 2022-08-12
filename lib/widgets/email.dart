import 'package:flutter/material.dart';
import 'package:in_pack/utils/validators.dart';

class EmailFormField extends StatefulWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  const EmailFormField(
      {super.key, required this.emailController, required this.formKey});

  @override
  State<EmailFormField> createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: Validator.email,
      autocorrect: false,
      autofillHints: const [AutofillHints.email],
      autofocus: true,
      controller: widget.emailController,
      onChanged: (_) {
        widget.formKey.currentState!.validate();
      },
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
