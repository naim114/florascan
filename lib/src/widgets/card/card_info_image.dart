import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../modules/info/menu.dart';

Widget cardInfoImage({
  required BuildContext mainContext,
  required String name,
  required String imgURL,
  required String altName,
}) =>
    Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () => Navigator.of(mainContext).push(
          MaterialPageRoute(
            builder: (context) => DiseaseInfoMenu(
              name: name,
              imgURL: imgURL,
              altName: altName,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // trivia.imgURL == null
            //     ? ClipRRect(
            //         borderRadius: const BorderRadius.only(
            //           topLeft: Radius.circular(8.0),
            //           topRight: Radius.circular(8.0),
            //         ),
            //         child: Image.asset(
            //           'assets/images/noimage.png',
            //           fit: BoxFit.cover,
            //           height: MediaQuery.of(context).size.height * 0.15,
            //           width: double.infinity,
            //         ),
            //       )
            //     : SizedBox(
            //         height: MediaQuery.of(context).size.height * 0.15,
            //         width: double.infinity,
            //         child: ClipRRect(
            //           borderRadius: const BorderRadius.only(
            //             topLeft: Radius.circular(8.0),
            //             topRight: Radius.circular(8.0),
            //           ),
            //           child: CachedNetworkImage(
            //             imageUrl: trivia.imgURL!,
            //             fit: BoxFit.cover,
            //             placeholder: (context, url) => Shimmer.fromColors(
            //               baseColor: CupertinoColors.systemGrey,
            //               highlightColor: CupertinoColors.systemGrey2,
            //               child: Container(color: Colors.grey),
            //             ),
            //           ),
            //         ),
            //       ),
            SizedBox(
              height: MediaQuery.of(mainContext).size.height * 0.15,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: imgURL,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: CupertinoColors.systemGrey,
                    highlightColor: CupertinoColors.systemGrey2,
                    child: Container(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
