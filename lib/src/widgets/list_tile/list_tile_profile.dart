import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/helpers.dart';
import '../image/avatar.dart';

Widget listTileProfile({
  required BuildContext context,
  void Function()? onEdit,
  required UserModel user,
  bool includeEmail = true,
  bool includeEdit = true,
  Color? fontColor,
}) {
  Color defaultColor = fontColor ?? getColorByBackground(context);

  return ListTile(
    leading: avatar(
        user: user,
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.height * 0.06),
    title: Text(
      user.name,
      style: TextStyle(fontWeight: FontWeight.bold, color: defaultColor),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
    subtitle: includeEmail
        ? Text(
            user.email,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: defaultColor),
          )
        : null,
    contentPadding: const EdgeInsets.all(15),
    trailing: includeEdit
        ? OutlinedButton(
            onPressed: onEdit,
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Edit ',
                    style: TextStyle(
                      fontSize: 14,
                      color: defaultColor,
                    ),
                  ),
                  WidgetSpan(
                    child: Icon(
                      CupertinoIcons.pencil,
                      size: 14,
                      color: defaultColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        : null,
  );
}
