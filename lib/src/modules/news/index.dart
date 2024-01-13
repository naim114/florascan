import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/news_model.dart';
import '../../models/user_model.dart';
import '../../services/news_services.dart';
import '../../widgets/loader/skeleton_news.dart';
import 'news_section.dart';

class IndexNews extends StatefulWidget {
  const IndexNews({
    super.key,
    required this.mainContext,
    required this.user,
  });
  final BuildContext mainContext;
  final UserModel? user;
  @override
  State<IndexNews> createState() => _IndexNewsState();
}

class _IndexNewsState extends State<IndexNews> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<List<NewsModel>> allList = [
    [], // fetchedPopularNews
    [], // fetchedLatestNews
  ];

  bool loading = true;

  Future<void> _refreshData() async {
    try {
      final List<NewsModel> fetchedAllNews =
          (await NewsService().getAll()).whereType<NewsModel>().toList();

      final List<NewsModel> fetchedPopularNews = fetchedAllNews
          .where((news) =>
              news.likedBy != null &&
              news.likedBy!.isNotEmpty) // only consider news with likes
          .toList()
        ..sort((a, b) => b.likedBy!.length
            .compareTo(a.likedBy!.length)) // sort by number of likes
        ..take(5) // take only the top five news with the most likes
            .toList();

      final List<NewsModel> fetchedLatestNews = (await NewsService().getAllBy(
        fieldName: 'createdAt',
        desc: true,
        limit: 5,
      ))
          .whereType<NewsModel>()
          .toList();

      setState(() {
        loading = false;
        allList = [
          fetchedPopularNews,
          fetchedLatestNews,
        ];
      });
    } catch (e) {
      print("Error Get All Type of News:  ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const SkeletonNews()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: GestureDetector(
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
                    user: widget.user!,
                  );

                  if (context.mounted) {
                    Navigator.of(widget.mainContext, rootNavigator: true).pop();
                  }
                },
                child: TextField(
                  readOnly: false,
                  autofocus: false,
                  enabled: false,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? CupertinoColors.darkBackgroundGray
                        : Colors.white,
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(
                        color: CupertinoColors.systemGrey,
                        width: 1,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search for news',
                  ),
                ),
              ),
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshData,
              child: Builder(builder: (context) {
                final List<NewsModel> popularNewsList = allList[0];
                final List<NewsModel> latestNewsList = allList[1];

                return ListView(
                  children: [
                    // Popular News
                    popularNewsList.isEmpty
                        ? const SizedBox()
                        : newsSection(
                            context: context,
                            mainContext: widget.mainContext,
                            title: 'Popular News',
                            newsList: popularNewsList,
                            user: widget.user!,
                          ),
                    const SizedBox(height: 5),
                    // Latest News
                    latestNewsList.isEmpty
                        ? const SizedBox()
                        : newsSection(
                            context: context,
                            mainContext: widget.mainContext,
                            title: 'Latest News',
                            newsList: latestNewsList,
                            user: widget.user!,
                          ),
                    const SizedBox(height: 40),
                  ],
                );
              }),
            ),
          );
  }
}
