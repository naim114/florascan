import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:florascan/src/models/diagnose_history_model.dart';
import 'package:florascan/src/services/plant_services.dart';

import 'user_services.dart';

class DiagnoseHistoryServices {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('DiagnoseHistory');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // convert DocumentSnapshot to model object
  Future<DiagnoseHistoryModel?> fromDocumentSnapshot(
      DocumentSnapshot<Object?> doc) async {
    String? id = doc.get('id');

    if (id == null) {
      return null;
    }

    return DiagnoseHistoryModel(
      id: doc.get('id'),
      user: await UserServices().get(doc.get('user')),
      dateTime: doc.get('dateTime'),
      disease: await PlantServices().getDisease(doc.get('disease')),
      imgPath: doc.get('imgPath'),
      imgURL: doc.get('imgURL'),
    );
  }

  // convert QueryDocumentSnapshot to model object
  Future<DiagnoseHistoryModel?> fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Object?> doc) async {
    String? id = doc.get('id');

    if (id == null) {
      return null;
    }

    return DiagnoseHistoryModel(
      id: doc.get('id'),
      user: await UserServices().get(doc.get('user')),
      dateTime: doc.get('dateTime'),
      disease: doc.get('disease'),
      imgPath: doc.get('imgPath'),
      imgURL: doc.get('imgURL'),
    );
  }

  // convert map to model object
  Future<DiagnoseHistoryModel?> fromMap(Map<String, dynamic> map) async {
    String? id = map['id'];

    if (id == null) {
      return null;
    }

    return DiagnoseHistoryModel(
      id: map['id'],
      user: await UserServices().get(map['user']),
      dateTime: map['dateTime'].toDate(),
      disease: map['disease'],
      imgPath: map['imgPath'],
      imgURL: map['imgURL'],
    );
  }
}
