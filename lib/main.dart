import 'package:florascan/src/services/helpers.dart';
import 'package:florascan/src/theme/theme_mode_manager.dart';
import 'package:florascan/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor primaryColorShades = const MaterialColor(
      0xFFF28500,
      <int, Color>{
        50: Color(0xffda7800),
        100: Color(0xffc26a00),
        200: Color(0xffa95d00),
        300: Color(0xff915000),
        400: Color(0xff794300),
        500: Color(0xff613500),
        600: Color(0xff492800),
        700: Color(0xff301b00),
        800: Color(0xff180d00),
        900: Color(0xff000000),
      },
    );

    return ThemeModeHandler(
      manager: MyThemeModeManager(),
      placeholderWidget: MaterialApp(
        home: Scaffold(
          body: Center(
            child: LoadingAnimationWidget.flickr(
              leftDotColor: CustomColor.primary,
              rightDotColor: CustomColor.secondary,
              size: 50,
            ),
          ),
        ),
      ),
      builder: (ThemeMode themeMode) => MaterialApp(
        themeMode: themeMode,
        // DARK THEME
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: GoogleFonts.ptSans().fontFamily,
          primarySwatch: primaryColorShades,
          primaryColor: CustomColor.primary,
          textTheme: GoogleFonts.ptSansTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
          ),
          scaffoldBackgroundColor: CustomColor.darkerBg,
          appBarTheme: const AppBarTheme(
              backgroundColor: CustomColor.darkerBg,
              // titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(
                color: CustomColor.neutral2,
              )),
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: CustomColor.darkerBg,
            filled: true,
          ),
        ),
        // LIGHT THEME
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: GoogleFonts.ptSans().fontFamily,
          primarySwatch: primaryColorShades,
          primaryColor: CustomColor.primary,
          textTheme: GoogleFonts.ptSansTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: CustomColor.neutral1,
                  displayColor: CustomColor.neutral1,
                ),
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              // titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(
                color: CustomColor.neutral2,
              )),
          iconTheme: const IconThemeData(
            color: CustomColor.neutral1,
          ),
          iconButtonTheme: const IconButtonThemeData(
            style: ButtonStyle(
                iconColor: MaterialStatePropertyAll(CustomColor.neutral1)),
          ),
        ),
        home: const Wrapper(),
      ),
    );
  }
}
