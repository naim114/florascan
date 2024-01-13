import 'package:flutter/material.dart';

import '../../models/news_model.dart';
import '../../models/user_model.dart';
import '../../services/helpers.dart';
import '../../services/news_services.dart';
import '../../widgets/card/news_card_main.dart';

class LikedNews extends StatefulWidget {
  final UserModel user;

  const LikedNews({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<LikedNews> createState() => _LikedNewsState();
}

class _LikedNewsState extends State<LikedNews> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<NewsModel?> newsList = [];
  bool loading = true;

  Future<void> _refreshData() async {
    try {
      final List<NewsModel?> fetch =
          await NewsService().getAllLikedBy(user: widget.user);

      setState(() {
        loading = false;
        newsList = fetch;
      });
    } catch (e) {
      print("Error Get Liked News: ${e.toString()}");
    }
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
          "Liked News",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshData,
              child: ListView.builder(
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  NewsModel news = newsList[index]!;

                  return newsCardMain(
                    context: context,
                    news: news,
                    user: widget.user,
                  );
                },
              ),
            ),
    );
  }
}
