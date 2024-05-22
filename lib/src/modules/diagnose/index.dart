import 'package:florascan/src/models/plant_model.dart';
import 'package:flutter/material.dart';

import '../../services/plant_services.dart';
import '../../widgets/loader/indicator_scaffold.dart';
import '../../widgets/modal/plant_modal.dart';
import '../../widgets/typography/page_title_icon.dart';

class Diagnosis extends StatelessWidget {
  const Diagnosis({super.key, required this.mainContext});
  final BuildContext mainContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Container(
                padding: const EdgeInsets.only(
                  top: 25,
                  left: 25,
                  right: 25,
                  // bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pageTitleIcon(
                      context: context,
                      title: "Diagnosis Plant Disease",
                      icon: const Icon(
                        Icons.energy_savings_leaf,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Text(
                  'Choose available type of plants to diagnose.',
                  style: TextStyle(),
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
