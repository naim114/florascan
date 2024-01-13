import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../services/helpers.dart';

Widget indicatorScaffold({
  double size = 50,
  Color leftDotColor = CustomColor.primary,
  Color rightDotColor = CustomColor.secondary,
  Color backgroundColor = Colors.white,
}) =>
    Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: LoadingAnimationWidget.flickr(
          leftDotColor: leftDotColor,
          rightDotColor: rightDotColor,
          size: size,
        ),
      ),
    );
