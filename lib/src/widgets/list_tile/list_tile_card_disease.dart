import 'package:florascan/src/models/plant_disease_model.dart';
import 'package:florascan/src/services/helpers.dart';
import 'package:flutter/material.dart';

import '../../modules/info/menu.dart';
import '../image/circle_image.dart';

Widget listTileCardDisease({
  required BuildContext mainContext,
  required PlantDiseaseModel disease,
}) =>
    Card(
      child: ListTile(
        leading: circleImage(
          imgURL: disease.imgURL,
          height: MediaQuery.of(mainContext).size.height * 0.08,
          width: MediaQuery.of(mainContext).size.height * 0.08,
        ),
        title: Text(
          disease.name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: getColorByBackground(mainContext)),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: disease.altName == null ? null : Text(disease.altName!),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        onTap: () => Navigator.of(mainContext).push(
          MaterialPageRoute(
            builder: (context) => DiseaseInfoMenu(
              disease: disease,
            ),
          ),
        ),
      ),
    );
