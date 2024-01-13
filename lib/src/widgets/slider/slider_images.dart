import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/news_model.dart';
import '../../models/user_model.dart';
import '../../modules/news/news_view.dart';

List<Widget> sliderImages({
  required List<NewsModel?> newsList,
  required UserModel user,
  required BuildContext mainContext,
}) =>
    newsList
        .map(
          (news) => ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: GestureDetector(
              onTap: () => Navigator.of(mainContext).push(
                MaterialPageRoute(
                  builder: (context) => NewsView(
                    mainContext: mainContext,
                    news: news,
                    user: user,
                  ),
                ),
              ),
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
                          // height: 600,
                          width: 1000,
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
            ),
          ),
        )
        .toList();
