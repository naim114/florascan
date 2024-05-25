import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/diagnose_history_model.dart';
import '../../services/helpers.dart';
import '../../widgets/image/circle_image.dart';
import 'history_view.dart';

class DiagnoseHistory extends StatefulWidget {
  final List<DiagnoseHistoryModel> diagnoseList;
  final Function(bool refresh) notifyRefresh;

  const DiagnoseHistory(
      {super.key, required this.diagnoseList, required this.notifyRefresh});

  @override
  State<DiagnoseHistory> createState() => _DiagnoseHistoryState();
}

class _DiagnoseHistoryState extends State<DiagnoseHistory> {
  List<DiagnoseHistoryModel> filteredData = [];

  int _currentSortColumn = 0;
  bool _isAscending = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    filteredData = widget.diagnoseList;
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
          "Saved Diagnosis Result",
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
              'View all saved diagnosis result. Click on row for data details. Delete data by clicking on the actions button.',
              textAlign: TextAlign.justify,
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
                      label: const Text('Diagnosis Result'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.diagnoseList.sort((itemA, itemB) => itemA
                                .disease!.name
                                .compareTo(itemB.disease!.name));
                          } else {
                            _isAscending = true;
                            widget.diagnoseList.sort((itemA, itemB) => itemB
                                .disease!.name
                                .compareTo(itemA.disease!.name));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Date Time'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.diagnoseList.sort((itemA, itemB) =>
                                itemA.dateTime.compareTo(itemB.dateTime));
                          } else {
                            _isAscending = true;
                            widget.diagnoseList.sort((itemA, itemB) =>
                                itemB.dateTime.compareTo(itemA.dateTime));
                          }
                        });
                      },
                    ),
                    const DataColumn(
                      label: Text('Actions'),
                    ),
                  ],
                  rows: List.generate(filteredData.length, (index) {
                    final result = filteredData[index];
                    return DataRow(
                      cells: [
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: circleImage(
                              imgURL: result.imgURL,
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ),
                        ),
                        DataCell(Text(result.disease!.name)),
                        DataCell(Text(
                            DateFormat('dd/MM/yyyy').format(result.dateTime))),
                        DataCell(
                          Row(
                            children: [
                              // View
                              IconButton(
                                icon: const Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DiagnoseHistoryView(
                                              diagnose: result,
                                            )),
                                  );
                                },
                              ),
                              // Delete
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Delete Diagnosis?'),
                                    content: const Text(
                                        'Are you sure you want to diagnosis this news? Deleted data may can\'t be retrieved back. Select OK to confirm.'),
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
                                          // final result = await NewsService()
                                          //     .delete(news: news);
                                          // if (result == true &&
                                          //     context.mounted) {
                                          //   Fluttertoast.showToast(
                                          //       msg: "${news.title} deleted");
                                          //   Navigator.pop(context);
                                          //   widget.notifyRefresh(true);
                                          // }
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
