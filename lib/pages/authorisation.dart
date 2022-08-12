import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pack/bloc/authorisation_bloc.dart';
import 'package:in_pack/widgets/email.dart';
import 'package:in_pack/widgets/password.dart';

const String initialEmail = '';
const String initialPassword = '';

class AuthorisationPage extends StatefulWidget {
  const AuthorisationPage({Key? key}) : super(key: key);

  @override
  State<AuthorisationPage> createState() => _AuthorisationPageState();
}

class _AuthorisationPageState extends State<AuthorisationPage> {
  final TextEditingController _emailController =
      TextEditingController(text: initialEmail);
  final TextEditingController _passwordController =
      TextEditingController(text: initialPassword);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthorisationBloc>();

    return BlocBuilder<AuthorisationBloc, AuthorisationState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  const Spacer(
                    flex: 3,
                  ),
                  EmailFormField(
                      emailController: _emailController, formKey: _formKey),
                  const Spacer(),
                  PasswordFormField(
                      passwordController: _passwordController,
                      formKey: _formKey),
                  state is RegistrationInProcess
                      ? TextFormField(
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Пароли не совпадают';
                            }
                          },
                          onChanged: (_) {
                            _formKey.currentState!.validate();
                          },
                          autocorrect: false,
                          autofillHints: const [AutofillHints.password],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            labelText: 'Password',
                          ),
                          keyboardType: TextInputType.visiblePassword,
                        )
                      : Container(),

                  const Spacer(
                    flex: 3,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        bloc.add(LogIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                            formKey: _formKey,
                            context: context));
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        child: Text(
                          'Войти',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      )),
                  const Spacer(),

                  /// Register button
                  ElevatedButton(
                      onPressed: () async {
                        bloc.add(Register(
                            email: _emailController.text,
                            password: _passwordController.text,
                            context: context,
                            formKey: _formKey));
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                        child: Text(
                          'Регистрация',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      )),

                  const Spacer(
                    flex: 4,
                  ),
                ],
              )),
        );
      },
    );
  }
}
