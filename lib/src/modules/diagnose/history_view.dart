import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/diagnose_history_model.dart';

class DiagnoseHistoryView extends StatelessWidget {
  final DiagnoseHistoryModel diagnose;
  const DiagnoseHistoryView({super.key, required this.diagnose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diagnosis Result"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CachedNetworkImage(
              imageUrl: diagnose.imgURL,
              fit: BoxFit.cover,
              width: 300,
              height: 300,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: CupertinoColors.systemGrey,
                highlightColor: CupertinoColors.systemGrey2,
                child: Container(
                  color: Colors.grey,
                  width: 300,
                  height: 300,
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/noimage.png',
                fit: BoxFit.cover,
                width: 300,
                height: 300,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
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
              diagnose.disease == null ? "Healthy" : diagnose.disease!.name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              left: 25,
              right: 25,
            ),
            child: Text(
              "Confidence Percentage:",
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
              "${diagnose.confidence.toStringAsFixed(2)}%",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              left: 25,
              right: 25,
            ),
            child: Text(
              "Date & Time:",
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
              DateFormat('dd/MM/yyyy hh:mm a').format(diagnose.dateTime),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
