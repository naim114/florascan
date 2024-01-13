import 'package:carousel_slider/carousel_slider.dart';
import 'package:florascan/src/widgets/slider/slider_images.dart';
import 'package:flutter/material.dart';

import '../../models/news_model.dart';
import '../../models/user_model.dart';

class CarouselNews extends StatefulWidget {
  const CarouselNews({
    super.key,
    required this.mainContext,
    required this.newsList,
    required this.user,
  });
  final BuildContext mainContext;
  final List<NewsModel> newsList;
  final UserModel user;

  @override
  State<CarouselNews> createState() => _CarouselNewsState();
}

class _CarouselNewsState extends State<CarouselNews> {
  int current = 0;
  final CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 23.0, bottom: 5),
          child: CarouselSlider(
            items: sliderImages(
              newsList: widget.newsList,
              mainContext: widget.mainContext,
              user: widget.user,
            ),
            carouselController: controller,
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2,
              onPageChanged: (index, reason) => setState(() => current = index),
            ),
          ),
        ),
        slideIndicator(
          context: context,
          controller: controller,
          current: current,
        ),
      ],
    );
  }

  Widget slideIndicator({
    required int current,
    required BuildContext context,
    required CarouselController controller,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.newsList.asMap().entries.map((entry) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: current == entry.key
                ? Container(
                    width: 20,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(
                        current == entry.key ? 0.9 : 0.4,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                    ),
                    child: const SizedBox(
                      height: 5,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      controller.animateToPage(entry.key);
                      setState(() {
                        current = entry.key;
                      });
                    },
                    child: Container(
                      width: 8,
                      height: 5,
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(
                          current == entry.key ? 0.9 : 0.4,
                        ),
                      ),
                    ),
                  ),
          );
        }).toList(),
      );
}
