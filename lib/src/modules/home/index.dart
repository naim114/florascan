import 'package:florascan/src/modules/home/news_row.dart';
import 'package:florascan/src/services/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
    required this.mainContext,
  });

  final BuildContext mainContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Placeholder(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: isDarkTheme(context)
                  ? CustomColor.darkBg
                  : CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          newsRow(
            context: context,
            mainContext: mainContext,
            title: "Read more about plant disease",
            icon: Icons.info,
          ),
          newsRow(
            context: context,
            mainContext: mainContext,
          ),
        ],
      ),
    );
  }
}
