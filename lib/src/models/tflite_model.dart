import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteModel {
  static const String modelFile = "tomato_2024-05-03_20-41-52.tflite";
  static const String labelFile = "label.txt";

  late Interpreter _interpreter;
  late List<String> _labels;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(modelFile);
    _labels = await loadLabels();
  }

  Future<List<String>> loadLabels() async {
    final labelsData = await rootBundle.loadString(labelFile);
    return labelsData.split('\n');
  }

  List<String> get labels => _labels;

  Interpreter get interpreter => _interpreter;
}
