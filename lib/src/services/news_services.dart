import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:search_page/search_page.dart';

import '../models/news_model.dart';
import '../models/user_model.dart';
import '../modules/news/news_view.dart';
import '../widgets/card/news_card.dart';
import 'helpers.dart';
import 'user_services.dart';

class NewsService {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('News');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  // convert DocumentSnapshot to model object
  Future<NewsModel?> fromDocumentSnapshot(DocumentSnapshot<Object?> doc) async {
    String? id = doc.get('id');

    if (id == null) {
      return null;
    }

    return NewsModel(
      id: doc.get('id'),
      title: doc.get('title'),
      likedBy:
          doc.get('likedBy') == null ? null : jsonDecode(doc.get('likedBy')),
      author: await UserServices().get(doc.get('author')),
      updatedBy: doc.get('updatedBy') == null
          ? doc.get('updatedBy')
          : await UserServices().get(doc.get('author')),
      jsonContent: doc.get('jsonContent'),
      starred: doc.get('starred'),
      createdAt: doc.get('createdAt').toDate(),
      updatedAt: doc.get('updatedAt').toDate(),
      imgPath: doc.get('imgPath'),
      imgURL: doc.get('imgURL'),
      description: doc.get('description'),
      category: doc.get('category'),
      thumbnailDescription: doc.get('thumbnailDescription'),
      bookmarkBy: doc.get('bookmarkBy') == null
          ? null
          : jsonDecode(doc.get('bookmarkBy')),
      tag: doc.get('tag') == null ? null : jsonDecode(doc.get('tag')),
    );
  }

  // convert QueryDocumentSnapshot to model object
  Future<NewsModel?> fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Object?> doc) async {
    String? id = doc.get('id');

    if (id == null) {
      return null;
    }

    return NewsModel(
      id: doc.get('id'),
      title: doc.get('title'),
      likedBy:
          doc.get('likedBy') == null ? null : jsonDecode(doc.get('likedBy')),
      author: await UserServices().get(doc.get('author')),
      updatedBy: doc.get('updatedBy') == null
          ? doc.get('updatedBy')
          : await UserServices().get(doc.get('author')),
      jsonContent: doc.get('jsonContent'),
      starred: doc.get('starred'),
      createdAt: doc.get('createdAt').toDate(),
      updatedAt: doc.get('updatedAt').toDate(),
      imgPath: doc.get('imgPath'),
      imgURL: doc.get('imgURL'),
      description: doc.get('description'),
      category: doc.get('category'),
      thumbnailDescription: doc.get('thumbnailDescription'),
      bookmarkBy: doc.get('bookmarkBy') == null
          ? null
          : jsonDecode(doc.get('bookmarkBy')),
      tag: doc.get('tag') == null ? null : jsonDecode(doc.get('tag')),
    );
  }

  // convert map to model object
  Future<NewsModel?> fromMap(Map<String, dynamic> map) async {
    String? id = map['id'];

    if (id == null) {
      return null;
    }

    return NewsModel(
      id: map['id'],
      title: map['title'],
      likedBy: map['likedBy'] == null ? null : jsonDecode(map['likedBy']),
      author: await UserServices().get(map['author']),
      updatedBy: map['updatedBy'] == null
          ? map['updatedBy']
          : await UserServices().get(map['author']),
      jsonContent: map['jsonContent'],
      starred: map['starred'],
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt'].toDate(),
      imgPath: map['imgPath'],
      imgURL: map['imgURL'],
      description: map['description'],
      category: map['category'],
      thumbnailDescription: map['thumbnailDescription'],
      bookmarkBy:
          map['bookmarkBy'] == null ? null : jsonDecode(map['bookmarkBy']),
      tag: map['tag'] == null ? null : jsonDecode(map['tag']),
    );
  }

  // get all
  Future<List<NewsModel?>> getAll() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('createdAt', descending: true).get();

    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> docList = querySnapshot.docs;

      List<Future<NewsModel?>> futures = docList
          .map((doc) => NewsService().fromDocumentSnapshot(doc))
          .toList();

      return await Future.wait(futures);
    } else {
      return List.empty();
    }
  }

  Future<List<NewsModel>> getPopularNews({int limit = 5}) async {
    final List<NewsModel> fetchedAllNews =
        (await NewsService().getAll()).whereType<NewsModel>().toList();

    var res = fetchedAllNews.toList()
      ..sort((a, b) {
        if (a.likedBy != null && b.likedBy != null) {
          return b.likedBy!.length.compareTo(a.likedBy!.length);
        } else if (a.likedBy != null) {
          return -1; // a is not null, but b is null
        } else if (b.likedBy != null) {
          return 1; // b is not null, but a is null
        } else {
          return 0; // both a and b are null
        }
      })
      ..take(limit).toList();

    return res;
  }

  Future<List<NewsModel>> getStarredNews() async {
    try {
      final List<NewsModel> allNews =
          (await NewsService().getAll()).whereType<NewsModel>().toList();

      final List<NewsModel> starredNews =
          allNews.where((news) => news.starred == true).toList();

      return starredNews;
    } catch (e) {
      print(e.toString());

      return [];
    }
  }

  // get by id
  Future<NewsModel?> get(String id) {
    return _collectionRef.doc(id).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        return NewsService().fromDocumentSnapshot(doc);
      } else {
        print('Document does not exist on the database');
        return null;
      }
    });
  }

  // get by custom field
  Future<List<NewsModel?>> getBy(String fieldName, String value) async {
    List<NewsModel?> dataList = List.empty(growable: true);

    QuerySnapshot querySnapshot =
        await _collectionRef.orderBy('createdAt', descending: true).get();

    final List<QueryDocumentSnapshot<Object?>> allDoc =
        querySnapshot.docs.toList();

    for (var doc in allDoc) {
      if (doc.get(fieldName) == value) {
        NewsModel? noti = await NewsService().fromDocumentSnapshot(doc);

        if (noti != null) {
          dataList.add(noti);
        }
      }
    }

    return dataList;
  }

  // get all
  Future<List<NewsModel?>> getAllBy({
    required String fieldName,
    int? limit,
    bool desc = true,
  }) async {
    // Get docs from collection reference
    Query query = limit == null
        ? _collectionRef.orderBy(fieldName, descending: desc)
        : _collectionRef.orderBy(fieldName, descending: desc).limit(limit);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> docList = querySnapshot.docs;

      List<Future<NewsModel?>> futures = docList
          .map((doc) => NewsService().fromDocumentSnapshot(doc))
          .toList();

      return await Future.wait(futures);
    } else {
      return List.empty();
    }
  }

  // get all liked by user
  Future<List<NewsModel?>> getAllLikedBy({
    required UserModel user,
  }) async {
    // Get docs from collection reference
    final List<NewsModel?> all = await NewsService().getAll();

    List<NewsModel> fetch = List.empty(growable: true);

    for (var news in all) {
      if (news != null && isLike(news: news, user: user)) {
        fetch.add(news);
      }
    }

    return fetch;
  }

  // get all bookmark by user
  Future<List<NewsModel?>> getAllBookmarkedBy({
    required UserModel user,
  }) async {
    // Get docs from collection reference
    final List<NewsModel?> all = await NewsService().getAll();

    List<NewsModel> fetch = List.empty(growable: true);

    for (var news in all) {
      if (news != null && isBookmark(news: news, user: user)) {
        fetch.add(news);
      }
    }

    return fetch;
  }

  Future add({
    required String title,
    required String jsonContent,
    required UserModel author,
    required String description,
    File? imageFile,
    String? thumbnailDescription,
    String? category,
    List<String>? tag,
  }) async {
    try {
      dynamic add = await _collectionRef.add({
        'id': null,
        'title': null,
        'author': null,
        'jsonContent': null,
        'likedBy': null,
        'createdAt': null,
        'updatedAt': null,
        'imgPath': null,
        'imgURL': null,
        'thumbnailDescription': null,
        'description': null,
        'category': null,
        'tag': null,
      }).then((docRef) async {
        if (imageFile != null) {
          print("Thumbnail included");

          // UPLOAD TO FIREBASE STORAGE
          // Get file extension
          String extension = path.extension(imageFile.path);
          print("Extension: $extension");

          // Create the file metadata
          final metadata = SettableMetadata(contentType: "image/jpeg");

          // Create a reference to the file path in Firebase Storage
          final storageRef = _firebaseStorage
              .ref()
              .child('news/thumbnail/${docRef.id}$extension');

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
              .set(NewsModel(
                id: docRef.id,
                title: title,
                author: author,
                jsonContent: jsonContent,
                likedBy: [],
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                imgPath: 'news/thumbnail/${docRef.id}$extension',
                imgURL: downloadUrl,
                thumbnailDescription: thumbnailDescription,
                description: description,
                category: category,
                tag: tag,
              ).toJson())
              .then((value) => print("News Added"));
        } else {
          print("Thumbnail not included");

          _collectionRef
              .doc(docRef.id)
              .set(NewsModel(
                id: docRef.id,
                title: title,
                author: author,
                jsonContent: jsonContent,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                description: description,
                category: category,
                tag: tag,
              ).toJson())
              .then((value) => print("News Added"))
              .onError((error, stackTrace) => print("ERROR: $error"));
        }
      });

      print("Add News: $add");

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  Future edit({
    required NewsModel news,
    required String title,
    required String jsonContent,
    required UserModel editor,
    required String description,
    File? imageFile,
    String? thumbnailDescription,
    String? category,
    List<String>? tag,
  }) async {
    try {
      // w/ thumbnail
      if (imageFile != null) {
        // if previous thumbnail exist
        if (news.imgPath != null && news.imgURL != null) {
          print("Previous file exist");

          // delete previous file
          final Reference ref = _firebaseStorage.ref().child(news.imgPath!);
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
        final storageRef =
            _firebaseStorage.ref().child('news/thumbnail/${news.id}$extension');

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
        dynamic result = _collectionRef.doc(news.id).update({
          'title': title,
          'jsonContent': jsonContent,
          'updatedBy': editor.id,
          'updatedAt': DateTime.now(),
          'imgPath': 'news/thumbnail/${news.id}$extension',
          'imgURL': downloadUrl,
          'thumbnailDescription': thumbnailDescription,
          'description': description,
          'category': category,
          'tag': jsonEncode(tag),
        }).then((value) => print("News Edited"));

        print("Update News: $result");
      } else {
        // w/o thumbnail

        dynamic result = _collectionRef.doc(news.id).update({
          'title': title,
          'jsonContent': jsonContent,
          'updatedBy': editor.id,
          'updatedAt': DateTime.now(),
          'thumbnailDescription': null,
          'description': description,
          'category': category,
          'tag': jsonEncode(tag),
        }).then((value) => print("News Edited"));

        print("Update News: $result");
      }

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  Future delete({
    required NewsModel news,
  }) async {
    try {
      // if previous thumbnail exist
      if (news.imgPath != null && news.imgURL != null) {
        print("Previous file exist");

        // delete previous file
        final Reference ref = _firebaseStorage.ref().child(news.imgPath!);
        await ref.delete();

        print("Previous file deleted");
      }

      final delete = _collectionRef.doc(news.id).delete();

      print("Delete News: $delete");

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }

  Future like({
    required NewsModel news,
    required UserModel user,
  }) async {
    try {
      final List<dynamic> likedBy = news.likedBy ?? List.empty(growable: true);

      likedBy.add(user.id);

      dynamic result = _collectionRef.doc(news.id).update({
        'likedBy': jsonEncode(likedBy),
      }).then((value) => print("News Liked"));

      print("Like News: $result");

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }

  Future unlike({
    required NewsModel news,
    required UserModel user,
  }) async {
    try {
      final List<dynamic> likedBy = news.likedBy ?? List.empty(growable: true);

      if (likedBy.contains(user.id)) {
        likedBy.remove(user.id);

        dynamic result = _collectionRef.doc(news.id).update({
          'likedBy': jsonEncode(likedBy),
        }).then((value) => print("News Unliked"));

        print("Unlike News: $result");
      }

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }

  bool isLike({
    required NewsModel news,
    required UserModel user,
  }) {
    if (news.likedBy != null) {
      for (String id in news.likedBy!) {
        if (id == user.id) {
          return true;
        }
      }
    }

    return false;
  }

  Future star({required NewsModel news, required bool star}) async {
    try {
      dynamic result = _collectionRef.doc(news.id).update({
        'starred': star,
      }).then((value) => print("News Liked"));

      print("Like News: $result");

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }

  Future<File> downloadThumbnail(NewsModel news) async {
    final response = await http.get(Uri.parse(news.imgURL!));
    final bytes = response.bodyBytes;
    final fileName = Uri.parse(news.imgURL!).pathSegments.last;
    final tempDir = await getTemporaryDirectory();
    final directory = await Directory('${tempDir.path}/news/thumbnail')
        .create(recursive: true);

    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file;
  }

  Future bookmark({
    required NewsModel news,
    required UserModel user,
  }) async {
    try {
      final List<dynamic> bookmarkBy =
          news.bookmarkBy ?? List.empty(growable: true);

      bookmarkBy.add(user.id);

      dynamic result = _collectionRef.doc(news.id).update({
        'bookmarkBy': jsonEncode(bookmarkBy),
      }).then((value) => print("News Bookmarked"));

      print("Bookmark News: $result");

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }

  Future unbookmark({
    required NewsModel news,
    required UserModel user,
  }) async {
    try {
      final List<dynamic> bookmarkBy =
          news.bookmarkBy ?? List.empty(growable: true);

      if (bookmarkBy.contains(user.id)) {
        bookmarkBy.remove(user.id);

        dynamic result = _collectionRef.doc(news.id).update({
          'bookmarkBy': jsonEncode(bookmarkBy),
        }).then((value) => print("News Unbookmarked"));

        print("Unbookmark News: $result");
      }

      return true;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

      return false;
    }
  }

  bool isBookmark({
    required NewsModel news,
    required UserModel user,
  }) {
    if (news.bookmarkBy != null) {
      for (String id in news.bookmarkBy!) {
        if (id == user.id) {
          return true;
        }
      }
    }

    return false;
  }

  Future searchNews({
    required BuildContext context,
    required UserModel user,
    String? query,
  }) async {
    List<NewsModel?> newsList = await NewsService().getAll();

    if (context.mounted) {
      return showSearch(
        context: context,
        query: query,
        delegate: SearchPage(
          barTheme: Theme.of(context).brightness == Brightness.dark
              ? ThemeData(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: Colors.white,
                        displayColor: Colors.white,
                      ),
                  scaffoldBackgroundColor: CustomColor.darkerBg,
                  appBarTheme: const AppBarTheme(
                      backgroundColor: CustomColor.darkerBg,
                      iconTheme: IconThemeData(color: Colors.white)),
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
          items: newsList,
          searchLabel: 'Search news',
          suggestion: const Center(
            child: Text(
                'Search news by typing title, description, author or tags'),
          ),
          failure: const Center(
            child: Text('No news found :('),
          ),
          filter: (news) {
            return [
              news!.title,
              DateFormat('dd/MM/yyyy').format(news.createdAt),
              news.author!.name,
              news.author!.email,
              news.category,
              news.description,
              ...?news.tag == null
                  ? null
                  : news.tag!.map((e) => e.toString()).toList(),
            ];
          },
          builder: (news) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: newsCard(
              context: context,
              imageURL: news!.imgURL,
              title: news.title,
              date: news.createdAt,
              likeCount: news.likedBy == null ? 0 : news.likedBy!.length,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewsView(
                    mainContext: context,
                    news: news,
                    user: user,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
