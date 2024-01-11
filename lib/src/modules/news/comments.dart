import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/comment_model.dart';
import '../../models/news_model.dart';
import '../../models/user_model.dart';
import '../../services/comment_services.dart';
import '../../services/helpers.dart';
import '../../widgets/list_tile/list_tile_comment.dart';

class NewsComments extends StatefulWidget {
  const NewsComments({
    super.key,
    required this.news,
    required this.currentUser,
  });

  final NewsModel news;
  final UserModel currentUser;

  @override
  State<NewsComments> createState() => _NewsCommentsState();
}

class _NewsCommentsState extends State<NewsComments> {
  final commentController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future sendComment() async {
    if (commentController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter comment before send");
    } else {
      Fluttertoast.showToast(msg: "Sending comment");

      dynamic add = await CommentServices().add(
        text: commentController.text,
        author: widget.currentUser,
        news: widget.news,
      );

      if (add == true && context.mounted) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Comment sent");
        print("Comment sent");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.close,
            color: CustomColor.neutral2,
          ),
        ),
        title: Text(
          "Comments",
          style: TextStyle(
            color: getColorByBackground(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<CommentModel?>?>(
        future: CommentServices().getByNews(widget.news),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text(
              "Error loading comments. Please try again",
              style: TextStyle(color: CupertinoColors.systemGrey),
            ));
          } else if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return snapshot.data == null ||
                  (snapshot.data != null && snapshot.data!.isEmpty)
              ? const Center(
                  child: Text(
                  "Nothing to find here. Be the first to comment :)",
                  style: TextStyle(color: CupertinoColors.systemGrey),
                ))
              : ListView(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  children: List.generate(
                    snapshot.data!.length,
                    (index) {
                      CommentModel comment = snapshot.data![index]!;

                      return listTileComment(
                        context: context,
                        comment: comment,
                        currentUser: widget.currentUser,
                      );
                    },
                  ),
                );
        },
      ),
      bottomSheet: TextField(
        controller: commentController,
        autofocus: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: isDarkTheme(context)
              ? CupertinoColors.darkBackgroundGray
              : Colors.white,
          hintText: 'Enter comment here',
          contentPadding: const EdgeInsets.all(20),
          suffixIcon: loading
              ? const CupertinoActivityIndicator(radius: 10)
              : IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendComment();
                  },
                ),
        ),
      ),
    );
  }
}
