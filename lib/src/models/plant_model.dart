import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florascan/src/models/plant_disease_model.dart';

class PlantModel {
  final String id;
  final String name;
  final String? altName;
  final String? description;
  final String? imgPath;
  final String? imgURL;
  final DateTime updatedAt;
  final DateTime createdAt;
  final List<PlantDiseaseModel>? category;

  PlantModel({
    required this.id,
    required this.name,
    required this.altName,
    required this.description,
    required this.imgPath,
    required this.imgURL,
    required this.updatedAt,
    required this.createdAt,
    required this.category,
  });

  @override
  String toString() {
    return 'PlantModel(id: $id, name: $name, altName: $altName, description: $description, imgPath: $imgPath, imgURL: $imgURL, updatedAt: $updatedAt, createdAt: $createdAt, category: $category)';
  }

  factory PlantModel.fromDocumentSnapshot(DocumentSnapshot<Object?> doc) {
    String? id = doc.get('id');

    if (id == null) {
      return PlantModel(
        id: '',
        name: '',
        altName: '',
        description: '',
        imgPath: '',
        imgURL: '',
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        category: [],
      );
    }

    return PlantModel(
      id: id,
      name: doc.get('name') ?? '',
      altName: doc.get('altName') ?? '',
      description: doc.get('description') ?? '',
      imgPath: doc.get('imgPath') ?? '',
      imgURL: doc.get('imgURL') ?? '',
      updatedAt: doc.get('updatedAt').toDate(),
      createdAt: doc.get('createdAt').toDate(),
      category: (doc.get('category') as List<dynamic>?)
          ?.map((item) => PlantDiseaseModel.fromMap(item))
          .toList(),
    );
  }
}
