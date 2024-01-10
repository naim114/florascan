import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/role_model.dart';
import '../../../models/user_model.dart';
import '../../../services/role_services.dart';
import '../../../services/user_services.dart';
import '../../../widgets/appbar/appbar_confirm_cancel.dart';

class EditUserRole extends StatefulWidget {
  const EditUserRole({super.key, required this.user});
  final UserModel user;

  @override
  State<EditUserRole> createState() => _EditUserRoleState();
}

class _EditUserRoleState extends State<EditUserRole> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.user.role!.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarConfirmCancel(
        title: "Update User Role",
        onCancel: () => Navigator.pop(context),
        onConfirm: () async {
          final result = await UserServices()
              .updateRole(user: widget.user, roleId: dropdownValue);

          if (result == true && context.mounted) {
            Fluttertoast.showToast(msg: "Role updated");
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        context: context,
      ),
      body: FutureBuilder<List<RoleModel>>(
          future: RoleServices().getAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data != null) {
              List<RoleModel> roleList =
                  snapshot.data!.whereType<RoleModel>().toList();

              roleList.removeWhere((role) => role.name == 'super_admin');

              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 30.0),
                child: ListView(
                  children: [
                    const Text(
                        "Choose role to assign to user then click submmit button at top right."),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        elevation: 0,
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        decoration: const InputDecoration(labelText: 'Role'),
                        onChanged: (String? value) {
                          print(value);
                          setState(() => dropdownValue = value!);
                        },
                        items: List.generate(roleList.length, (index) {
                          RoleModel role = roleList[index];
                          return DropdownMenuItem<String>(
                            value: role.id,
                            child: Text(
                              role.displayName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
