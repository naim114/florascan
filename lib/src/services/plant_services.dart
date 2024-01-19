import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:florascan/src/models/plant_model.dart';

import '../models/plant_disease_model.dart';

class PlantServices {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Plants');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<PlantModel?> fromDocumentSnapshot(
      DocumentSnapshot<Object?> doc) async {
    String? id = doc.get('id');

    if (id == null) {
      return null;
    }

    // Fetch the "disease" subcollection
    CollectionReference diseaseCollection = doc.reference.collection('Disease');
    QuerySnapshot diseaseSnapshot = await diseaseCollection.get();

    List<PlantDiseaseModel> diseaseList = [];

    if (diseaseSnapshot.docs.isNotEmpty) {
      diseaseList = diseaseSnapshot.docs
          .map((diseaseDoc) => PlantDiseaseModel.fromMap(
              diseaseDoc.data() as Map<String, dynamic>))
          .toList();
    }

    return PlantModel(
      id: doc.get('id'),
      name: doc.get('name'),
      altName: doc.get('altName'),
      description: doc.get('description'),
      imgPath: doc.get('imgPath'),
      imgURL: doc.get('imgURL'),
      updatedAt: doc.get('updatedAt').toDate(),
      createdAt: doc.get('createdAt').toDate(),
      disease: diseaseList,
    );
  }

  Future<List<PlantModel?>> getAll() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('createdAt', descending: true).get();

    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> docList = querySnapshot.docs;

      List<Future<PlantModel?>> futures = docList
          .map((doc) => PlantServices().fromDocumentSnapshot(doc))
          .toList();

      return await Future.wait(futures);
    } else {
      return List.empty();
    }
  }
}
