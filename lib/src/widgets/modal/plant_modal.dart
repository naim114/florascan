import 'package:cached_network_image/cached_network_image.dart';
import 'package:florascan/src/models/plant_model.dart';
import 'package:florascan/src/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../modules/diagnose/plant_image_uploader.dart';
import '../../services/helpers.dart';

void showPlantModal({
  required BuildContext context,
  required PlantModel plant,
  required UserModel user,
}) =>
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
          child: Container(
            color:
                isDarkTheme(context) ? CustomColor.darkerBg : Colors.grey[200],
            height: MediaQuery.of(context).size.height * 0.9,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Cover image
                    SliverAppBar(
                      flexibleSpace: plant.imgURL == null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              child: Image.asset(
                                'assets/images/noimage.png',
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: double.infinity,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: plant.imgURL!,
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: CupertinoColors.systemGrey,
                                  highlightColor: CupertinoColors.systemGrey2,
                                  child: Container(
                                    color: Colors.grey,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/images/noimage.png',
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                              ),
                            ),
                      expandedHeight: MediaQuery.of(context).size.height * 0.3,
                      leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Title & Stats
                    SliverToBoxAdapter(
                      child: Container(
                        color: isDarkTheme(context)
                            ? CustomColor.darkBg
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  plant.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: getColorByBackground(context),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              plant.altName == null
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: Text(
                                        plant.altName!,
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: getColorByBackground(context),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Description
                    SliverToBoxAdapter(
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            plant.description == null
                                ? const SizedBox()
                                : Container(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Description',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          plant.description!,
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: CustomColor.secondary,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.energy_savings_leaf_sharp,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Diagnose Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PlantImageUploader(
                              appBarTitle: "Upload Plant Leaf Image",
                              onCancel: () => Navigator.of(context).pop(),
                              user: user,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
