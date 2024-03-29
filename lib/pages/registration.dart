import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:in_pack/utils/show_dialog.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController =
      TextEditingController(text: 'example@example.example');
  final TextEditingController _passwordController = TextEditingController(
    text: 'password',
  );
  late UserCredential userCredential;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            const Spacer(
              flex: 3,
            ),
            _emailBuilder(),
            const Spacer(),
            _passwordBuild(),
            const Spacer(
              flex: 3,
            ),
            _signInButtonBuilder(),
            const Spacer(),
            _registerButtonBuilder(),
            const Spacer(
              flex: 4,
            ),
          ],
        ));
  }

  Widget _passwordBuild() {
    return TextField(
        autocorrect: false,
        autofillHints: const [AutofillHints.password],
        controller: _passwordController,
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

  Widget _emailBuilder() {
    return TextField(
      autocorrect: false,
      autofillHints: const [AutofillHints.email],
      autofocus: true,
      controller: _emailController,
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

  Widget _registerButtonBuilder() {
    return ElevatedButton(
        onPressed: () async {
          _register();
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

  Widget _signInButtonBuilder() {
    return ElevatedButton(
        onPressed: () async {
          _signIn();
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

  void _signIn() async {
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((value) {
        setState(() {});
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Неправильный пароль'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ок')),
                ],
              );
            });
      } else if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Пользователь не найден'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ок')),
                ],
              );
            });
      } else {
        showErrorDialog(context, 'Ошибка авторизации: $e');
      }
    } catch (e) {
      showErrorDialog(context, e);
    }
  }

  void _register() async {
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      User user = userCredential.user!;

      user.sendEmailVerification();

      int now = DateTime.now().millisecondsSinceEpoch;
      types.User firestoreUser = types.User(
        id: user.uid,
        createdAt: now,
        updatedAt: now,
        lastSeen: now,
        role: types.Role.user,
      );
      FirebaseChatCore.instance.createUserInFirestore(firestoreUser);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Пользователь успешно зарегистрирован'),
              content: Text('Пользователь с email: '
                  '${userCredential.user!.email} успешно '
                  'зарегистрирован. На вашу почту направлено '
                  'письмо для активации. Теперь вы можете установить имя'
                  'и фамилию в окне профиля'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Охуенно!')),
              ],
            );
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Слабый пароль'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ок')),
                ],
              );
            });
      } else if (e.code == 'email-already-in-use') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Данный email уже используется'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ок')),
                ],
              );
            });
      }
    } catch (e) {
      showErrorDialog(context, 'Ошибка при регистрации $e');
    }
  }
}
