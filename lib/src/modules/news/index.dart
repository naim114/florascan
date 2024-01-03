import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'news_section.dart';

class IndexNews extends StatefulWidget {
  const IndexNews({
    super.key,
    required this.mainContext,
  });
  final BuildContext mainContext;

  @override
  State<IndexNews> createState() => _IndexNewsState();
}

class _IndexNewsState extends State<IndexNews> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          height: MediaQuery.of(context).size.height * 0.045,
          child: GestureDetector(
            onTap: () async {},
            child: TextField(
              readOnly: false,
              autofocus: false,
              enabled: false,
              decoration: InputDecoration(
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? CupertinoColors.darkBackgroundGray
                    : Colors.white,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(
                    color: CupertinoColors.systemGrey,
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.all(0),
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search news',
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          // Latest News
          const SizedBox(height: 5),
          newsSection(
            context: context,
            mainContext: widget.mainContext,
            title: 'More News',
          ),
          const SizedBox(height: 5),
          // Popular News
          newsSection(
            context: context,
            mainContext: widget.mainContext,
            title: 'Popular News',
          ),
          const SizedBox(height: 5),
          // Latest News
          newsSection(
            context: context,
            mainContext: widget.mainContext,
            title: 'Latest News',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
