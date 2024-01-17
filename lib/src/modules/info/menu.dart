import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/helpers.dart';
import '../../widgets/card/card_info_content.dart';

class DiseaseInfoMenu extends StatelessWidget {
  const DiseaseInfoMenu({
    super.key,
    required this.name,
    required this.imgURL,
    required this.altName,
  });

  final String name;
  final String imgURL;
  final String altName;

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
          "Plant Disease Info",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: ListView(
        children: [
          // Thumbnail
          GestureDetector(
            onTap: () => openImageViewerDialog(
              context: context,
              imageProvider: NetworkImage(
                imgURL,
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: imgURL,
              fit: BoxFit.cover,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: CupertinoColors.systemGrey,
                highlightColor: CupertinoColors.systemGrey2,
                child: Container(
                  color: Colors.grey,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
            ),
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: getColorByBackground(context),
                fontSize: 25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Text(
              altName,
              style: TextStyle(
                color: getColorByBackground(context),
                fontSize: 20,
              ),
            ),
          ),
          // Disease Overview
          const Padding(
            padding: EdgeInsets.only(
              top: 15.0,
              left: 15,
              right: 15,
            ),
            child: Text(
              "Disease Overview 🔎",
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
          // Gallery
          const Padding(
            padding: EdgeInsets.only(
              top: 15.0,
              left: 15,
              right: 15,
              bottom: 20,
            ),
            child: Text(
              "Gallery 🖼️",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: GestureDetector(
                          onTap: () => openImageViewerDialog(
                            context: context,
                            imageProvider: NetworkImage(
                              "https://dummyimage.com/1280x1000/2600fa/ffffff.png&text=example",
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              'assets/images/noimage.png',
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.height * 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
          // Info Content
          cardInfoContent(),
          cardInfoContent(),
          cardInfoContent(),
        ],
      ),
    );
  }
}
