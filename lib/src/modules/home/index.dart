import 'package:florascan/src/modules/home/info_category_section.dart';
import 'package:florascan/src/modules/home/news_row.dart';
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
        title: const Placeholder(),
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                top: 20,
              ),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(CupertinoIcons.leaf_arrow_circlepath),
                      title: Text('Get Started'),
                      subtitle: Text('Tap on here to diagnose plant disease.'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          newsRow(
            context: context,
            mainContext: mainContext,
            title: "Plant disease articles",
            icon: Icons.info,
          ),
          infoCategorySection(context: context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
