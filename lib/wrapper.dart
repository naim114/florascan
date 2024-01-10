import 'package:florascan/src/models/user_model.dart';
import 'package:florascan/src/modules/main/index.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'src/modules/auth/index.dart';
import 'src/services/helpers.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel?>();

    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Center(
                child: LoadingAnimationWidget.flickr(
                  leftDotColor: CustomColor.primary,
                  rightDotColor: CustomColor.secondary,
                  size: 50,
                ),
              ),
            ),
          );
        } else {
          if (user == null) {
            return const AuthIndex();
          } else {
            return const FrontFrame();
          }
        }
      },
    );
  }
}
