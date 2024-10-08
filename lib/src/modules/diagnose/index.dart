import 'package:florascan/src/modules/diagnose/choose_plant.dart';
import 'package:florascan/src/widgets/builder/diagnosis_result_builder.dart';
import 'package:flutter/material.dart';
import '../../models/diagnose_history_model.dart';
import '../../models/user_model.dart';
import '../../services/diagnose_history_services.dart';
import '../../services/helpers.dart';
import '../../widgets/typography/page_title_icon.dart';
import 'history.dart';

class DiagnoseMenu extends StatelessWidget {
  const DiagnoseMenu(
      {super.key, required this.mainContext, required this.user});
  final UserModel? user;
  final BuildContext mainContext;

  @override
  Widget build(BuildContext context) {
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
              'Choose available options.',
              style: TextStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text("Start plant disease diagnosis"),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () => Navigator.of(mainContext).push(
                    MaterialPageRoute(
                      builder: (context) => DiagnoseChoosePlant(
                        mainContext: mainContext,
                        user: user!,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                      "Plant disease identification model building report"),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () => goToURL(
                    context: context,
                    url: Uri.parse(
                        'https://github.com/naim114/tomato-plant-disease-classification-machine-learning/blob/master/model_building.ipynb'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text("Saved diagnosis history"),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () => Navigator.push(
                      mainContext,
                      MaterialPageRoute(
                          builder: (context) =>
                              DiagnosisResultBuilder(currentUser: user!))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
