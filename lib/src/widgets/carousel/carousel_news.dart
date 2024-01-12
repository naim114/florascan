import 'package:carousel_slider/carousel_slider.dart';
import 'package:florascan/src/widgets/slider/slider_image.dart';
import 'package:flutter/material.dart';

class News {
  final String title;
  final String? imgURL; // Use nullable String for image URL
  final DateTime createdAt;

  News({
    required this.title,
    required this.imgURL,
    required this.createdAt,
  });
}

// Dummy data for the newsList
List<News?> newsList = [
  News(
    title: 'Breaking News 1',
    imgURL: 'https://dummyimage.com/1000x600/00ff44/fff.png&text=example1',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  News(
    title: 'Latest Update 2',
    imgURL: 'https://dummyimage.com/1000x600/00ff44/fff.png&text=example2',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  News(
    title: 'Important Announcement 3',
    imgURL: 'https://dummyimage.com/1000x600/00ff44/fff.png&text=example3',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
];

class CarouselNews extends StatefulWidget {
  const CarouselNews({
    super.key,
    required this.mainContext,
  });
  final BuildContext mainContext;

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
            items: sliderImage(
              mainContext: widget.mainContext,
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
        children: newsList.asMap().entries.map((entry) {
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
