import 'package:flutter/material.dart';

import '../../models/news_model.dart';
import '../../models/user_model.dart';
import '../../widgets/card/news_card.dart';
import '../../widgets/card/news_card_main.dart';
import 'news_view.dart';

Widget newsSection({
  required BuildContext context,
  required BuildContext mainContext,
  required List<NewsModel?> newsList,
  required UserModel user,
  required String title,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        newsCardMain(
          context: mainContext,
          news: newsList[0]!,
          user: user,
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
                  NewsModel news = newsList[index + 1]!;

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
                          news.likedBy == null ? 0 : news.likedBy!.length,
                      onTap: () => Navigator.of(mainContext).push(
                        MaterialPageRoute(
                          builder: (context) => NewsView(
                            mainContext: mainContext,
                            news: news,
                            user: user,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
