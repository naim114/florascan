import 'package:florascan/src/modules/info/menu.dart';
import 'package:flutter/material.dart';

import '../../widgets/typography/page_title_icon.dart';

class Info extends StatelessWidget {
  const Info({super.key, required this.mainContext});
  final BuildContext mainContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 25,
              left: 25,
              right: 25,
              bottom: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pageTitleIcon(
                  context: context,
                  title: "Plant Disease Info",
                  icon: const Icon(
                    Icons.info,
                    size: 20,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Get all the information about plant disease here.',
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Tomato",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 25, right: 20),
            title: Text("Disease A"),
            trailing: const Icon(Icons.arrow_right),
            onTap: () => Navigator.of(mainContext).push(
              MaterialPageRoute(
                builder: (context) => DiseaseInfoMenu(
                  title: 'Disease A',
                ),
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 25, right: 20),
            title: Text("Disease B"),
            trailing: const Icon(Icons.arrow_right),
            onTap: () => Navigator.of(mainContext).push(
              MaterialPageRoute(
                builder: (context) => DiseaseInfoMenu(
                  title: 'Disease B',
                ),
              ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 25, right: 20),
            title: Text("Disease C"),
            trailing: const Icon(Icons.arrow_right),
            onTap: () => Navigator.of(mainContext).push(
              MaterialPageRoute(
                builder: (context) => DiseaseInfoMenu(
                  title: 'Disease C',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
