import 'dart:io';

import 'package:florascan/src/models/user_model.dart';
import 'package:florascan/src/modules/diagnose/result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/appbar/appbar_confirm_cancel.dart';

// ignore: must_be_immutable
class PlantImageUploader extends StatefulWidget {
  final void Function() onCancel;
  final UserModel user;
  final String appBarTitle;
  final double width;
  final double height;
  final String desc;
  File? imageFile;
  BoxFit? fit;

  PlantImageUploader({
    super.key,
    required this.onCancel,
    this.width = 300,
    this.height = 300,
    this.appBarTitle = "Upload Image",
    this.desc =
        'Tap image to upload new image. Tap top right to confirm changes.',
    this.imageFile,
    this.fit = BoxFit.cover,
    required this.user,
  });

  @override
  State<PlantImageUploader> createState() => PlantImageUploaderState();
}

class PlantImageUploaderState extends State<PlantImageUploader> {
  var imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  void onConfirm(File imageFile, BuildContext pickerContext) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => DiagnosisResult(
          imageFile: imageFile,
          user: widget.user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarConfirmCancel(
        onCancel: widget.onCancel,
        onConfirm: () {
          if (widget.imageFile != null) {
            onConfirm(widget.imageFile!, context);
          } else {
            Fluttertoast.showToast(msg: "Please upload an image first");
          }
        },
        title: widget.appBarTitle,
        context: context,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.image),
                        title: const Text('Upload Image from Gallery'),
                        onTap: () => _uploadImage(ImageSource.gallery),
                      ),
                      ListTile(
                        leading: const Icon(Icons.camera),
                        title: const Text('Upload Image from Camera'),
                        onTap: () => _uploadImage(ImageSource.camera),
                      ),
                    ],
                  );
                },
              ),
              child: widget.imageFile != null
                  ? Image.file(
                      widget.imageFile!,
                      width: widget.width,
                      height: widget.height,
                      fit: widget.fit,
                    )
                  : Container(
                      width: widget.width,
                      height: widget.height,
                      decoration: const BoxDecoration(
                        color: CupertinoColors.inactiveGray,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: Text(
                widget.desc,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadImage(ImageSource source) async {
    XFile image = await imagePicker.pickImage(
      source: source,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.front,
    );

    setState(() {
      widget.imageFile = File(image.path);
    });
  }
}
