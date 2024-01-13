import 'package:flutter/material.dart';
import '../../models/news_model.dart';
import '../../models/user_model.dart';
import '../../services/helpers.dart';
import '../../services/news_services.dart';
import '../../widgets/card/news_card_main.dart';

class BookmarkedNews extends StatefulWidget {
  final UserModel user;

  const BookmarkedNews({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<BookmarkedNews> createState() => BookmarkedNewsState();
}

class BookmarkedNewsState extends State<BookmarkedNews> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<NewsModel?> newsList = [];
  bool loading = true;

  Future<void> _refreshData() async {
    try {
      final List<NewsModel?> fetch =
          await NewsService().getAllBookmarkedBy(user: widget.user);

      setState(() {
        newsList = fetch;
        loading = false;
      });
    } catch (e) {
      print("Error Get Bookmarked News: ${e.toString()}");
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
          "Bookmarked News",
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
