import 'package:flutter/material.dart';

import '../../services/helpers.dart';

class DiseaseInfoMenu extends StatelessWidget {
  const DiseaseInfoMenu({
    super.key,
    required this.title,
  });

  final String title;

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
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 25, right: 20),
            title: const Text("Manual Identification"),
            onTap: () {},
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 25, right: 20),
            title: const Text("Treatment"),
            onTap: () {},
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 25, right: 20),
            title: const Text("Prevention"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
