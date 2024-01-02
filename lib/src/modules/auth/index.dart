import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../services/helpers.dart';
import '../../widgets/appbar/appbar_custom.dart';
import '../../widgets/button/button_custom_pill.dart';
import 'login.dart';
import 'sign_up.dart';

class AuthIndex extends StatelessWidget {
  const AuthIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom(
        context: context,
        onPressed: () {},
        noBackButton: true,
        actions: [
          IconButton(
            key: const Key('theme_button'),
            icon: isDarkTheme(context)
                ? const Icon(CupertinoIcons.moon_fill)
                : const Icon(CupertinoIcons.sun_max_fill),
            color: getColorByBackground(context),
            onPressed: () => selectThemeMode(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // logoMain(context: context, height: 50),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(children: [
                SvgPicture.asset(
                  'assets/images/illustration.svg',
                  semanticsLabel: 'News at Your Fingertips',
                  height: MediaQuery.of(context).size.height * 0.45,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Where Knowledge and Fun Collide',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            ),
            Container(
              child: Column(
                children: [
                  registerButton(context: context),
                  const SizedBox(height: 10),
                  loginButton(context: context),
                  const SizedBox(height: 15),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        style: const TextStyle(height: 1.5),
                        children: [
                          TextSpan(
                            text: 'By signing up you accept the ',
                            style:
                                TextStyle(color: getColorByBackground(context)),
                          ),
                          TextSpan(
                            text: 'Term & Conditions',
                            style: TextStyle(
                              color: getColorByBackground(context),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => goToURL(
                                    context: context,
                                    url:
                                        // Uri.parse(appSettings.urlTermCondition),
                                        Uri.parse('www.google.com'),
                                  ),
                          ),
                          TextSpan(
                            text: ' and ',
                            style:
                                TextStyle(color: getColorByBackground(context)),
                          ),
                          TextSpan(
                            text: 'Privacy Policy.',
                            style: TextStyle(
                              color: getColorByBackground(context),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => goToURL(
                                    context: context,
                                    url:
                                        // Uri.parse(appSettings.urlPrivacyPolicy),
                                        Uri.parse('www.google.com'),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget registerButton({
  required BuildContext context,
}) =>
    Container(
      decoration: BoxDecoration(
        color: CustomColor.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        ),
        onPressed: () => showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.25,
              color: isDarkTheme(context)
                  ? CupertinoColors.darkBackgroundGray
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Scroll indicator
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        width: 40,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        decoration: const BoxDecoration(
                          color: CupertinoColors.systemGrey,
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        child: const SizedBox(
                          height: 5,
                        ),
                      ),
                    ),
                    // Google
                    buttonCustomPill(
                      context: context,
                      borderColor: CustomColor.primary,
                      fillColor: Colors.transparent,
                      onPressed: () async {
                        Navigator.pop(context);

                        // try {
                        //   final result =
                        //       await AuthService().continueWithGoogle();

                        //   print("Continue With Google: ${result.toString()}");
                        // } catch (e) {
                        //   print(e.toString());
                        //   Fluttertoast.showToast(msg: e.toString());
                        // }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/google.svg',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: isDarkTheme(context)
                                  ? Colors.white
                                  : CustomColor.neutral1, // Text color
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Email
                    buttonCustomPill(
                      context: context,
                      borderColor: CustomColor.primary,
                      fillColor: Colors.transparent,
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.mail,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Register with Email',
                            style: TextStyle(
                              color: isDarkTheme(context)
                                  ? Colors.white
                                  : CustomColor.neutral1, // Text color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        child: const Text(
          'Create an account',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget loginButton({
  required BuildContext context,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: CustomColor.primary,
          width: 2,
        ),
        color: Colors.transparent,
      ),
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        ),
        onPressed: () => showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.25,
              color: isDarkTheme(context)
                  ? CupertinoColors.darkBackgroundGray
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Scroll indicator
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        width: 40,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        decoration: const BoxDecoration(
                          color: CupertinoColors.systemGrey,
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        child: const SizedBox(
                          height: 5,
                        ),
                      ),
                    ),
                    // Google
                    buttonCustomPill(
                      context: context,
                      borderColor: CustomColor.primary,
                      fillColor: Colors.transparent,
                      onPressed: () async {
                        Navigator.pop(context);

                        // try {
                        //   final result =
                        //       await AuthService().continueWithGoogle();

                        //   print("Continue With Google: ${result.toString()}");
                        // } catch (e) {
                        //   print(e.toString());
                        //   Fluttertoast.showToast(msg: e.toString());
                        // }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/google.svg',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: isDarkTheme(context)
                                  ? Colors.white
                                  : CustomColor.neutral1, // Text color
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Email
                    buttonCustomPill(
                      context: context,
                      borderColor: CustomColor.primary,
                      fillColor: Colors.transparent,
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const LogIn()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.mail,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Continue with Email',
                            style: TextStyle(
                              color: isDarkTheme(context)
                                  ? Colors.white
                                  : CustomColor.neutral1, // Text color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        child: Text(
          'Continue',
          style: TextStyle(
            color: isDarkTheme(context)
                ? Colors.white
                : CustomColor.primary, // Text color
          ),
        ),
      ),
    );
