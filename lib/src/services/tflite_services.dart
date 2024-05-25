import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/detection_classes.dart';
import 'helpers.dart';

class TFLiteServices {
  static const String modelFile =
      "assets/tflite/tomato_2024-05-03_20-50-08.tflite";
  static const String labelFile = "assets/labels/labels.txt";

  late Interpreter _interpreter;
  late List<String> _labels;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(modelFile);

    print(_interpreter.getInputTensor(0).shape);
    // [1, 256, 256, 3]

    _labels = await loadLabels();
  }

  Future<List<String>> loadLabels() async {
    final labelsData = await rootBundle.loadString(labelFile);
    return labelsData.split('\n');
  }

  Future<PredictionResult> predict(File imageFile) async {
    // Convert the File to a ui.Image and resize it to 256x256
    final ui.Image uiImage = await fileToUiImage(imageFile, 256, 256);

    // Convert the ui.Image to a Float32List
    final Float32List inputBytes = await uiImageToFloat32List(uiImage);

    // Reshape to input format specific for model. 1 item in list with pixels 256x256 and 3 layers for RGB
    final input = inputBytes.reshape([1, 256, 256, 3]);

    // Output container with 10 elements for the 10 classes
    final output = Float32List(1 * 10).reshape([1, 10]);

    // Run the model
    interpreter.run(input, output);

    // Get the index of the maximum value from the output data
    final predictionResult = output[0];
    int maxIndex = 0;
    double maxValue = predictionResult[0];
    for (int i = 1; i < predictionResult.length; i++) {
      if (predictionResult[i] > maxValue) {
        maxIndex = i;
        maxValue = predictionResult[i];
      }
    }

    // Calculate confidence percentage
    double confidencePercentage = maxValue * 100;

    return PredictionResult(
        DetectionClasses.values[maxIndex], confidencePercentage);
  }

  List<String> get labels => _labels;
  Interpreter get interpreter => _interpreter;
}
