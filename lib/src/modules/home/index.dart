import 'package:florascan/src/modules/home/news_row.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
    required this.mainContext,
    required this.scaffoldKey,
  }) : super(key: key);

  final BuildContext mainContext;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Placeholder(),
      ),
      body: ListView(
        children: [
          newsRow(
            context: context,
            mainContext: mainContext,
            title: "Get Started",
            icon: Icons.info,
          ),
        ],
      ),
    );
  }
}
