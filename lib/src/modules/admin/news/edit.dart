import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/news_model.dart';
import '../../../models/user_model.dart';
import '../../../services/news_services.dart';
import '../../../widgets/editor/news_editor.dart';

class EditNews extends StatefulWidget {
  const EditNews({
    super.key,
    required this.currentUser,
    required this.news,
  });
  final UserModel currentUser;
  final NewsModel news;

  @override
  State<EditNews> createState() => _EditNewsState();
}

class _EditNewsState extends State<EditNews> {
  @override
  Widget build(BuildContext context) {
    final controller = QuillController(
      document: Document.fromJson(jsonDecode(widget.news.jsonContent)),
      selection: const TextSelection.collapsed(offset: 0),
    );

    List<String>? tags = widget.news.tag == null
        ? null
        : widget.news.tag!.map((e) => e.toString()).toList();

    return widget.news.imgPath != null
        // w/ thumbnail
        ? FutureBuilder<File>(
            future: NewsService().downloadThumbnail(widget.news),
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? const Scaffold(
                      body: Center(child: CircularProgressIndicator()))
                  : NewsEditor(
                      context: context,
                      title: widget.news.title,
                      controller: controller,
                      thumbnailFile: snapshot.data,
                      appBarTitle: "Edit News",
                      category: widget.news.category,
                      description: widget.news.description,
                      thumbnailDescription: widget.news.thumbnailDescription,
                      tags: tags,
                      onPost: (quillController, thumbnailFile, title, desc,
                          thumbnailDesc, catergory, tag) async {
                        var result;

                        if (thumbnailFile != null) {
                          result = await NewsService().edit(
                            news: widget.news,
                            title: title,
                            jsonContent: jsonEncode(
                                quillController.document.toDelta().toJson()),
                            editor: widget.currentUser,
                            imageFile: thumbnailFile,
                            description: desc,
                            category: catergory,
                            tag: tag,
                            thumbnailDescription: thumbnailDesc,
                          );
                        } else {
                          result = await NewsService().edit(
                            news: widget.news,
                            title: title,
                            jsonContent: jsonEncode(
                                quillController.document.toDelta().toJson()),
                            editor: widget.currentUser,
                            description: desc,
                            category: catergory,
                            tag: tag,
                            thumbnailDescription: null,
                          );
                        }

                        if (result == true && context.mounted) {
                          Fluttertoast.showToast(msg: "News posted");
                          Navigator.pop(context);
                        }
                      },
                    );
            })
        // w/o thumbnail
        : NewsEditor(
            context: context,
            controller: controller,
            title: widget.news.title,
            appBarTitle: "Edit News",
            category: widget.news.category,
            description: widget.news.description,
            thumbnailDescription: widget.news.thumbnailDescription,
            tags: tags,
            onPost: (quillController, thumbnailFile, title, desc, thumbnailDesc,
                catergory, tag) async {
              var result;

              if (thumbnailFile != null) {
                result = await NewsService().edit(
                  news: widget.news,
                  title: title,
                  jsonContent:
                      jsonEncode(quillController.document.toDelta().toJson()),
                  editor: widget.currentUser,
                  imageFile: thumbnailFile,
                  description: desc,
                  category: catergory,
                  tag: tag,
                  thumbnailDescription: thumbnailDesc,
                );
              } else {
                result = await NewsService().edit(
                  news: widget.news,
                  title: title,
                  jsonContent:
                      jsonEncode(quillController.document.toDelta().toJson()),
                  editor: widget.currentUser,
                  description: desc,
                  category: catergory,
                  tag: tag,
                  thumbnailDescription: null,
                );
              }

              if (result == true && context.mounted) {
                Fluttertoast.showToast(msg: "News posted");
                Navigator.pop(context);
              }
            },
          );
  }
}
