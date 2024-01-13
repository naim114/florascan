import 'package:flutter/material.dart';

cardInfoContent() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Text(
            "What Cause It?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
              "Anthracnose fruit rot is a soil-borne disease that affects ripe tomato fruit. Infections go unnoticed on green fruit and as fruit ripens depressed circular water-soaked spots appear on red fruit. These spots may slowly enlarge to about 1/4-inch in diameter and produce black fungal structures (microsclerotia) in the center of the lesion just below the skin surface. Microsclerotia can overwinter in the soil and serve as a source of inoculum for the next growing season."),
        ),
      ],
    );
