import 'package:cached_network_image/cached_network_image.dart';
import 'package:florascan/src/models/plant_model.dart';
import 'package:florascan/src/modules/admin/plant/disease.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

import '../../../services/helpers.dart';
import '../../../services/plant_services.dart';
import '../../../widgets/card/card_info_image.dart';
import '../../../widgets/editor/image_uploader.dart';

class PlantEdit extends StatefulWidget {
  const PlantEdit({super.key, required this.plant});

  final PlantModel plant;

  @override
  State<PlantEdit> createState() => _PlantEditState();
}

class _PlantEditState extends State<PlantEdit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController altNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.plant.name;
    altNameController.text = widget.plant.altName ?? "";
    descriptionController.text = widget.plant.description ?? "";

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    altNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () async {
              dynamic result = await PlantServices().edit(
                plant: widget.plant,
                name: nameController.text,
                altName: altNameController.text,
                description: descriptionController.text,
              );

              if (result == true && context.mounted) {
                Fluttertoast.showToast(msg: "Details sucessfully updated.");
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(
              Icons.check_outlined,
              color: CustomColor.primary,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColor.neutral2,
          ),
        ),
        title: Text(
          "Edit ${widget.plant.name} Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    widget.plant.imgURL != null
                        ? ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text('View Image'),
                            onTap: () => openImageViewerDialog(
                              context: context,
                              imageProvider: NetworkImage(
                                widget.plant.imgURL!,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    ListTile(
                      leading: const Icon(Icons.image_outlined),
                      title: const Text('Upload new image'),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ImageUploader(
                            appBarTitle: "Upload New Image",
                            onCancel: () => Navigator.of(context).pop(),
                            onConfirm: (imageFile, uploaderContext) async {
                              print("Image file: ${imageFile.toString()}");

                              Fluttertoast.showToast(
                                  msg: "Uploading new thumbnail. Please wait.");

                              Navigator.pop(context);
                              Navigator.pop(context);

                              final result =
                                  await PlantServices().uploadPlantThumbnail(
                                imageFile: imageFile,
                                plant: widget.plant,
                              );

                              print("Update Thumbnail: ${result.toString()}");

                              if (result == true) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Thumbnail Updated. Please refresh to see changes.");
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.delete_outline,
                        color: CustomColor.danger,
                      ),
                      title: const Text(
                        'Remove current picture',
                        style: TextStyle(color: CustomColor.danger),
                      ),
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(
                              'Are you sure you want to remove ${widget.plant.name} image?'),
                          content: const Text(
                              'Deleted data can\'t be retrieve back. Select OK to delete.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: CustomColor.danger),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            child: widget.plant.imgURL == null
                ? Image.asset(
                    'assets/images/noimage.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                  )
                : CachedNetworkImage(
                    imageUrl: widget.plant.imgURL!,
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
          const Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 30,
              right: 30,
            ),
            child: Text(
              'Tap on image for action choice',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                ),
                // Alt Name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: altNameController,
                    decoration: const InputDecoration(
                        labelText: 'Alternative/Scientific Name'),
                  ),
                ),
                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                ),
                widget.plant.diseases == null
                    ? const SizedBox()
                    : const Padding(
                        padding: EdgeInsets.only(
                          top: 15.0,
                          bottom: 10,
                        ),
                        child: Text(
                          "Disease List",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          widget.plant.diseases == null
              ? const SizedBox()
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Row(
                        children: List.generate(
                          widget.plant.diseases!.length,
                          // (index) => Text("data"),
                          (index) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: cardInfoImage(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.2,
                              mainContext: context,
                              disease: widget.plant.diseases![index],
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PlantDiseaseEdit(
                                    disease: widget.plant.diseases![index],
                                    plant: widget.plant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
