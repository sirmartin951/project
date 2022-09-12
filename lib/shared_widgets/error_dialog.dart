import 'package:flutter/material.dart';

class ErroDialog extends StatelessWidget {
  final String? message;

  ErroDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Center(child: Text(message!)),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'))
      ],
    );
  }
}
