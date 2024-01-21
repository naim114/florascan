import 'package:florascan/src/models/plant_disease_model.dart';
import 'package:florascan/src/models/plant_model.dart';
import 'package:florascan/src/services/plant_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/list_tile/list_tile_card_disease.dart';
import '../../widgets/loader/indicator_scaffold.dart';
import '../../widgets/typography/page_title_icon.dart';

class Info extends StatelessWidget {
  const Info({super.key, required this.mainContext});
  final BuildContext mainContext;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlantModel?>>(
      future: PlantServices().getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return progressIndicatorScaffold(context: context);
        }

        List<PlantModel?>? plants = snapshot.data;

        if (plants == null || plants.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("Nothing to found here :(")),
          );
        }

        return Scaffold(
          body: ListView(
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
                      title: "Plant Disease Info",
                      icon: const Icon(
                        Icons.info,
                        size: 20,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Get all the information about plant disease here.',
                        style: TextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 5.0,
                ),
                child: GestureDetector(
                  onTap: () async {},
                  child: TextField(
                    readOnly: false,
                    autofocus: false,
                    enabled: false,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? CupertinoColors.darkBackgroundGray
                          : Colors.white,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: const BorderSide(
                          color: CupertinoColors.systemGrey,
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search for plant disease',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: Column(
                  children: plants.where((plant) => plant != null).expand(
                    (plant) {
                      if (plant!.diseases != null) {
                        List<PlantDiseaseModel> diseases = plant.diseases!;

                        return diseases
                            .map<Widget>(
                              (disease) => listTileCardDisease(
                                mainContext: mainContext,
                                disease: disease,
                              ),
                            )
                            .toList();
                      }

                      return <Widget>[];
                    },
                  ).toList(),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
