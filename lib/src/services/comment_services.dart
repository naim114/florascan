import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/comment_model.dart';
import '../models/news_model.dart';
import '../models/user_model.dart';
import 'news_services.dart';
import 'user_services.dart';

class CommentServices {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Comment');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // convert DocumentSnapshot to model object
  Future<CommentModel?> fromDocumentSnapshot(
      DocumentSnapshot<Object?> doc) async {
    String? id = doc.get('id');

    if (id == null) {
      return null;
    }

    return CommentModel(
      id: doc.get('id'),
      news: await NewsService().get(doc.get('news')),
      text: doc.get('text'),
      author: await UserServices().get(doc.get('author')),
      createdAt: doc.get('createdAt').toDate(),
    );
  }

  // convert QueryDocumentSnapshot to model object
  Future<CommentModel?> fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Object?> doc) async {
    String? id = doc.get('id');

    if (id == null) {
      return null;
    }

    return CommentModel(
      id: doc.get('id'),
      news: await NewsService().get(doc.get('news')),
      text: doc.get('text'),
      author: await UserServices().get(doc.get('author')),
      createdAt: doc.get('createdAt').toDate(),
    );
  }

  // get all
  Future<List<CommentModel?>> getAll() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('createdAt', descending: true).get();

    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> docList = querySnapshot.docs;

      List<Future<CommentModel?>> futures = docList
          .map((doc) => CommentServices().fromDocumentSnapshot(doc))
          .toList();

      return await Future.wait(futures);
    } else {
      return List.empty();
    }
  }

  // get by custom field
  Future<List<CommentModel?>> getByNews(NewsModel news) async {
    List<CommentModel?> dataList = List.empty(growable: true);

    List<CommentModel?> all = await CommentServices().getAll();

    for (var comment in all) {
      if (comment != null &&
          comment.news != null &&
          comment.news!.id == news.id) {
        dataList.add(comment);
      }
    }

    return dataList;
  }

  // add
  Future add({
    required String text,
    required UserModel author,
    required NewsModel news,
  }) async {
    try {
      dynamic add = await _collectionRef.add({
        'id': null,
        'news': null,
        'text': null,
        'author': null,
        'createdAt': null,
      }).then((docRef) async {
        _collectionRef
            .doc(docRef.id)
            .set(CommentModel(
              id: docRef.id,
              news: news,
              text: text,
              author: author,
              createdAt: DateTime.now(),
            ).toJson())
            .then((value) => print("Comment Added"));
      });

      print("Add Comment: $add");

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  Future delete({
    required CommentModel comment,
  }) async {
    try {
      final delete = _collectionRef.doc(comment.id).delete();

      print("Delete News: $delete");

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }
}
