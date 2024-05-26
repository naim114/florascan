import 'package:florascan/src/models/plant_disease_model.dart';

import 'user_model.dart';

class DiagnoseHistoryModel {
  final String id;
  final UserModel? user;
  final DateTime dateTime;
  final PlantDiseaseModel? disease;
  final double confidence;
  final String imgPath;
  final String imgURL;

  DiagnoseHistoryModel({
    required this.id,
    required this.user,
    required this.dateTime,
    required this.disease,
    required this.imgPath,
    required this.imgURL,
    required this.confidence,
  });

  @override
  String toString() {
    return 'DiagnoseHistoryModel(id: $id, user: $user, dateTime: $dateTime, disease: $disease, imgPath: $imgPath, imgURL: $imgURL)';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'user': user!.id,
      'dateTime': dateTime,
      'disease': disease == null ? 'healthy' : disease!.id,
      'imgPath': imgPath,
      'imgURL': imgURL,
      'confidence': confidence,
    };
  }
}
