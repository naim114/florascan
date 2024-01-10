import 'dart:convert';

import 'package:florascan/src/models/user_model.dart';

class NewsModel {
  final String id;
  final String title;
  final UserModel? author;
  final UserModel? updatedBy;
  final String jsonContent;
  final bool starred;
  final String? imgPath;
  final String? imgURL;

  // date
  final DateTime createdAt;
  final DateTime updatedAt;

  final List<dynamic>? likedBy;

  final String description;
  final String? category;
  final String? thumbnailDescription;
  final List<dynamic>? bookmarkBy;
  final List<dynamic>? tag;

  NewsModel({
    required this.id,
    required this.title,
    this.likedBy,
    required this.author,
    this.updatedBy,
    required this.jsonContent,
    this.starred = false,
    required this.createdAt,
    required this.updatedAt,
    this.imgPath,
    this.imgURL,
    required this.description,
    this.category,
    this.thumbnailDescription,
    this.bookmarkBy,
    this.tag,
  });

  @override
  String toString() {
    return 'NewsModel(id: $id, title: $title, likedBy: $likedBy, author: $author, updatedBy: $updatedBy, jsonContent: $jsonContent, starred: $starred, createdAt: $createdAt, updatedAt: $updatedAt, imgPath: $imgPath, imgURL: $imgURL,  description: $description, category: $category, thumbnailDescription: $thumbnailDescription, bookmarkBy: $bookmarkBy, tag: $tag)';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'likedBy': likedBy == null ? null : jsonEncode(likedBy),
      'author': author!.id,
      'updatedBy': updatedBy == null ? null : updatedBy!.id,
      'jsonContent': jsonContent,
      'starred': starred,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'imgPath': imgPath,
      'imgURL': imgURL,
      'description': description,
      'category': category,
      'thumbnailDescription': thumbnailDescription,
      'bookmarkBy': bookmarkBy == null ? null : jsonEncode(bookmarkBy),
      'tag': tag == null ? null : jsonEncode(tag),
    };
  }
}
