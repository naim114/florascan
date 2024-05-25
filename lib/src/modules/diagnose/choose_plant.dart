import 'package:florascan/src/models/plant_model.dart';
import 'package:florascan/src/models/user_model.dart';
import 'package:flutter/material.dart';

import '../../services/plant_services.dart';
import '../../widgets/loader/indicator_scaffold.dart';
import '../../widgets/modal/plant_modal.dart';

class DiagnoseChoosePlant extends StatelessWidget {
  final BuildContext mainContext;
  final UserModel user;

  const DiagnoseChoosePlant(
      {super.key, required this.mainContext, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Choose Plant",
        ),
      ),
      body: FutureBuilder<List<PlantModel?>>(
        future: PlantServices().getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return progressIndicatorScaffold(context: context);
          }

          List<PlantModel> plants = snapshot.data!
              .where((plant) => plant != null)
              .cast<PlantModel>()
              .toList();

          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Text(
                  'Choose available type of plants to diagnose.',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Column(
                  children: plants
                      .map(
                        (plant) => ListTile(
                          title: Text(plant.name),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                          onTap: () {
                            showPlantModal(
                              context: mainContext,
                              plant: plant,
                              user: user,
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
