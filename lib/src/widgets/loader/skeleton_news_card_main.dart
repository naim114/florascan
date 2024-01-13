import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget skeletonNewsCardMain({
  required BuildContext context,
}) {
  return Container(
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
        Shimmer.fromColors(
          baseColor: CupertinoColors.systemGrey,
          highlightColor: CupertinoColors.systemGrey2,
          child: Container(
            color: Colors.grey,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.05,
          ),
        ),
        const SizedBox(height: 12.5),
        Shimmer.fromColors(
          baseColor: CupertinoColors.systemGrey,
          highlightColor: CupertinoColors.systemGrey2,
          child: Container(
            color: Colors.grey,
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.05,
          ),
        ),
        const SizedBox(height: 20),
        // Thumbnail
        Shimmer.fromColors(
          baseColor: CupertinoColors.systemGrey,
          highlightColor: CupertinoColors.systemGrey2,
          child: Container(
            color: Colors.grey,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
        ),
        const SizedBox(height: 10),
        // By
        Container(
          color: CupertinoColors.systemGrey,
          width: double.infinity,
        ),
        const SizedBox(height: 3),
        // Date & Like
        Container(
          color: CupertinoColors.systemGrey,
          width: double.infinity,
        ),
      ],
    ),
  );
}
