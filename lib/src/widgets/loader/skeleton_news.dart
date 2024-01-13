import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'skeleton_news_card_main.dart';

class SkeletonNews extends StatelessWidget {
  const SkeletonNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          skeletonNewsCardMain(context: context),
          skeletonNewsCardMain(context: context),
          skeletonNewsCardMain(context: context),
          skeletonNewsCardMain(context: context),
          skeletonNewsCardMain(context: context),
        ],
      ),
    );
  }
}
