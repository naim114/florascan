import 'package:florascan/src/models/plant_disease_model.dart';

import 'user_model.dart';

class DiagnoseHistoryModel {
  final String id;
  final UserModel? user;
  final DateTime dateTime;
  final PlantDiseaseModel? disease;
  final String imgPath;
  final String imgURL;

  DiagnoseHistoryModel({
    required this.id,
    required this.user,
    required this.dateTime,
    required this.disease,
    required this.imgPath,
    required this.imgURL,
  });

  @override
  String toString() {
    return 'DiagnoseHistoryModel(id: $id, user: $user, dateTime: $dateTime, disease: $disease, imgPath: $imgPath, imgURL: $imgURL)';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'user': user,
      'dateTime': dateTime,
      'disease': disease,
      'imgPath': imgPath,
      'imgURL': imgURL,
    };
  }
}
