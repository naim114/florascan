import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:florascan/src/models/plant_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import '../models/plant_disease_gallery_model.dart';
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
      diseaseList = await Future.wait(
        diseaseSnapshot.docs.map(
          (diseaseDoc) async {
            return PlantDiseaseModel.fromMap(
                diseaseDoc.data() as Map<String, dynamic>);
          },
        ),
      );
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
      diseases: diseaseList,
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

  Future edit({
    required PlantModel plant,
    required String name,
    required String altName,
    required String description,
  }) async {
    try {
      // w/o image
      // UPDATE ON FIRESTORE
      dynamic result = _collectionRef.doc(plant.id).update({
        'name': name,
        'altName': altName,
        'description': description,
        'updatedAt': DateTime.now(),
      }).then((value) => print("Plant Edited"));

      print("Update Plant: $result");

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }

  Future editDiseaseDetail({
    required PlantModel plant,
    required PlantDiseaseModel disease,
    required String name,
    required String altName,
    required String description,
  }) async {
    try {
      // Update disease details in Firestore
      await _collectionRef // Collection representing PlantModel
          .doc(plant.id)
          .collection('Disease') // Subcollection containing diseases
          .doc(disease.id)
          .update({
        'name': name,
        'altName': altName,
        'description': description,
      });

      print('Disease details updated successfully');

      return true;
    } catch (e) {
      print('Error updating disease details: $e');

      return false;
    }
  }
}
