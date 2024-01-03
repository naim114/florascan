import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/helpers.dart';

Widget newsCard({
  required BuildContext context,
  required String? imageURL,
  required String title,
  required int likeCount,
  required DateTime date,
  required void Function() onTap,
}) =>
    GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: imageURL == null
                    ? Image.asset(
                        'assets/images/noimage.png',
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: imageURL,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: CupertinoColors.systemGrey,
                          highlightColor: CupertinoColors.systemGrey2,
                          child: Container(
                            color: Colors.grey,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/noimage.png',
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: getColorByBackground(context),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          DateFormat('dd/MM/yyyy').format(date),
                          style: TextStyle(
                            color: getColorByBackground(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          CupertinoIcons.heart_fill,
                          size: 14,
                          color: getColorByBackground(context),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "$likeCount",
                          style: TextStyle(
                            color: getColorByBackground(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
