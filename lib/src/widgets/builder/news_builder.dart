import 'package:flutter/material.dart';

import '../../models/news_model.dart';
import '../../models/user_model.dart';
import '../../modules/admin/news/index.dart';
import '../../services/news_services.dart';

class NewsBuilder extends StatefulWidget {
  const NewsBuilder({
    super.key,
    required this.currentUser,
    required this.pushTo,
  });
  final UserModel currentUser;
  final String pushTo;

  @override
  State<NewsBuilder> createState() => _NewsBuilderState();
}

class _NewsBuilderState extends State<NewsBuilder> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<NewsModel> newsList = List.empty(growable: true);
  bool loading = true;

  Future<void> _refreshData() async {
    try {
      // Call the asynchronous operation to fetch data
      final List<NewsModel> fetchedNews =
          widget.currentUser.role!.name == 'super_admin'
              ? (await NewsService().getAll()).whereType<NewsModel>().toList()
              : (await NewsService().getBy('author', widget.currentUser.id))
                  .whereType<NewsModel>()
                  .toList();

      // Update the state with the fetched data and call setState to rebuild the UI
      setState(() {
        loading = false;
        newsList = fetchedNews;
      });

      // Trigger a refresh of the RefreshIndicator widget
      _refreshIndicatorKey.currentState?.show();
    } catch (e) {
      print("Get All News:  ${e.toString()}");
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
    return loading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshData,
            child: Builder(
              builder: (context) {
                if (widget.pushTo == 'AdminPanelNews') {
                  return AdminPanelNews(
                    currentUser: widget.currentUser,
                    newsList: newsList,
                    notifyRefresh: (refresh) {
                      _refreshData();
                    },
                  );
                } else {
                  return const Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                }
              },
            ),
          );
  }
}
