import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget circleImage({
  double width = 5,
  double height = 5,
  String? imgURL,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: imgURL == null
        ? Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image:
                      AssetImage('assets/images/default-profile-picture.png'),
                  fit: BoxFit.cover),
            ),
          )
        : CachedNetworkImage(
            imageUrl: imgURL!,
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: CupertinoColors.systemGrey,
              highlightColor: CupertinoColors.systemGrey2,
              child: Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              ),
            ),
            errorWidget: (context, url, error) {
              print("Circle Image Error: $error");
              return Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/noimage.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
  );
}
