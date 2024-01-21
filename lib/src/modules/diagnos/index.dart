import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/typography/page_title_icon.dart';

class Diagnosis extends StatelessWidget {
  const Diagnosis({super.key, required this.mainContext});
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
                  title: "Diagnosis Plant Disease",
                  icon: const Icon(
                    Icons.energy_savings_leaf,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Text(
              'Choose available type of plants to diagnose.',
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
