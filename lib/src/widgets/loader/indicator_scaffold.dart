import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../services/helpers.dart';

Widget progressIndicatorScaffold({
  required BuildContext context,
  double size = 50,
  Color leftDotColor = CustomColor.primary,
  Color rightDotColor = CustomColor.secondary,
  Color? backgroundColor,
}) {
  Color bg = backgroundColor ?? getBgColorByBackground(context);

  return Scaffold(
    backgroundColor: bg,
    body: Center(
      child: LoadingAnimationWidget.flickr(
        leftDotColor: leftDotColor,
        rightDotColor: rightDotColor,
        size: size,
      ),
    ),
  );
}
