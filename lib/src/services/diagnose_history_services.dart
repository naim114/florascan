import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:florascan/src/models/diagnose_history_model.dart';
import 'package:florascan/src/models/plant_disease_model.dart';
import 'package:florascan/src/services/plant_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;

import '../models/user_model.dart';
import 'user_services.dart';

class DiagnoseHistoryServices {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('DiagnoseHistory');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

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

  // get by id
  Future<DiagnoseHistoryModel?> get(String id) {
    return _collectionRef.doc(id).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        return DiagnoseHistoryServices().fromDocumentSnapshot(doc);
      } else {
        print('Document does not exist on the database');
        return null;
      }
    });
  }

  // get all
  Future<List<DiagnoseHistoryModel?>> getAll() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('createdAt', descending: true).get();

    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> docList = querySnapshot.docs;

      List<Future<DiagnoseHistoryModel?>> futures = docList
          .map((doc) => DiagnoseHistoryServices().fromDocumentSnapshot(doc))
          .toList();

      return await Future.wait(futures);
    } else {
      return List.empty();
    }
  }

  // get by custom field
  Future<List<DiagnoseHistoryModel?>> getBy(
      String fieldName, String value) async {
    List<DiagnoseHistoryModel?> dataList = List.empty(growable: true);

    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('createdAt', descending: true).get();

    final List<QueryDocumentSnapshot<Object?>> allDoc =
        querySnapshot.docs.toList();

    for (var doc in allDoc) {
      if (doc.get(fieldName) == value) {
        DiagnoseHistoryModel? item =
            await DiagnoseHistoryServices().fromDocumentSnapshot(doc);

        if (item != null) {
          dataList.add(item);
        }
      }
    }

    return dataList;
  }

  Future add({
    required PlantDiseaseModel disease,
    required UserModel user,
    required String description,
    required File imageFile,
  }) async {
    try {
      dynamic add = await _collectionRef.add({
        'id': null,
        'user': null,
        'dateTime': null,
        'disease': null,
        'imgPath': null,
        'imgURL': null,
      }).then((docRef) async {
        // UPLOAD TO FIREBASE STORAGE
        // Get file extension
        String extension = path.extension(imageFile.path);
        print("Extension: $extension");

        // Create the file metadata
        final metadata = SettableMetadata(contentType: "image/jpeg");

        // Create a reference to the file path in Firebase Storage
        final storageRef = _firebaseStorage
            .ref()
            .child('diagnose_history/${user.id}/${docRef.id}$extension');

        // Upload the file to Firebase Storage
        final uploadTask = storageRef.putFile(imageFile, metadata);

        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
          switch (taskSnapshot.state) {
            case TaskState.running:
              final progress = 100.0 *
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              print("Upload is $progress% complete.");
              break;
            case TaskState.paused:
              print("Upload is paused.");
              break;
            case TaskState.canceled:
              print("Upload was canceled");
              break;
            case TaskState.error:
              // Handle unsuccessful uploads
              print("Upload encounter error");
              throw Exception();
            case TaskState.success:
              // Handle successful uploads on complete
              print("News thumbnail uploaded");
              break;
          }
        });

        // Get the download URL of the uploaded file
        final downloadUrl =
            await uploadTask.then((TaskSnapshot taskSnapshot) async {
          final url = await taskSnapshot.ref.getDownloadURL();
          return url;
        });

        print("URL: $downloadUrl");

        // UPDATE ON FIRESTORE
        _collectionRef
            .doc(docRef.id)
            .set(DiagnoseHistoryModel(
              id: docRef.id,
              user: user,
              dateTime: DateTime.now(),
              disease: disease,
              imgPath: 'diagnose_history/${user.id}/${docRef.id}$extension',
              imgURL: downloadUrl,
            ).toJson())
            .then((value) => print("News Added"));
      });

      print("Add News: $add");

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  Future delete({
    required DiagnoseHistoryModel diagnoseHistory,
  }) async {
    try {
      // delete previous file
      final Reference ref =
          _firebaseStorage.ref().child(diagnoseHistory.imgPath!);
      await ref.delete();

      final delete = _collectionRef.doc(diagnoseHistory.id).delete();

      print("Delete Diagnose History: $delete");

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }
}
