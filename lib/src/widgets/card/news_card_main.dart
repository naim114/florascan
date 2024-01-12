import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/helpers.dart';

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

News news = News(
  title: 'Breaking News 1',
  imgURL: 'https://dummyimage.com/1280x1000/2600fa/ffffff.png&text=example',
  createdAt: DateTime.now().subtract(const Duration(days: 1)),
);

Widget newsCardMain({
  required BuildContext context,
}) {
  return InkWell(
    onTap: () {
      //   Navigator.of(context).push(
      //   MaterialPageRoute(
      //       builder: (context) => NewsView(
      //             mainContext: context,
      //             news: news,
      //             user: user,
      //           )),
      // );
    },
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            news.title,
            style: TextStyle(
              color: getColorByBackground(context),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          // Description
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              "Lorem ipsum dolor amet sit",
              style:
                  TextStyle(color: getColorByBackground(context), fontSize: 18),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 20),
          // Thumbnail
          news.imgURL == null
              ? Image.asset(
                  'assets/images/noimage.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                )
              : CachedNetworkImage(
                  imageUrl: news.imgURL!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: CupertinoColors.systemGrey,
                    highlightColor: CupertinoColors.systemGrey2,
                    child: Container(
                      color: Colors.grey,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/noimage.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
          const SizedBox(height: 10),
          // By
          Text(
            // "By ${news.author!.name}",
            "By Person A",
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 3),
          // Date & Like
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
                color: CupertinoColors.systemGrey,
              ),
              const SizedBox(width: 2),
              Text(
                DateFormat('dd/MM/yyyy').format(news.createdAt),
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                CupertinoIcons.heart_fill,
                size: 14,
                color: CupertinoColors.systemGrey,
              ),
              Text(
                ' 12',
                // ' ${news.likedBy == null ? 0 : news.likedBy!.length}',
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
