import 'package:florascan/src/models/plant_model.dart';
import 'package:florascan/src/modules/admin/plant/edit.dart';
import 'package:florascan/src/services/plant_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../services/helpers.dart';

class AdminPanelPlant extends StatefulWidget {
  const AdminPanelPlant({super.key});

  @override
  State<AdminPanelPlant> createState() => _AdminPanelPlantState();
}

class _AdminPanelPlantState extends State<AdminPanelPlant> {
  int _currentSortColumn = 0;
  bool _isAscending = true;

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
          "Manage Plant",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       // Navigator.of(context).push(
        //       //   MaterialPageRoute(
        //       //     builder: (context) => AddNews(
        //       //       currentUser: widget.currentUser,
        //       //     ),
        //       //   ),
        //       // );
        //       // widget.notifyRefresh(true);
        //     },
        //     icon: Icon(
        //       Icons.playlist_add_rounded,
        //       color: getColorByBackground(context),
        //     ),
        //   ),
        // ],
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
              'View all plant here. Edit or Delete news by clicking on the actions button.',
              textAlign: TextAlign.justify,
            ),
          ),
          FutureBuilder<List<PlantModel?>>(
            future: PlantServices().getAll(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              List<PlantModel> plants =
                  (snapshot.data ?? []).whereType<PlantModel>().toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DataTable(
                      sortColumnIndex: _currentSortColumn,
                      sortAscending: _isAscending,
                      columns: <DataColumn>[
                        DataColumn(
                          label: const Text('Name'),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                plants.sort((itemA, itemB) =>
                                    itemB.name.compareTo(itemA.name));
                              } else {
                                _isAscending = true;
                                plants.sort((itemA, itemB) =>
                                    itemA.name.compareTo(itemB.name));
                              }
                            });
                          },
                        ),
                        DataColumn(
                          label: const Text('Created At'),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                plants.sort((itemA, itemB) =>
                                    itemB.createdAt.compareTo(itemA.createdAt));
                              } else {
                                _isAscending = true;
                                plants.sort((itemA, itemB) =>
                                    itemA.createdAt.compareTo(itemB.createdAt));
                              }
                            });
                          },
                        ),
                        const DataColumn(
                          label: Text('Actions'),
                        ),
                      ],
                      rows: List.generate(
                        plants.length,
                        (index) {
                          PlantModel plant = plants[index];

                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    plant.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  ),
                                ),
                              ),
                              DataCell(Text(DateFormat('dd/MM/yyyy hh:mm a')
                                  .format(plant.createdAt))),
                              DataCell(
                                Row(
                                  children: [
                                    // Edit
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => PlantEdit(
                                              plant: plant,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
