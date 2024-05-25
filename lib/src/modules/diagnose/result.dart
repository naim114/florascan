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
  PredictionResult? predictionResult;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await classifier.loadModel();

    final result = await classifier.predict(widget.imageFile);

    setState(() {
      initialized = true;
      predictionResult = result;
      label = result.predictedClass.label;
      confidence = result.confidence.toStringAsFixed(2);
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
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                    right: 25.0,
                    top: 30,
                    bottom: 10,
                  ),
                  child: Text(
                    "Choose below options.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.read_more,
                    color: Colors.white,
                  ),
                  tileColor: CustomColor.secondary,
                  title: Text(
                    'Read more about $label',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  tileColor: CustomColor.secondary,
                  title: const Text(
                    'Save Diagnosis Result',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
    );
  }
}
