import 'package:flutter/material.dart';

Future showInfoDialog(BuildContext context,
    {required String? title,
    required Widget content,
    VoidCallback? onPressed,
    List<Widget>? actions,
    String? buttonText}) {
  assert(
      actions == null || onPressed == null,
      'onPressed and actions shouldn\'t'
      ' be initialized simultaneously');
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? 'Предупреждение'),
          content: content,
          actions: actions ??
              <Widget>[
                ElevatedButton(
                    onPressed: onPressed ??
                        () {
                          Navigator.of(context).pop();
                        },
                    child: Text(buttonText ?? 'Понял. Принял.'))
              ],
        );
      });
}

Future showErrorDialog(BuildContext context, Object e) => showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Ошибка'),
        content: Text('Сообщение ошибки:\n $e'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Понял. Принял.'))
        ],
      );
    });
