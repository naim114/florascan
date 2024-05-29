import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:florascan/src/models/plant_model.dart';
import 'package:florascan/src/services/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:search_page/search_page.dart';
import '../models/plant_disease_model.dart';
import '../models/user_model.dart';
import '../widgets/list_tile/list_tile_card_disease.dart';

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

  // get by id
  Future<PlantModel?> get(String id) {
    return _collectionRef.doc(id).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        return PlantServices().fromDocumentSnapshot(doc);
      } else {
        print('Document does not exist on the database');
        return null;
      }
    });
  }

  // get disease by id
  Future<PlantDiseaseModel?> getDisease({
    required String diseaseId,
    String plantId = "Tomato",
  }) async {
    try {
      PlantModel? plant = await PlantServices().get(plantId);

      if (plant == null) {
        throw Exception('Plant not exist');
      }

      if (plant.diseases == null || plant.diseases!.isEmpty) {
        throw Exception('Plant has no disease');
      }

      return plant.diseases!.where((disease) => disease.id == diseaseId).first;
    } catch (e) {
      print(e);

      return null;
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
    required String jsonContent,
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
        'jsonContent': jsonContent,
      });

      print('Disease details updated successfully');

      return true;
    } catch (e) {
      print('Error updating disease details: $e');

      return false;
    }
  }

  Future uploadPlantThumbnail({
    required File imageFile,
    required PlantModel plant,
  }) async {
    // if previous image exist
    if (plant.imgPath != null && plant.imgURL != null) {
      print("Previous file exist");

      // delete previous file
      final Reference ref = _firebaseStorage.ref().child(plant.imgPath!);
      await ref.delete();

      print("Previous file deleted");
    }

    // UPLOAD TO FIREBASE STORAGE
    // Get file extension
    String extension = path.extension(imageFile.path);
    print("Extension: $extension");

    // Create the file metadata
    final metadata = SettableMetadata(contentType: "image/jpeg");

    // Create a reference to the file path in Firebase Storage
    final storageRef = _firebaseStorage
        .ref()
        .child('plants/${plant.id}/${plant.id}$extension');

    // Upload the file to Firebase Storage
    final uploadTask = storageRef.putFile(imageFile, metadata);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
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
          print("Plant image uploaded");
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
    dynamic result = _collectionRef.doc(plant.id).update({
      'updatedAt': DateTime.now(),
      'imgPath': 'plants/${plant.id}/${plant.id}$extension',
      'imgURL': downloadUrl,
    }).then((value) => print("Plant Edited"));

    print("Update Plant: $result");
  }

  Future uploadDiseaseThumbnail({
    required File imageFile,
    required PlantModel plant,
    required PlantDiseaseModel disease,
  }) async {
    try {
      // If previous image exists
      if (disease.imgPath != null && disease.imgURL != null) {
        print("Previous file exists");

        // Delete previous file
        final Reference ref = _firebaseStorage.ref().child(disease.imgPath!);
        await ref.delete();

        print("Previous file deleted");
      }

      // UPLOAD TO FIREBASE STORAGE
      // Get file extension
      String extension = path.extension(imageFile.path);
      print("Extension: $extension");

      // Create the file metadata
      final metadata = SettableMetadata(contentType: "image/jpeg");

      // Create a reference to the file path in Firebase Storage
      final storageRef = _firebaseStorage.ref().child(
          'plants/${plant.id}/diseases/${disease.id}/${disease.id}$extension');

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
            print("Upload encountered an error");
            throw Exception();
          case TaskState.success:
            // Handle successful uploads on complete
            print("Disease image uploaded");
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
      await _collectionRef
          .doc(plant.id)
          .collection('Disease')
          .doc(disease.id)
          .update({
        'updatedAt': DateTime.now(),
        'imgPath':
            'plants/${plant.id}/diseases/${disease.id}/${disease.id}$extension',
        'imgURL': downloadUrl,
      });

      print("Disease thumbnail uploaded and updated");

      return true;
    } catch (e) {
      print("Error uploading disease thumbnail: $e");
      // Handle error

      return false;
    }
  }

  Future searchPlantDisease({
    required BuildContext context,
    required UserModel user,
    String? query,
  }) async {
    List<PlantModel?> plantList = await PlantServices().getAll();

    List<PlantDiseaseModel> allDiseases = plantList
        .where((plant) => plant != null)
        .expand((plant) => plant!.diseases ?? [])
        .cast<PlantDiseaseModel>()
        .toList();

    if (context.mounted) {
      return showSearch(
        context: context,
        query: query,
        delegate: SearchPage(
          barTheme: Theme.of(context).brightness == Brightness.dark
              ? ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: CustomColor.primary,
                    brightness: Brightness.dark,
                  ),
                  brightness: Brightness.dark,
                  primarySwatch: CustomColorShades.primary(),
                  primaryColor: CustomColor.primary,
                  textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: Colors.white,
                        displayColor: Colors.white,
                      ),
                  expansionTileTheme: const ExpansionTileThemeData(
                    backgroundColor: CustomColor.primaryDarkShade,
                  ),
                  scaffoldBackgroundColor: CustomColor.darkerBg,
                  appBarTheme: const AppBarTheme(
                      backgroundColor: CustomColor.darkerBg,
                      surfaceTintColor: CustomColor.darkerBg,
                      // titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
                      iconTheme: IconThemeData(
                        color: CustomColor.neutral2,
                      )),
                )
              : ThemeData(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: CustomColor.neutral1,
                        displayColor: CustomColor.neutral1,
                      ),
                  scaffoldBackgroundColor: Colors.white,
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: CupertinoColors.systemGrey),
                  ),
                ),
          onQueryUpdate: print,
          items: allDiseases,
          searchLabel: 'Search plant disease',
          suggestion: const Center(
            child: Text(
                'Search plant disease by typing title, description, author or tags'),
          ),
          failure: const Center(
            child: Text('No plant disease found :('),
          ),
          filter: (disease) {
            return [
              disease.name,
            ];
          },
          builder: (disease) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: listTileCardDisease(
              mainContext: context,
              disease: disease,
            ),
          ),
        ),
      );
    }
  }
}
