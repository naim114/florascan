import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:florascan/src/widgets/editor/content_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/plant_disease_model.dart';
import '../../../services/helpers.dart';
import '../../../widgets/editor/image_uploader.dart';

class PlantDiseaseEdit extends StatefulWidget {
  const PlantDiseaseEdit({super.key, required this.disease});

  final PlantDiseaseModel disease;

  @override
  State<PlantDiseaseEdit> createState() => _PlantDiseaseEditState();
}

class _PlantDiseaseEditState extends State<PlantDiseaseEdit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController altNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.disease.name;
    altNameController.text = widget.disease.altName ?? "";
    descriptionController.text = widget.disease.description ?? "";

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
    dynamic content = (widget.disease.jsonContent != null &&
            widget.disease.jsonContent!.isNotEmpty)
        ? jsonDecode(widget.disease.jsonContent!)
        : null;
    final controller = QuillController(
      document: (content != null) ? Document.fromJson(content) : Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
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
          "Edit ${widget.disease.name} Details",
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
                    widget.disease.imgURL != null
                        ? ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text('View Image'),
                            onTap: () => openImageViewerDialog(
                              context: context,
                              imageProvider: NetworkImage(
                                widget.disease.imgURL!,
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
                            onConfirm: (imageFile, uploaderContext) async {},
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
                              'Are you sure you want to remove ${widget.disease.name} image?'),
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
            child: widget.disease.imgURL == null
                ? Image.asset(
                    'assets/images/noimage.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                  )
                : CachedNetworkImage(
                    imageUrl: widget.disease.imgURL!,
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: const Text(
                "Tap here to edit disease info content",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ContentEditor(
                    controller: controller,
                    title: "Edit Disease Info Content",
                    onConfirm: (QuillController quillController) {
                      //
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
