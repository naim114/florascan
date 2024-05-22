// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:florascan/src/models/detection_classes.dart';
import 'package:florascan/src/services/tflite_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/helpers.dart';

class DiagnosisResult extends StatefulWidget {
  final File imageFile;
  const DiagnosisResult({super.key, required this.imageFile});

  @override
  State<DiagnosisResult> createState() => _DiagnosisResultState();
}

class _DiagnosisResultState extends State<DiagnosisResult> {
  final classifier = TFLiteServices();

  String label = "N/A";
  String confidence = "N/A";
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await classifier.loadModel();

    final result = await classifier.predict(widget.imageFile);

    print(result.detectedClass);
    print(result.confidence);

    setState(() {
      initialized = true;
      label = result.detectedClass.label;
      confidence = result.confidence.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            color: getColorByBackground(context),
            icon: const Icon(
              Icons.check_outlined,
              color: CustomColor.primary,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        title: Text(
          "Diagnosis Result",
          style: TextStyle(
            color: getColorByBackground(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: !initialized
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: widget.imageFile != null
                      ? Image.file(
                          widget.imageFile,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 300,
                          height: 300,
                          decoration: const BoxDecoration(
                            color: CupertinoColors.inactiveGray,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                    left: 25,
                    right: 25,
                  ),
                  child: Text(
                    "Label:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                    left: 25,
                    right: 25,
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 8.0,
                    left: 25,
                    right: 25,
                  ),
                  child: Text(
                    "Confidence Percentage:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                    left: 25,
                    right: 25,
                  ),
                  child: Text(
                    "$confidence%",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                ListTile(
                  tileColor: isDarkTheme(context)
                      ? CupertinoColors.systemGrey
                      : CupertinoColors.lightBackgroundGray,
                  title: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Read more about this disease",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                ),
                ListTile(
                  tileColor: isDarkTheme(context)
                      ? CupertinoColors.systemGrey
                      : CupertinoColors.lightBackgroundGray,
                  title: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Save diagnosis result",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     left: 25.0,
                //     right: 25.0,
                //     top: 30,
                //     bottom: 10,
                //   ),
                //   child: Text(
                //     "Choose below to diagnose again.",
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   ),
                // ),
                // ListTile(
                //   leading: const Icon(
                //     Icons.image,
                //     color: Colors.white,
                //   ),
                //   tileColor: CustomColor.secondary,
                //   title: const Text(
                //     'Upload Image from Gallery',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   onTap: () => Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => DiagnosisResult(),
                //     ),
                //   ),
                // ),
                // ListTile(
                //   leading: const Icon(
                //     Icons.camera,
                //     color: Colors.white,
                //   ),
                //   tileColor: CustomColor.secondary,
                //   title: const Text(
                //     'Snap Photo with Camera',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                //   onTap: () => Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => DiagnosisResult(),
                //     ),
                //   ),
                // ),
              ],
            ),
    );
  }
}
