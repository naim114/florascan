import 'package:florascan/src/models/plant_disease_gallery_model.dart';

class PlantDiseaseModel {
  final String id;
  final String name;
  final String? altName;
  final String? description;
  final String? imgPath;
  final String? imgURL;
  final String? jsonContent;
  final DateTime updatedAt;
  final DateTime createdAt;

  PlantDiseaseModel({
    required this.altName,
    required this.createdAt,
    required this.description,
    required this.id,
    required this.imgPath,
    required this.imgURL,
    required this.jsonContent,
    required this.name,
    required this.updatedAt,
  });

  @override
  String toString() {
    return 'PlantCategoryModel(altName: $altName, createdAt: $createdAt, description: $description, id: $id, imgPath: $imgPath, imgURL: $imgURL, jsonContent: $jsonContent, name: $name, updatedAt: $updatedAt)';
  }

  factory PlantDiseaseModel.fromMap(Map<String, dynamic> map) {
    return PlantDiseaseModel(
      id: map['id'],
      name: map['name'],
      altName: map['altName'],
      description: map['description'],
      imgPath: map['imgPath'],
      imgURL: map['imgURL'],
      updatedAt: map['updatedAt'].toDate(),
      createdAt: map['createdAt'].toDate(),
      jsonContent: map['jsonContent'] ?? '',
    );
  }
}
