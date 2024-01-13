import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:textfield_tags/textfield_tags.dart';
import '../../services/helpers.dart';
import '../modal/error_modal.dart';
import 'image_uploader.dart';

class NewsEditor extends StatefulWidget {
  final QuillController controller;
  final BuildContext context;
  final String appBarTitle;
  final File? thumbnailFile;
  final String? title;
  final String? description;
  final String? thumbnailDescription;
  final String? category;
  final List<String>? tags;

  final Function(
    QuillController quillController,
    File? thumbnailFile,
    String title,
    String description,
    String? thumbnailDescription,
    String? category,
    List<String>? tags,
  ) onPost;

  const NewsEditor({
    super.key,
    required this.controller,
    required this.context,
    this.appBarTitle = "Add/Edit News",
    this.thumbnailFile,
    required this.onPost,
    this.title,
    this.description,
    this.thumbnailDescription,
    this.category,
    this.tags,
  });

  @override
  State<NewsEditor> createState() => _NewsEditorState();
}

class _NewsEditorState extends State<NewsEditor> {
  File? _thumbnailFile;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController thumbnailDescController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final TextfieldTagsController _tagController = TextfieldTagsController();

  bool _submitted = false;
  bool _loading = false;

  bool post() {
    setState(() => _submitted = true);
    Navigator.pop(context);

    if (titleController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Title can't be empty");

      return false;
    } else if (descController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Description can't be empty");

      return false;
    }

    setState(() => _loading = true);

    Future.delayed(const Duration(seconds: 1), () {
      widget.onPost(
        widget.controller,
        _thumbnailFile,
        titleController.text,
        descController.text,
        thumbnailDescController.text,
        categoryController.text.isEmpty ? null : categoryController.text,
        _tagController.getTags,
      );
    });

    return true;
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descController.dispose();
    thumbnailDescController.dispose();
    categoryController.dispose();
    _tagController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _submitted = false;
    _thumbnailFile = widget.thumbnailFile;
    titleController.text = widget.title ?? "";
    descController.text = widget.description ?? "";
    thumbnailDescController.text = widget.thumbnailDescription ?? "";
    categoryController.text = widget.category ?? "";
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
            Icons.arrow_back,
            color: CustomColor.neutral2,
          ),
        ),
        title: Text(
          widget.appBarTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
        actions: _loading
            ? []
            : [
                TextButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      if (titleController.text.isEmpty) {
                        return errorAlert(
                          "Title can't be empty",
                          "Title can't be empty. Please enter title under News Details",
                          context,
                        );
                      } else if (descController.text.isEmpty) {
                        return errorAlert(
                          "Description can't be empty",
                          "Description can't be empty. Please enter description under News Details",
                          context,
                        );
                      } else {
                        return AlertDialog(
                          title: const Text('Post News?'),
                          content: Text(
                              "${_thumbnailFile == null ? "No thumbnail included. Include it at Thumbnail section needed. " : ""}${thumbnailDescController.text.isEmpty ? "No thumbnail description included. Include it at Thumbnail section needed. " : ""}${categoryController.text.isEmpty ? "No category included. Include it at Category/Tag section needed. " : ""}${_tagController.getTags == null ? "No tags included. . Include it at Category/Tag section needed. " : ""}Select OK to confirm."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: post,
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  child: const Text("Post"),
                )
              ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ExpansionTile(
                    initiallyExpanded: true,
                    title: const Text("News Details",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: 'Title',
                          hintText: 'Enter title for this article',
                          focusColor: CupertinoColors.systemGrey,
                          hoverColor: CupertinoColors.systemGrey,
                          errorText:
                              _submitted == true & titleController.text.isEmpty
                                  ? "Title can't be empty"
                                  : null,
                        ),
                      ),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: 'Description',
                          hintText: 'Enter description for this article',
                          focusColor: CupertinoColors.systemGrey,
                          hoverColor: CupertinoColors.systemGrey,
                          errorText:
                              _submitted == true & descController.text.isEmpty
                                  ? "Description can't be empty"
                                  : null,
                        ),
                      ),
                    ]),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text(
                    "Thumbnail",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    ListTile(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ImageUploader(
                            appBarTitle: "Upload Thumbnail",
                            imageFile: _thumbnailFile,
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.25,
                            onCancel: () => Navigator.of(context).pop(),
                            onConfirm: (imageFile, uploaderContext) {
                              setState(() {
                                _thumbnailFile = imageFile;
                              });
                            },
                          ),
                        ),
                      ),
                      title: Text(
                        _thumbnailFile == null
                            ? "Tap to Upload Thumbnail"
                            : "Tap to Change/Preview Thumbnail",
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                      shape: const Border(
                        bottom: BorderSide(
                          width: 1.25,
                          color: Color(0xFFcacaca),
                        ),
                      ),
                    ),
                    TextField(
                      controller: thumbnailDescController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        labelText: 'Thumbnail description',
                        hintText:
                            'Enter description for thumbnail (e.g. image source)',
                        focusColor: CupertinoColors.systemGrey,
                        hoverColor: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text(
                    "Category/Tag",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        labelText: 'Category',
                        hintText:
                            'Enter category for this article (e.g. politics, sports)',
                        focusColor: CupertinoColors.systemGrey,
                        hoverColor: CupertinoColors.systemGrey,
                      ),
                    ),
                    TextFieldTags(
                      textfieldTagsController: _tagController,
                      textSeparators: const [' ', ','],
                      initialTags: widget.tags,
                      letterCase: LetterCase.normal,
                      validator: (String tag) {
                        if (_tagController.getTags!.contains(tag)) {
                          return '$tag already entered';
                        }
                        return null;
                      },
                      inputfieldBuilder:
                          (context, tec, fn, error, onChanged, onSubmitted) {
                        return ((context, sc, tags, onTagDelete) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextField(
                              controller: tec,
                              focusNode: fn,
                              decoration: InputDecoration(
                                helperText: 'Type tags and enter',
                                hintText:
                                    _tagController.hasTags ? '' : "Enter tag",
                                errorText: error,
                                prefixIcon: tags.isNotEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: 0,
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                          ),
                                          child: SingleChildScrollView(
                                            controller: sc,
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                                children:
                                                    tags.map((String tag) {
                                              return Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                  color: CustomColor.primary,
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      child: Text(
                                                        "#$tag",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4.0),
                                                    InkWell(
                                                      child: const Icon(
                                                        Icons.cancel,
                                                        size: 14.0,
                                                        color: Color.fromARGB(
                                                            255, 233, 233, 233),
                                                      ),
                                                      onTap: () {
                                                        onTagDelete(tag);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              );
                                            }).toList()),
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              onChanged: onChanged,
                              onSubmitted: onSubmitted,
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10,
                  ),
                  child: Card(
                    elevation: 2,
                    child: QuillToolbar.simple(
                      configurations: QuillSimpleToolbarConfigurations(
                        controller: widget.controller,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  child: QuillEditor.basic(
                    configurations: QuillEditorConfigurations(
                      controller: widget.controller,
                      readOnly: false,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
