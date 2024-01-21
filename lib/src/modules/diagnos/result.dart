import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/helpers.dart';

class DiagnosisResult extends StatelessWidget {
  const DiagnosisResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            color: getColorByBackground(context),
            icon: const Icon(
              Icons.check_outlined,
              color: CustomColor.primary,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        title: Text(
          "Diagnosis Result",
          style: TextStyle(
            color: getColorByBackground(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Image.asset(
              'assets/images/noimage.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 25,
              right: 25,
            ),
            child: Text(
              "Label:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 25,
              right: 25,
            ),
            child: Text(
              "Early Blight",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 25,
              right: 25,
            ),
            child: Text(
              "Confidence:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8.0,
              left: 25,
              right: 25,
            ),
            child: Text(
              "87.25%",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            tileColor: isDarkTheme(context)
                ? CupertinoColors.systemGrey
                : CupertinoColors.lightBackgroundGray,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Read more about this disease",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 25.0,
              right: 25.0,
              top: 30,
              bottom: 10,
            ),
            child: Text(
              "Choose below to diagnose again.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.image,
              color: Colors.white,
            ),
            tileColor: CustomColor.secondary,
            title: const Text(
              'Upload Image from Gallery',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DiagnosisResult(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.camera,
              color: Colors.white,
            ),
            tileColor: CustomColor.secondary,
            title: const Text(
              'Snap Photo with Camera',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DiagnosisResult(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
