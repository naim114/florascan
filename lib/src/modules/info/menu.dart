import 'package:flutter/material.dart';

import '../../services/helpers.dart';

class DiseaseInfoMenu extends StatelessWidget {
  const DiseaseInfoMenu({
    super.key,
    required this.title,
  });

  final String title;

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
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: ListView(
        children: [
          Image.asset(
            'assets/images/noimage.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
                "Anthracnose fruit rot is a soil-borne disease that affects ripe tomato fruit. Infections go unnoticed on green fruit and as fruit ripens depressed circular water-soaked spots appear on red fruit. These spots may slowly enlarge to about 1/4-inch in diameter and produce black fungal structures (microsclerotia) in the center of the lesion just below the skin surface. Microsclerotia can overwinter in the soil and serve as a source of inoculum for the next growing season."),
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Select below for more details",
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 25, right: 20),
            title: const Text("Manual Identification"),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {},
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 25, right: 20),
            title: const Text("Treatment"),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {},
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 25, right: 20),
            title: const Text("Prevention"),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
