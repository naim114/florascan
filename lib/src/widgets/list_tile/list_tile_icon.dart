import 'package:flutter/material.dart';

import '../../services/helpers.dart';

Widget listTileIcon({
  required BuildContext context,
  required IconData? icon,
  required String title,
  required void Function() onTap,
  double? fontSize = 16,
}) =>
    ListTile(
      title: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                icon,
                size: fontSize,
              ),
            ),
            TextSpan(
              text: '  ',
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
            TextSpan(
              text: title,
              style: TextStyle(
                color: getColorByBackground(context),
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
