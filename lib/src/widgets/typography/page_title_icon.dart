import 'package:flutter/material.dart';

import '../../services/helpers.dart';

Widget pageTitleIcon({
  required BuildContext context,
  required String title,
  required Icon icon,
  double fontSize = 20,
}) =>
    Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: getColorByBackground(context),
            ),
          ),
          TextSpan(
            text: ' ',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          WidgetSpan(
            child: icon,
          ),
        ],
      ),
    );
