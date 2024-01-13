import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/helpers.dart';
import '../../widgets/list_tile/list_tile_icon.dart';
import 'bookmarked.dart';
import 'liked.dart';

class NewsMenu extends StatelessWidget {
  const NewsMenu({super.key, required this.user});

  final UserModel user;

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
          "News",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: ListView(
        children: [
          // Liked News
          listTileIcon(
            context: context,
            icon: CupertinoIcons.heart_fill,
            title: "Liked News",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LikedNews(user: user),
              ),
            ),
          ),
          // Bookmarked News
          listTileIcon(
            context: context,
            icon: CupertinoIcons.bookmark_fill,
            title: "Bookmarked News",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BookmarkedNews(user: user),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
