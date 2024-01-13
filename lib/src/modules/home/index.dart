import 'package:florascan/src/modules/home/info_category_section.dart';
import 'package:florascan/src/modules/home/news_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/news_model.dart';
import '../../models/user_model.dart';
import '../../services/news_services.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.mainContext,
    required this.scaffoldKey,
    required this.user,
  }) : super(key: key);

  final BuildContext mainContext;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final UserModel? user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<List<Object>> allList = [
    [], // news
    [], // category
  ];

  bool loading = true;

  Future<void> _refreshData() async {
    // news
    List<NewsModel> newsList = await NewsService().getStarredNews();

    setState(() {
      loading = false;
      allList = [
        newsList, // news
        [], // category
      ];
    });

    // Trigger a refresh of the RefreshIndicator widget
    _refreshIndicatorKey.currentState?.show();
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Placeholder(),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: Builder(builder: (context) {
          final List<NewsModel> starredNewsList =
              List<NewsModel>.from(allList[0]);
          final List category = [];

          return ListView(
            children: [
              GestureDetector(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 20,
                  ),
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(CupertinoIcons.leaf_arrow_circlepath),
                          title: Text('Get Started'),
                          subtitle:
                              Text('Tap on here to diagnose plant disease.'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              starredNewsList.isEmpty
                  ? const SizedBox()
                  : newsRow(
                      context: context,
                      mainContext: widget.mainContext,
                      title: "Plant disease articles",
                      icon: Icons.info,
                      newsList: starredNewsList,
                      user: widget.user!,
                    ),
              infoCategorySection(context: context),
              const SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }
}
