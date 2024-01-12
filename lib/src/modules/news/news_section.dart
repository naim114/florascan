import 'package:flutter/material.dart';

import '../../widgets/card/news_card.dart';
import '../../widgets/card/news_card_main.dart';

class News {
  final String title;
  final String? imgURL; // Use nullable String for image URL
  final DateTime createdAt;

  News({
    required this.title,
    required this.imgURL,
    required this.createdAt,
  });
}

// Dummy data for the newsList
List<News> newsList = [
  News(
    title: 'Breaking News 1',
    imgURL: 'https://dummyimage.com/1280x1000/2600fa/ffffff.png&text=example',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  News(
    title: 'Latest Update 2',
    imgURL: 'https://dummyimage.com/1280x1000/fc0037/ffffff.png&text=example',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  News(
    title: 'Important Announcement 3',
    imgURL: 'https://dummyimage.com/1280x1000/e9fa00/ffffff.png&text=example',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];

Widget newsSection({
  required BuildContext context,
  required BuildContext mainContext,
  required String title,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        newsCardMain(
          context: mainContext,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, bottom: 5),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                newsList.length - 1,
                (index) {
                  News news = newsList[index + 1];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: newsCard(
                      context: context,
                      imageURL: news.imgURL,
                      title: news.title,
                      date: news.createdAt,
                      likeCount:
                          // news.likedBy == null ? 0 : news.likedBy!.length,
                          24,
                      onTap: () {
                        // return Navigator.of(mainContext).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => NewsView(
                        //       mainContext: mainContext,
                        //       news: news,
                        //       user: user,
                        //     ),
                        //   ),
                        // );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
