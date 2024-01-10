import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../models/user_model.dart';
import '../../../services/helpers.dart';
import '../../../services/user_services.dart';
import '../../account/profile/index.dart';
import 'role.dart';

class EditUser extends StatelessWidget {
  const EditUser({
    super.key,
    required this.user,
    required this.currentUser,
  });
  final UserModel user;
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return Profile(
      user: user,
      bottomWidget: Column(
        children: [
          currentUser.role!.name != "super_admin"
              ? const SizedBox()
              : ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    "Edit Role",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditUserRole(user: user),
                    ),
                  ),
                ),
          user.disableAt == null
              ? ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    "Disable User",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColor.danger,
                    ),
                  ),
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Disable User?'),
                      content: const Text(
                          'Are you sure you want to disable this user? Select OK to confirm.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            print("Disabling user");

                            final result =
                                await UserServices().disableUser(user: user);

                            if (result == true && context.mounted) {
                              print("User disabled");
                              Fluttertoast.showToast(msg: "User disabled");
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              color: CustomColor.danger,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text(
                    "Enable User",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColor.danger,
                    ),
                  ),
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Enable User?'),
                      content: const Text(
                          'Are you sure you want to enable this user? Select OK to confirm.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            print("Enabling user");

                            final result =
                                await UserServices().enableUser(user: user);

                            if (result == true && context.mounted) {
                              print("User enabled");
                              Fluttertoast.showToast(msg: "User enabled");
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              color: CustomColor.danger,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
