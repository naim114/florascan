import 'package:florascan/src/models/plant_disease_model.dart';

import 'user_model.dart';

class DiagnoseHistoryModel {
  final UserModel user;
  final DateTime dateTime;
  final PlantDiseaseModel disease;
  final String imgPath;
  final String imgURL;

  DiagnoseHistoryModel({
    required this.user,
    required this.dateTime,
    required this.disease,
    required this.imgPath,
    required this.imgURL,
  });

  @override
  String toString() {
    return 'DiagnoseHistoryModel(user: $user, dateTime: $dateTime, disease: $disease, imgPath: $imgPath, imgURL: $imgURL)';
  }

  Map<String, Object?> toJson() {
    return {
      'user': user,
      'dateTime': dateTime,
      'disease': disease,
      'imgPath': imgPath,
      'imgURL': imgURL,
    };
  }
}
