import 'package:flutter/material.dart';

Future showErrorDialog (BuildContext context, Object e){
  return showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(title: const Text('Ошибка'),
    content: Text('Сообщение ошибки:\n $e'),
    actions: [
      ElevatedButton(onPressed: (){
        Navigator.of(context).pop();
      }, child: const Text('Понял. Принял.'))
    ],
    );
  });
}