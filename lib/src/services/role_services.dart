import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:florascan/src/models/role_model.dart';

class RoleServices {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Role');

  Future<List<RoleModel>> getAll() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List of Role Model
    final List<RoleModel> allData = querySnapshot.docs
        .map((doc) => RoleModel.fromQueryDocumentSnapshot(doc))
        .toList();

    return allData;
  }

  Future<RoleModel?> get(String id) async {
    return _collectionRef
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return RoleModel.fromDocumentSnapshot(documentSnapshot);
      } else {
        print('Document does not exist on the database');
        return null;
      }
    });
  }

  Future<List<RoleModel>> getBy(String fieldName, String value) async {
    List<RoleModel> dataList = List.empty(growable: true);

    QuerySnapshot querySnapshot = await _collectionRef.get();

    final List<QueryDocumentSnapshot<Object?>> allDoc =
        querySnapshot.docs.toList();

    for (var doc in allDoc) {
      if (doc.get(fieldName) == value) {
        dataList.add(RoleModel.fromDocumentSnapshot(doc));
      }
    }

    return dataList;
  }

  Future<RoleModel> getByFirst(String fieldName, String value) async {
    List<RoleModel> dataList = List.empty(growable: true);

    QuerySnapshot querySnapshot = await _collectionRef.get();

    final List<QueryDocumentSnapshot<Object?>> allDoc =
        querySnapshot.docs.toList();

    for (var doc in allDoc) {
      if (doc.get(fieldName) == value) {
        dataList.add(RoleModel.fromDocumentSnapshot(doc));
      }
    }

    return dataList.first;
  }
}
