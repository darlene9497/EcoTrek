// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDQJokz2H5tVv2oxo4cY8vS5afizgdmMKk',
    appId: '1:323208822213:web:5350c091d2e4f1b9665fac',
    messagingSenderId: '323208822213',
    projectId: 'ecotrak-ae8a9',
    authDomain: 'ecotrak-ae8a9.firebaseapp.com',
    storageBucket: 'ecotrak-ae8a9.appspot.com',
    measurementId: 'G-V1ZKX25099',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBifWqujp9FlevVL2q9H94FFq5DGQp_Ui4',
    appId: '1:323208822213:android:06ff43b55b2745d3665fac',
    messagingSenderId: '323208822213',
    projectId: 'ecotrak-ae8a9',
    storageBucket: 'ecotrak-ae8a9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBIAZyq2dsv_FaJVJdh5jY5fb3dvqpIObo',
    appId: '1:323208822213:ios:6111f0aff31019b4665fac',
    messagingSenderId: '323208822213',
    projectId: 'ecotrak-ae8a9',
    storageBucket: 'ecotrak-ae8a9.appspot.com',
    iosBundleId: 'com.example.ecotrek',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBIAZyq2dsv_FaJVJdh5jY5fb3dvqpIObo',
    appId: '1:323208822213:ios:6111f0aff31019b4665fac',
    messagingSenderId: '323208822213',
    projectId: 'ecotrak-ae8a9',
    storageBucket: 'ecotrak-ae8a9.appspot.com',
    iosBundleId: 'com.example.ecotrek',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDQJokz2H5tVv2oxo4cY8vS5afizgdmMKk',
    appId: '1:323208822213:web:210add858e41f871665fac',
    messagingSenderId: '323208822213',
    projectId: 'ecotrak-ae8a9',
    authDomain: 'ecotrak-ae8a9.firebaseapp.com',
    storageBucket: 'ecotrak-ae8a9.appspot.com',
    measurementId: 'G-8MKY5F9P9F',
  );
}
