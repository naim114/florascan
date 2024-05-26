import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/diagnose_history_model.dart';
import '../../models/user_model.dart';
import '../../modules/diagnose/history.dart';
import '../../services/diagnose_history_services.dart';

class DiagnosisResultBuilder extends StatefulWidget {
  final UserModel currentUser;

  const DiagnosisResultBuilder({super.key, required this.currentUser});

  @override
  State<DiagnosisResultBuilder> createState() => _DiagnosisResultBuilderState();
}

class _DiagnosisResultBuilderState extends State<DiagnosisResultBuilder> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<DiagnoseHistoryModel> list = List.empty(growable: true);
  bool loading = true;

  Future<void> _refreshData() async {
    try {
      // Call the asynchronous operation to fetch data
      final List<DiagnoseHistoryModel> fetched =
          (await DiagnoseHistoryServices().getBy('user', widget.currentUser.id))
              .whereType<DiagnoseHistoryModel>()
              .toList();

      // Update the state with the fetched data and call setState to rebuild the UI
      setState(() {
        loading = false;
        list = fetched;
      });

      // Trigger a refresh of the RefreshIndicator widget
      _refreshIndicatorKey.currentState?.show();
    } catch (e) {
      print("Get All:  ${e.toString()}");
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
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
                return DiagnoseHistory(
                  diagnoseList: list,
                  notifyRefresh: (refresh) {
                    _refreshData();
                  },
                );
              },
            ),
          );
  }
}
