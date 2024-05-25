class PredictionResult {
  final DetectionClasses predictedClass;
  final double confidence;

  PredictionResult(this.predictedClass, this.confidence);
}

enum DetectionClasses {
  Tomato_Bacterial_spot,
  Tomato_Early_blight,
  Tomato_Late_blight,
  Tomato_Leaf_Mold,
  Tomato_Septoria_leaf_spot,
  Tomato_Spider_mites_Two_spotted_spider_mite,
  Tomato_Target_Spot,
  Tomato_Tomato_YellowLeaf_Curl_Virus,
  Tomato_Tomato_mosaic_virus,
  Tomato_healthy,
}

extension DetectionClassesExtension on DetectionClasses {
  String get label {
    switch (this) {
      case DetectionClasses.Tomato_Bacterial_spot:
        return "Bacterial Spot";
      case DetectionClasses.Tomato_Early_blight:
        return "Early Blight";
      case DetectionClasses.Tomato_Late_blight:
        return "Late Blight";
      case DetectionClasses.Tomato_Leaf_Mold:
        return "Leaf Mold";
      case DetectionClasses.Tomato_Septoria_leaf_spot:
        return "Septoria Leaf Spot";
      case DetectionClasses.Tomato_Spider_mites_Two_spotted_spider_mite:
        return "Spider mites Two-spotted Spider Mite";
      case DetectionClasses.Tomato_Target_Spot:
        return "Target Spot";
      case DetectionClasses.Tomato_Tomato_YellowLeaf_Curl_Virus:
        return "Yellow Leaf Curl Virus";
      case DetectionClasses.Tomato_Tomato_mosaic_virus:
        return "Mosaic Virus";
      case DetectionClasses.Tomato_healthy:
        return "Healthy";
    }
  }
}
