import 'package:florascan/src/widgets/carousel/carousel_news.dart';
import 'package:flutter/material.dart';

import '../../services/helpers.dart';

Widget newsRow({
  required BuildContext context,
  required BuildContext mainContext,
  String title = "Read latest news",
  IconData icon = Icons.announcement,
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, bottom: 5),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: getColorByBackground(context),
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 5)),
                WidgetSpan(
                  child: Icon(
                    icon,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        CarouselNews(
          mainContext: mainContext,
        )
      ],
    );
