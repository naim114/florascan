import 'package:flutter/material.dart';

import '../../models/plant_disease_model.dart';
import '../../services/helpers.dart';
import '../../widgets/card/card_info_image.dart';

Widget infoCategorySection({
  required BuildContext mainContext,
  required List<PlantDiseaseModel> diseases,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 5),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Plant Diseases',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: getColorByBackground(mainContext),
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 5)),
                const WidgetSpan(
                    child: Icon(
                  Icons.my_library_books,
                  size: 18,
                )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
            ),
            itemCount: diseases.length,
            itemBuilder: (context, index) {
              return cardInfoImage(
                mainContext: mainContext,
                disease: diseases[index],
              );
            },
          ),
        ),
      ],
    );
