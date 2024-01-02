import 'package:flutter/material.dart';

Widget buttonCustomPill({
  required BuildContext context,
  required Color borderColor,
  required Color fillColor,
  required void Function()? onPressed,
  required Widget child,
  double? width,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        color: fillColor,
      ),
      width: width ?? MediaQuery.of(context).size.width * 0.85,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
