import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/comment_model.dart';
import '../../models/news_model.dart';
import '../../models/user_model.dart';
import '../../services/comment_services.dart';
import '../../services/helpers.dart';
import '../../services/news_services.dart';
import '../../widgets/list_tile/list_tile_profile.dart';
import 'comments.dart';

class NewsView extends StatefulWidget {
  final BuildContext mainContext;
  final NewsModel news;
  final UserModel user;

  const NewsView({
    super.key,
    required this.mainContext,
    required this.news,
    required this.user,
  });

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<Object?> allList = [
    null,
    null,
  ];

  bool loading = true;

  Future<void> _refreshData() async {
    try {
      final NewsModel? news = await NewsService().get(widget.news.id);
      final List<CommentModel?> comments =
          await CommentServices().getByNews(widget.news);

      setState(() {
        allList = [
          news,
          comments,
        ];
        loading = false;
      });

      // Trigger a refresh of the RefreshIndicator widget
      _refreshIndicatorKey.currentState?.show();
    } catch (e) {
      print("Error Get All News:  ${e.toString()}");
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    NewsModel? news = allList[0] as NewsModel?;
    List<CommentModel?>? comments = allList[1] as List<CommentModel?>?;

    if (news == null) {
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
            "News",
            style: TextStyle(
              color: getColorByBackground(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final controller = QuillController(
      document: Document.fromJson(jsonDecode(news.jsonContent)),
      selection: const TextSelection.collapsed(offset: 0),
    );

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
          "News",
          style: TextStyle(
            color: getColorByBackground(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshData,
              child: ListView(
                children: [
                  // Thumbnail
                  news.imgURL == null
                      ? Image.asset(
                          'assets/images/noimage.png',
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.5,
                        )
                      : CachedNetworkImage(
                          imageUrl: news.imgURL!,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.5,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: CupertinoColors.systemGrey,
                            highlightColor: CupertinoColors.systemGrey2,
                            child: Container(
                              color: Colors.grey,
                              height: MediaQuery.of(context).size.height * 0.5,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/noimage.png',
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height * 0.5,
                          ),
                        ),
                  const SizedBox(height: 8),
                  // Thumbnail Desc
                  news.thumbnailDescription == null
                      ? const SizedBox()
                      : Text(
                          news.thumbnailDescription!,
                          style: const TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                  // Category
                  news.category == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            top: 10,
                            bottom: 10,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              showDialog(
                                context: widget.mainContext,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );

                              await NewsService().searchNews(
                                context: widget.mainContext,
                                user: widget.user,
                                query: news.category,
                              );

                              if (context.mounted) {
                                Navigator.of(widget.mainContext,
                                        rootNavigator: true)
                                    .pop();
                              }
                            },
                            child: Text(
                              news.category!.toUpperCase(),
                              style: const TextStyle(
                                color: CustomColor.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Text(
                      news.title,
                      style: TextStyle(
                        color: getColorByBackground(context),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Description
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 5,
                    ),
                    child: Text(
                      news.description,
                      style: TextStyle(
                        color: getColorByBackground(context),
                        fontSize: 20,
                      ),
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Author
                  news.author == null
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: widget.mainContext,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );

                            await NewsService().searchNews(
                              context: widget.mainContext,
                              user: widget.user,
                              query: news.author!.name,
                            );

                            if (context.mounted) {
                              Navigator.of(widget.mainContext,
                                      rootNavigator: true)
                                  .pop();
                            }
                          },
                          child: listTileProfile(
                            context: context,
                            user: news.author!,
                            includeEdit: false,
                          ),
                        ),
                  // Date
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 5),
                    child: Text(
                      "Posted on ${DateFormat('MMMM d, y').format(news.createdAt)}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  news.createdAt.year == news.updatedAt.year &&
                          news.createdAt.month == news.updatedAt.month &&
                          news.createdAt.day == news.updatedAt.day &&
                          news.createdAt.hour == news.updatedAt.hour &&
                          news.createdAt.minute == news.updatedAt.minute
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(left: 15, bottom: 10),
                          child: Text(
                            "Updated on ${DateFormat('MMMM d, y').format(news.updatedAt)}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                  // Bookmark, Like, Comment
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        NewsService().isBookmark(news: news, user: widget.user)
                            ? OutlinedButton(
                                onPressed: () async {
                                  dynamic result = await NewsService()
                                      .unbookmark(
                                          news: news, user: widget.user);
                                  print("result: $result");

                                  if (result == true) {
                                    Fluttertoast.showToast(
                                        msg: "News unbookmarked");
                                  }

                                  _refreshData();
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.bookmark,
                                  color: CustomColor.secondary,
                                ),
                              )
                            : OutlinedButton(
                                onPressed: () async {
                                  dynamic result = await NewsService()
                                      .bookmark(news: news, user: widget.user);
                                  print("result: $result");

                                  if (result == true) {
                                    Fluttertoast.showToast(
                                        msg: "News bookmarked");
                                  }

                                  _refreshData();
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  Icons.bookmark,
                                  color: getColorByBackground(context),
                                ),
                              ),
                        const SizedBox(width: 5),
                        NewsService().isLike(news: news, user: widget.user)
                            ? OutlinedButton(
                                onPressed: () async {
                                  dynamic result = await NewsService()
                                      .unlike(news: news, user: widget.user);
                                  print("result: $result");

                                  if (result == true) {
                                    Fluttertoast.showToast(msg: "News unliked");
                                  }

                                  _refreshData();
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      const WidgetSpan(
                                        child: Icon(
                                          CupertinoIcons.heart_fill,
                                          size: 14,
                                          color: CustomColor.danger,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ' ${news.likedBy == null ? 0 : news.likedBy!.length}',
                                        style: TextStyle(
                                          color: getColorByBackground(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : OutlinedButton(
                                onPressed: () async {
                                  dynamic result = await NewsService()
                                      .like(news: news, user: widget.user);
                                  print("result: $result");

                                  if (result == true) {
                                    Fluttertoast.showToast(msg: "News liked");
                                  }

                                  _refreshData();
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          CupertinoIcons.heart_fill,
                                          size: 18,
                                          color: getColorByBackground(context),
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ' ${news.likedBy == null ? 0 : news.likedBy!.length}',
                                        style: TextStyle(
                                          color: getColorByBackground(context),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        const SizedBox(width: 5),
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NewsComments(
                                news: news,
                                currentUser: widget.user,
                              ),
                            ),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          child: Text(
                            "${comments == null ? 0 : comments.length} comments",
                            style: TextStyle(
                              color: getColorByBackground(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Article
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 30,
                      top: 20,
                    ),
                    child: QuillEditor(
                      configurations: QuillEditorConfigurations(
                        controller: controller,
                        readOnly: true,
                        autoFocus: false,
                        expands: false,
                        padding: const EdgeInsets.all(0),
                        scrollable: true,
                        showCursor: false,
                      ),
                      focusNode: FocusNode(),
                      scrollController: ScrollController(),
                    ),
                  ),
                  DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    dashColor: getColorByBackground(context),
                  ),
                  // Tag
                  news.tag == null || news.tag!.isEmpty
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 15,
                                top: 20,
                                bottom: 15,
                              ),
                              child: Text(
                                "Topics in this article",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                bottom: 30,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: news.tag!.map((tag) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: CustomColor.primary,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              "#$tag",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () async {
                                              showDialog(
                                                context: widget.mainContext,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                              );

                                              await NewsService().searchNews(
                                                context: widget.mainContext,
                                                user: widget.user,
                                                query: tag,
                                              );

                                              if (context.mounted) {
                                                Navigator.of(widget.mainContext,
                                                        rootNavigator: true)
                                                    .pop();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              dashColor: getColorByBackground(context),
                            ),
                          ],
                        ),
                  // Author box
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 15,
                    ),
                    child: InkWell(
                      onTap: () async {
                        showDialog(
                          context: widget.mainContext,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        await NewsService().searchNews(
                          context: widget.mainContext,
                          user: widget.user,
                          query: widget.news.author!.name,
                        );

                        if (context.mounted) {
                          Navigator.of(widget.mainContext, rootNavigator: true)
                              .pop();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: CustomColor.primary),
                            color: CustomColor.primary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            listTileProfile(
                              context: context,
                              user: news.author!,
                              includeEdit: false,
                              fontColor: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                bottom: 30,
                              ),
                              child: Text(
                                news.author!.bio == null ||
                                        news.author!.bio!.isEmpty
                                    ? "Tap to read more article from ${news.author!.name}"
                                    : news.author!.bio!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Comment
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewsComments(
                            news: news,
                            currentUser: widget.user,
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.black),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "${comments == null ? 0 : comments.length} COMMENTS",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
    );
  }
}
