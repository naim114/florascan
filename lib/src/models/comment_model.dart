import 'package:florascan/src/models/news_model.dart';
import 'package:florascan/src/models/user_model.dart';

class CommentModel {
  final String id;
  final NewsModel? news;
  final String text;
  final UserModel? author;

  // date
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.news,
    required this.text,
    required this.author,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'CommentModel(id: $id, news: $news, text: $text,author: $author, createdAt: $createdAt)';
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'news': news!.id,
      'text': text,
      'author': author!.id,
      'createdAt': createdAt,
    };
  }
}
