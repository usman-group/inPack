import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_pack/bloc/authorisation_bloc.dart';
import 'package:in_pack/widgets/password.dart';
import 'package:in_pack/widgets/auth_btn.dart';

const String initialEmail = 'rskvprd@gmail.com';
const String initialPassword = 'wasya2001';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthorisationBloc>();

    return BlocBuilder<AuthorisationBloc, AuthorisationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('Авторизация')),
            backgroundColor: Colors.brown,
          ),
          body: Form(
            key: _formKey,
            child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  children: [
                    const Spacer(
                      flex: 3,
                    ),

                    TextFormField(
                      validator: (value) {
                        final RegExp emailRegExp = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                        if (value == '') return 'Это обязательное поле';
                        if (!emailRegExp.hasMatch(value!)) {
                          return 'Некорректный email';
                        }

                        return null;
                      },
                      autocorrect: false,
                      autofillHints: const [AutofillHints.email],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      autofocus: true,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        labelText: 'Электронная почта',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      textInputAction: TextInputAction.next,
                    ),

                    const Spacer(),

                    PasswordFormField(
                        passwordController: _passwordController,
                        formKey: _formKey),

                    const Spacer(),

                    state is RegistrationInProcess
                        ? TextFormField(
                            initialValue: '',
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Пароли не совпадают';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            autocorrect: false,
                            autofillHints: const [AutofillHints.password],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              labelText: 'Подтверждение пароля',
                            ),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                          )
                        : Container(),

                    const Spacer(
                      flex: 3,
                    ),

                    /// Sign-in button
                    Button(onPressed: () async {
                      bloc.add(LogIn(
                          email: _emailController.text,
                          password: _passwordController.text,
                          formKey: _formKey,
                          context: context),);
                    }, title: 'Войти',),

                    const Spacer(),

                    /// Register button
                   Button(onPressed: () async {
                     bloc.add(Register(
                         email: _emailController.text,
                         password: _passwordController.text,
                         context: context,
                         formKey: _formKey));
                   }, title: 'Регистрация'),

                    const Spacer(
                      flex: 3,
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }
}
