class PlantDiseaseGalleryModel {
  final String imgPath;
  final String imgURL;

  PlantDiseaseGalleryModel({
    required this.imgPath,
    required this.imgURL,
  });

  @override
  String toString() {
    return 'PlantCategoryGalleryModel(imgPath: $imgPath, imgURL: $imgURL)';
  }

  factory PlantDiseaseGalleryModel.fromJson(Map<String, dynamic> map) {
    return PlantDiseaseGalleryModel(
      imgPath: map['imgPath'] ?? '',
      imgURL: map['imgURL'] ?? '',
    );
  }

  Map<String, Object?> toJson() {
    return {
      'imgPath': imgPath,
      'imgURL': imgURL,
    };
  }
}
