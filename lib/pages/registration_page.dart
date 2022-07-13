import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_pack/utils/show_error_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _email = '', _password = '';
  late UserCredential userCredential;

  _signIn() async {
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
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
        showErrorDialog(context, 'Пукпукпук $e');
      }
    } catch (e) {
      showErrorDialog(context, e);
    }
  }

  _register() async {
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      userCredential.user!.sendEmailVerification();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Пользователь успешно зарегистрирован'),
              content: Text('Пользователь с email: '
                  '${userCredential.user!.email} успешно '
                  'зарегистрирован. На вашу почту направлено '
                  'письмо для активации'),
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
      showErrorDialog(context, e);
    }
    if (!mounted) return;
    showErrorDialog(context, 'userCredential: $userCredential');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            const Spacer(
              flex: 3,
            ),
            TextField(
              onChanged: (String text) => _email = text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white54,
                ),
                labelStyle: TextStyle(color: Colors.white54),
                // fillColor: Colors.black38,
                // filled: true,
              ),
              style: const TextStyle(color: Colors.white70),
            ),
            const Spacer(),
            TextField(
              obscureText: true,
              onChanged: (String text) => _password = text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                prefixIcon: Icon(
                  Icons.password,
                  color: Colors.white54,
                ),
                labelStyle: TextStyle(color: Colors.white54),
              ),
              style: const TextStyle(color: Colors.white70),
            ),
            const Spacer(
              flex: 3,
            ),
            ElevatedButton(
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
                )),
            const Spacer(),
            ElevatedButton(
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
                )),
            const Spacer(
              flex: 4,
            ),
          ],
        ));
  }
}
