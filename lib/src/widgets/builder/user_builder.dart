import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../modules/admin/users/index.dart';
import '../../services/user_services.dart';

class UsersBuilder extends StatefulWidget {
  final UserModel currentUser;
  final String pushTo;
  final Function(List<UserModel> userList, BuildContext pickerContext)? onPost;

  const UsersBuilder({
    super.key,
    required this.currentUser,
    required this.pushTo,
    this.onPost,
  });

  @override
  State<UsersBuilder> createState() => _UsersBuilderState();
}

class _UsersBuilderState extends State<UsersBuilder> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<UserModel> dataList = List.empty(growable: true);
  bool loading = true;

  Future<void> _refreshData() async {
    try {
      // Call the asynchronous operation to fetch data
      final List<UserModel> fetchedData =
          (await UserServices().getAll()).whereType<UserModel>().toList();

      // Update the state with the fetched data and call setState to rebuild the UI
      setState(() {
        loading = false;
        dataList = fetchedData;
      });

      // Trigger a refresh of the RefreshIndicator widget
      _refreshIndicatorKey.currentState?.show();
    } catch (e) {
      print("Get All:  ${e.toString()}");
    }
  }

  @override
  void initState() {
    _refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshData,
            child: Builder(
              builder: (context) {
                if (widget.currentUser.role!.name != 'super_admin') {
                  dataList
                      .removeWhere((user) => user.role!.name == 'super_admin');
                }

                if (widget.pushTo == "AdminPanelUsers") {
                  return AdminPanelUsers(
                    userList: dataList,
                    currentUser: widget.currentUser,
                    notifyRefresh: (refresh) {
                      print("refresh: $refresh");
                      _refreshData();
                    },
                  );
                } else {
                  return const Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                }
              },
            ),
          );
  }
}
