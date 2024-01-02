import 'package:flutter/material.dart';

Widget buttonCustom({
  required Widget child,
  required void Function() onPressed,
}) =>
    ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all(const Size(
          double.infinity,
          55,
        )),
      ),
      child: child,
    );
