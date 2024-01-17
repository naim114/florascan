import 'package:florascan/src/services/helpers.dart';
import 'package:flutter/material.dart';

import '../../modules/info/menu.dart';

Widget listTileCardDisease({
  required String imgURL,
  required BuildContext mainContext,
  required String name,
  required String altName,
}) =>
    Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imgURL),
          radius: 25.0,
        ),
        title: Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: getColorByBackground(mainContext)),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(altName),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        onTap: () => Navigator.of(mainContext).push(
          MaterialPageRoute(
            builder: (context) => DiseaseInfoMenu(
              name: name,
              imgURL: imgURL,
              altName: altName,
            ),
          ),
        ),
      ),
    );
