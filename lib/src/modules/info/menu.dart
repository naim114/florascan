import 'package:cached_network_image/cached_network_image.dart';
import 'package:florascan/src/models/plant_disease_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/helpers.dart';
import '../../widgets/card/card_info_content.dart';

class DiseaseInfoMenu extends StatelessWidget {
  const DiseaseInfoMenu({
    super.key,
    required this.disease,
  });

  final PlantDiseaseModel disease;

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
            onTap: () {
              if (disease.imgURL != null) {
                openImageViewerDialog(
                  context: context,
                  imageProvider: NetworkImage(
                    disease.imgURL!,
                  ),
                );
              }
            },
            child: disease.imgURL == null
                ? Image.asset(
                    'assets/images/noimage.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                  )
                : CachedNetworkImage(
                    imageUrl: disease.imgURL!,
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
              disease.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: getColorByBackground(context),
                fontSize: 25,
              ),
            ),
          ),
          disease.altName == null
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15.0,
                    left: 15,
                    right: 15,
                  ),
                  child: Text(
                    disease.altName!,
                    style: TextStyle(
                      color: getColorByBackground(context),
                      fontSize: 20,
                    ),
                  ),
                ),
          // Disease Overview
          disease.description == null || disease.description == ""
              ? const SizedBox()
              : const Padding(
                  padding: EdgeInsets.only(
                    // top: 15.0,
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
          disease.description == null || disease.description == ""
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(disease.description!),
                ),
          // Gallery
          // disease.gallery == null
          //     ? const SizedBox()
          //     : const Padding(
          //         padding: EdgeInsets.only(
          //           // top: 15.0,
          //           left: 15,
          //           right: 15,
          //           bottom: 20,
          //         ),
          //         child: Text(
          //           "Gallery 🖼️",
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 20,
          //           ),
          //         ),
          //       ),
          // disease.gallery == null
          //     ? const SizedBox()
          //     : Padding(
          //         padding: const EdgeInsets.only(bottom: 20),
          //         child: SingleChildScrollView(
          //           scrollDirection: Axis.horizontal,
          //           child: Row(
          //             children: [
          //               const SizedBox(width: 10),
          //               Row(
          //                 children: List.generate(
          //                   3,
          //                   (index) => Padding(
          //                     padding:
          //                         const EdgeInsets.symmetric(horizontal: 5.0),
          //                     child: GestureDetector(
          //                       onTap: () => openImageViewerDialog(
          //                         context: context,
          //                         imageProvider: const NetworkImage(
          //                           "https://dummyimage.com/1280x1000/2600fa/ffffff.png&text=example",
          //                         ),
          //                       ),
          //                       child: ClipRRect(
          //                         borderRadius: BorderRadius.circular(10.0),
          //                         child: Image.asset(
          //                           'assets/images/noimage.png',
          //                           fit: BoxFit.cover,
          //                           height: MediaQuery.of(context).size.height *
          //                               0.2,
          //                           width: MediaQuery.of(context).size.height *
          //                               0.2,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               const SizedBox(width: 10),
          //             ],
          //           ),
          //         ),
          //       ),
          // Info Content
          cardInfoContent(),
          cardInfoContent(),
          cardInfoContent(),
        ],
      ),
    );
  }
}
