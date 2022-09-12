import 'package:flutter/material.dart';

import 'progress_bar.dart';


class LoadingDialog extends StatelessWidget {
  final String? message;

  LoadingDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Center(child: Text(message!)),
      actions: [
       circularProgress(),
        const SizedBox(height: 15,),
         Text(message! + 'Waiting for Authentication'),
      ],
    );
  }
}
