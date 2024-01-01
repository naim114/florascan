import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

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
List<News?> newsList = [
  News(
    title: 'Breaking News 1',
    imgURL: 'https://dummyimage.com/600x400/2600fa/ffffff.png&text=example',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  News(
    title: 'Latest Update 2',
    imgURL: 'https://dummyimage.com/600x400/fc0037/ffffff.png&text=example',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  News(
    title: 'Important Announcement 3',
    imgURL: 'https://dummyimage.com/600x400/e9fa00/ffffff.png&text=example',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];

List<Widget> imageSliders({
  required BuildContext mainContext,
}) =>
    newsList
        .map((news) => ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: GestureDetector(
              // onTap: () => Navigator.of(mainContext).push(
              //   MaterialPageRoute(
              //     builder: (context) => NewsView(
              //       mainContext: mainContext,
              //       news: news,
              //       user: user,
              //     ),
              //   ),
              // ),
              onTap: () {},
              child: Stack(
                children: <Widget>[
                  news!.imgURL == null
                      ? Image.asset(
                          'assets/images/noimage.png',
                          fit: BoxFit.cover,
                          height: 500,
                          width: 1000,
                        )
                      : CachedNetworkImage(
                          imageUrl: news.imgURL!,
                          fit: BoxFit.cover,
                          height: 600,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: CupertinoColors.systemGrey,
                            highlightColor: CupertinoColors.systemGrey2,
                            child: Container(
                              color: Colors.grey,
                              height: 500,
                              width: 1000,
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/noimage.png',
                            fit: BoxFit.cover,
                            height: 500,
                            width: 1000,
                          ),
                        ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(
                          news.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text.rich(
                          TextSpan(
                            children: [
                              const WidgetSpan(
                                child: Icon(
                                  Icons.access_time,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      " ${DateFormat('dd/MM/yyyy').format(news.createdAt)}",
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )))
        .toList();
