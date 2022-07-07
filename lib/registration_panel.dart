import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPanel extends StatefulWidget {

  const RegisterPanel({Key? key}) : super(key: key);

  @override
  State<RegisterPanel> createState() => _RegisterPanelState();
}

class _RegisterPanelState extends State<RegisterPanel> {
  String _email = '', _password = '';
  late UserCredential userCredential;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (String text) => _email = text,
        ),
        TextField(
          obscureText: true,
          onChanged: (String text) => _password = text,
        ),
        IconButton(
            onPressed: () async {
              try{
                userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _email,
                    password: _password
                );
              } on FirebaseAuthException catch (e){
                if(e.code == 'weak-password'){
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      title: Text('Слабый пароль'),
                      actions: [
                        ElevatedButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child:
                        const Text('Ок')
                        ),
                      ],
                    );
                  });
                } else if(e.code == 'email-already-in-use'){
                  print('email already in use');
                }
              } catch (e){
                print(e);
              }
            },
            icon: Icon(Icons.how_to_reg_outlined)
        )
      ],
    );
  }
}
