import 'package:firebase_core/firebase_core.dart';
import 'package:florascan/firebase_options.dart';
import 'package:florascan/src/models/user_model.dart';
import 'package:florascan/src/services/auth_services.dart';
import 'package:florascan/src/services/helpers.dart';
import 'package:florascan/src/theme/theme_mode_manager.dart';
import 'package:florascan/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:theme_mode_handler/theme_mode_handler.dart';

import 'src/widgets/loader/indicator_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key _userModelKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      key: _userModelKey,
      initialData: null,
      lazy: true,
      value: AuthService().onAuthStateChanged,
      catchError: (context, error) {
        print('An error occurred: $error');
        return null;
      },
      updateShouldNotify: (previous, current) {
        print('Previous Stream UserModel: ${previous.toString()}');
        print('Current Stream UserModel: ${current.toString()}');
        return true;
      },
      child: ThemeModeHandler(
        manager: MyThemeModeManager(),
        placeholderWidget: MaterialApp(
          home: progressIndicatorScaffold(context: context),
        ),
        builder: (ThemeMode themeMode) => MaterialApp(
          themeMode: themeMode,
          // DARK THEME
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: CustomColor.primary,
              brightness: Brightness.dark,
            ),
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.ptSans().fontFamily,
            primarySwatch: CustomColorShades.primary(),
            primaryColor: CustomColor.primary,
            textTheme: GoogleFonts.ptSansTextTheme(
              Theme.of(context).textTheme.apply(
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
            ),
            expansionTileTheme: const ExpansionTileThemeData(
              backgroundColor: CustomColor.primaryDarkShade,
            ),
            scaffoldBackgroundColor: CustomColor.darkerBg,
            appBarTheme: const AppBarTheme(
                backgroundColor: CustomColor.darkerBg,
                surfaceTintColor: CustomColor.darkerBg,
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
            colorScheme: ColorScheme.fromSeed(
              seedColor: CustomColor.primary,
              brightness: Brightness.light,
            ),
            brightness: Brightness.light,
            fontFamily: GoogleFonts.ptSans().fontFamily,
            primarySwatch: CustomColorShades.primary(),
            primaryColor: CustomColor.primary,
            textTheme: GoogleFonts.ptSansTextTheme(
              Theme.of(context).textTheme.apply(
                    bodyColor: CustomColor.neutral1,
                    displayColor: CustomColor.neutral1,
                  ),
            ),
            expansionTileTheme: const ExpansionTileThemeData(
              backgroundColor: CustomColor.primaryShade,
            ),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              // titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(
                color: CustomColor.neutral2,
              ),
            ),
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
      ),
    );
  }
}
