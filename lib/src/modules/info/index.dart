import 'package:florascan/src/models/plant_disease_model.dart';
import 'package:florascan/src/models/plant_model.dart';
import 'package:florascan/src/services/plant_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/list_tile/list_tile_card_disease.dart';
import '../../widgets/loader/indicator_scaffold.dart';
import '../../widgets/typography/page_title_icon.dart';

List<Map> dummyData = [
  {
    'name': 'Bacterial Spot',
    'imgURL':
        'https://firebasestorage.googleapis.com/v0/b/florascan.appspot.com/o/plants%2Ftomato%2Fdisease%2Fbacterial_spot%2F00a7c269-3476-4d25-b744-44d6353cd921___GCREC_Bact.Sp%205807.JPG?alt=media&token=3767ca82-d837-4b67-8ed4-5102c0f47bf3',
    'altName': 'Xanthomonas vesicatoria',
  },
  {
    'name': 'Early Blight',
    'imgURL':
        'https://firebasestorage.googleapis.com/v0/b/florascan.appspot.com/o/plants%2Ftomato%2Fdisease%2Fearly_blight%2F0b494c44-8cd0-4491-bdfd-8a354209c3ae___RS_Erly.B%209561.JPG?alt=media&token=fa54d03f-56c1-4f6a-ba66-75a2d9dd50cd',
    'altName': 'Alternaria solani',
  },
  {
    'name': 'Late Blight',
    'imgURL':
        'https://firebasestorage.googleapis.com/v0/b/florascan.appspot.com/o/plants%2Ftomato%2Fdisease%2Flate_blight%2F0a4b3cde-c83a-4c83-b037-010369738152___RS_Late.B%206985.JPG?alt=media&token=2fa3560d-c670-4043-bcb1-69eae26b45f9',
    'altName': 'Phytophthora infestans ',
  },
  {
    'name': 'Leaf Mold',
    'imgURL':
        'https://firebasestorage.googleapis.com/v0/b/florascan.appspot.com/o/plants%2Ftomato%2Fdisease%2Fleaf_mold%2F0b3d5bf2-607f-4f95-bdcd-3542b8bd3244___Crnl_L.Mold%206654.JPG?alt=media&token=27c51504-6985-4719-a2a7-a1e72c31be95',
    'altName': 'Passalora fulva',
  },
  {
    'name': 'Septoria Leaf Spot',
    'imgURL':
        'https://firebasestorage.googleapis.com/v0/b/florascan.appspot.com/o/plants%2Ftomato%2Fdisease%2Fseptoria_leaf_spot%2F0bbf4db7-38a1-4d5c-8fd7-503e9f37ef8f___Matt.S_CG%207848.JPG?alt=media&token=4af95535-41de-4c5e-9d22-a049d74c0b73',
    'altName': 'Septoria lycopersici',
  },
  {
    'name': 'Two Spotted Spider Mites',
    'imgURL':
        'https://firebasestorage.googleapis.com/v0/b/florascan.appspot.com/o/plants%2Ftomato%2Fdisease%2Fspider_mites_two_spotted_spider_mite%2F0ac9558f-1e02-4498-9584-887627587bc0___Com.G_SpM_FL%201148.JPG?alt=media&token=6d124c2d-b658-4fa2-9b9e-bdd5084edb10',
    'altName': 'Tetranychus urticae Koch',
  },
  {
    'name': 'Target Spot',
    'imgURL':
        'https://firebasestorage.googleapis.com/v0/b/florascan.appspot.com/o/plants%2Ftomato%2Fdisease%2Ftarget_spot%2F0a458dfc-b513-44f2-a3ce-dab4c3adb939___Com.G_TgS_FL%208166.JPG?alt=media&token=5084aa42-d66c-4af3-bdf9-1a36fe66b09e',
    'altName': 'Corynespora cassiicola',
  },
  {
    'name': 'Tomato Mosaic Virus',
    'imgURL':
        'https://firebasestorage.googleapis.com/v0/b/florascan.appspot.com/o/plants%2Ftomato%2Fdisease%2Ftomato_mosaic_virus%2F1cee26b4-0ba1-4371-8c7e-c641e6ca311d___PSU_CG%202283.JPG?alt=media&token=5e437d44-6884-4144-a734-17103c965559',
    'altName': 'Lycopersicum virus 1 ',
  },
  {
    'name': 'Tomato Tellow Leaf Curl Virus',
    'imgURL':
        'https://firebasestorage.googleapis.com/v0/b/florascan.appspot.com/o/plants%2Ftomato%2Fdisease%2Ftomato_yellowleaf_curl_virus%2F0a0fe942-bb9e-4384-8466-779017d00bcf___UF.GRC_YLCV_Lab%2002192.JPG?alt=media&token=9caa872b-65b2-4873-8b6a-dc874705c654',
    'altName': 'Solanum lycopersicum',
  },
];

class Info extends StatelessWidget {
  const Info({super.key, required this.mainContext});
  final BuildContext mainContext;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlantModel?>>(
      future: PlantServices().getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return progressIndicatorScaffold();
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
                      if (plant!.disease != null) {
                        List<PlantDiseaseModel> diseases = plant.disease!;

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
