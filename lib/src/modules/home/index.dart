import 'package:florascan/src/modules/home/news_row.dart';
import 'package:florascan/src/services/helpers.dart';
import 'package:flutter/cupertino.dart';
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
        actions: [
          Builder(
            builder: (BuildContext builderContext) {
              return IconButton(
                onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
                icon: Icon(
                  Icons.settings,
                  color: getColorByBackground(context),
                ),
              );
            },
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