import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/user_model.dart';
import '../../../services/helpers.dart';
import '../../../services/user_services.dart';
import '../../../widgets/image/avatar.dart';
import 'edit.dart';

class AdminPanelUsers extends StatefulWidget {
  final List<UserModel> userList;
  final Function(bool refresh) notifyRefresh;
  final UserModel currentUser;
  const AdminPanelUsers({
    super.key,
    required this.userList,
    required this.currentUser,
    required this.notifyRefresh,
  });

  @override
  State<AdminPanelUsers> createState() => _AdminPanelUsersState();
}

class _AdminPanelUsersState extends State<AdminPanelUsers> {
  List<UserModel> filteredData = [];

  final searchController = TextEditingController();

  int _currentSortColumn = 0;
  bool _isAscending = true;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      filteredData = text.isEmpty
          ? widget.userList
          : widget.userList
              .where((user) =>
                  user.email.toLowerCase().contains(text.toLowerCase()) ||
                  user.name.toLowerCase().contains(text.toLowerCase()) ||
                  user.role!.name.toLowerCase().contains(text.toLowerCase()))
              .toList();
    });
  }

  @override
  void initState() {
    filteredData = widget.userList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColor.neutral2,
          ),
        ),
        title: Text(
          "Manage Users",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: Text(
              'View all user here. Search for user by typing user email or role. Edit or Disable users by clicking on the actions button.',
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchTextChanged,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                DataTable(
                  sortColumnIndex: _currentSortColumn,
                  sortAscending: _isAscending,
                  columns: <DataColumn>[
                    const DataColumn(
                      label: Text(''),
                    ),
                    DataColumn(
                      label: const Text('Role'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.userList.sort((userA, userB) =>
                                userA.role!.name.compareTo(userB.role!.name));
                          } else {
                            _isAscending = true;
                            widget.userList.sort((userA, userB) =>
                                userB.role!.name.compareTo(userA.role!.name));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Email'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.userList.sort((userA, userB) =>
                                userA.email.compareTo(userB.email));
                          } else {
                            _isAscending = true;
                            widget.userList.sort((userA, userB) =>
                                userB.email.compareTo(userA.email));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Name'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.userList.sort((userA, userB) =>
                                userA.name.compareTo(userB.name));
                          } else {
                            _isAscending = true;
                            widget.userList.sort((userA, userB) =>
                                userB.name.compareTo(userA.name));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Status'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.userList.sort((userA, userB) {
                              if (userA.disableAt == null &&
                                  userB.disableAt == null) {
                                return 0;
                              } else if (userA.disableAt == null) {
                                return -1;
                              } else if (userB.disableAt == null) {
                                return 1;
                              } else {
                                return userA.disableAt!
                                    .compareTo(userB.disableAt!);
                              }
                            });
                          } else {
                            _isAscending = true;
                            widget.userList.sort((userA, userB) {
                              if (userA.disableAt == null &&
                                  userB.disableAt == null) {
                                return 0;
                              } else if (userA.disableAt == null) {
                                return 1;
                              } else if (userB.disableAt == null) {
                                return -1;
                              } else {
                                return userB.disableAt!
                                    .compareTo(userA.disableAt!);
                              }
                            });
                          }
                        });
                      },
                    ),
                    const DataColumn(
                      label: Text('Actions'),
                    ),
                  ],
                  rows: List.generate(filteredData.length, (index) {
                    final user = filteredData[index];
                    return DataRow(
                      cells: [
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: avatar(
                              user: user,
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ),
                        ),
                        DataCell(Text(user.role!.displayName)),
                        DataCell(Text(user.email)),
                        DataCell(Text(user.name)),
                        DataCell(Text(
                            user.disableAt == null ? "Active" : "Disabled")),
                        DataCell(
                          Row(
                            children: [
                              // Edit
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) => EditUser(
                                        user: user,
                                        currentUser: widget.currentUser,
                                      ),
                                    ),
                                  )
                                      .then((result) {
                                    if (result != null) {
                                      widget.notifyRefresh(true);
                                    }
                                  });
                                },
                              ),
                              user.disableAt == null
                                  // Disable
                                  ? IconButton(
                                      icon: const Icon(Icons.person_remove),
                                      onPressed: () => showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Disable User?'),
                                          content: const Text(
                                              'Are you sure you want to disable this user? Select OK to confirm.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: CupertinoColors
                                                      .systemGrey,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                final result =
                                                    await UserServices()
                                                        .disableUser(
                                                            user: user);

                                                if (result == true &&
                                                    context.mounted) {
                                                  print("User disabled");
                                                  Fluttertoast.showToast(
                                                      msg: "User disabled");
                                                  Navigator.pop(context);
                                                }

                                                widget.notifyRefresh(true);
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
                                  // Enable
                                  : IconButton(
                                      icon: const Icon(Icons.person_add),
                                      onPressed: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Enable User?'),
                                          content: const Text(
                                              'Are you sure you want to enable this user? Select OK to confirm.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: CupertinoColors
                                                      .systemGrey,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                final result =
                                                    await UserServices()
                                                        .enableUser(user: user);

                                                if (result == true &&
                                                    context.mounted) {
                                                  print("User enabled");
                                                  Fluttertoast.showToast(
                                                      msg: "User enabled");
                                                  Navigator.pop(context);
                                                }

                                                widget.notifyRefresh(true);
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
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
