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
    apiKey: 'AIzaSyDm3_pBE8UiM8vYMCGGWiDQSrqtS8mFvmc',
    appId: '1:388125679598:web:03fdc500412bf128c438ff',
    messagingSenderId: '388125679598',
    projectId: 'drive-safe-166cc',
    authDomain: 'drive-safe-166cc.firebaseapp.com',
    storageBucket: 'drive-safe-166cc.firebasestorage.app',
    measurementId: 'G-ZLTW69273K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7WI03GJ2L5BuEq8dBGQvY8KKK_3l1OOk',
    appId: '1:388125679598:android:ec19a5e83c1715fbc438ff',
    messagingSenderId: '388125679598',
    projectId: 'drive-safe-166cc',
    storageBucket: 'drive-safe-166cc.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFyU2i793TYdctyJiEufzJfmS3t9udKFA',
    appId: '1:388125679598:ios:fc7571533fe4a3e9c438ff',
    messagingSenderId: '388125679598',
    projectId: 'drive-safe-166cc',
    storageBucket: 'drive-safe-166cc.firebasestorage.app',
    iosBundleId: 'com.example.driveSafe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDFyU2i793TYdctyJiEufzJfmS3t9udKFA',
    appId: '1:388125679598:ios:fc7571533fe4a3e9c438ff',
    messagingSenderId: '388125679598',
    projectId: 'drive-safe-166cc',
    storageBucket: 'drive-safe-166cc.firebasestorage.app',
    iosBundleId: 'com.example.driveSafe',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDm3_pBE8UiM8vYMCGGWiDQSrqtS8mFvmc',
    appId: '1:388125679598:web:24afccd3d8205574c438ff',
    messagingSenderId: '388125679598',
    projectId: 'drive-safe-166cc',
    authDomain: 'drive-safe-166cc.firebaseapp.com',
    storageBucket: 'drive-safe-166cc.firebasestorage.app',
    measurementId: 'G-E5SK0642TJ',
  );
}
