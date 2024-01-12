import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget cardInfoImage() => Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {},
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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.asset(
                'assets/images/noimage.png',
                fit: BoxFit.cover,
                width: double.infinity,
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
                    "Early Blight",
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
