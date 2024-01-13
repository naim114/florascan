import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/helpers.dart';
import '../../widgets/typography/page_title_icon.dart';
import 'menu.dart';

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
              // bottom: 10,
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
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 5.0,
            ),
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
                  hintText: 'Search for plant disease',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/noimage.png'),
                  radius: 25.0,
                ),
                title: Text(
                  "Disease Name",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getColorByBackground(context)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                subtitle: Text('Scientific Name'),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                onTap: () => Navigator.of(mainContext).push(
                  MaterialPageRoute(
                    builder: (context) => DiseaseInfoMenu(
                      title: 'Disease B',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
