import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AlertDialog errorAlert(String title, String desc, BuildContext context) =>
    AlertDialog(
      title: Text(title),
      content: Text(desc),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Close',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
      ],
    );
