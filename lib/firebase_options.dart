// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB5REr8pchMch5sz1e7l11_ElioFFEI2NI',
    appId: '1:129075236084:web:629287ebb066c2e41522a1',
    messagingSenderId: '129075236084',
    projectId: 'florascan',
    authDomain: 'florascan.firebaseapp.com',
    storageBucket: 'florascan.appspot.com',
    measurementId: 'G-SB8RZBDB08',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnhl3Qgt-6LjAaoVzRA9Jm1uWGAQakhDQ',
    appId: '1:129075236084:android:d15c90ff10be6e791522a1',
    messagingSenderId: '129075236084',
    projectId: 'florascan',
    storageBucket: 'florascan.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqkyssOAXGJEYx4xtwqGb_AgW92szVf0c',
    appId: '1:129075236084:ios:c360efca3bfb1cd11522a1',
    messagingSenderId: '129075236084',
    projectId: 'florascan',
    storageBucket: 'florascan.appspot.com',
    iosBundleId: 'com.example.florascan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBqkyssOAXGJEYx4xtwqGb_AgW92szVf0c',
    appId: '1:129075236084:ios:538a83940098dd291522a1',
    messagingSenderId: '129075236084',
    projectId: 'florascan',
    storageBucket: 'florascan.appspot.com',
    iosBundleId: 'com.example.florascan.RunnerTests',
  );
}
