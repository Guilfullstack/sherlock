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
    apiKey: 'AIzaSyD3FaLKnQelB_Tw6NKLGyjvglb_hW7tYI4',
    appId: '1:66676988689:web:949fbb5756d0c38d604ab0',
    messagingSenderId: '66676988689',
    projectId: 'sherlock-5ca63',
    authDomain: 'sherlock-5ca63.firebaseapp.com',
    storageBucket: 'sherlock-5ca63.appspot.com',
    measurementId: 'G-64LEPXYKBV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAiySBTugPGXzIEJcdxTF9a4BZ7YqJSeDA',
    appId: '1:66676988689:android:8d4c7fec0ee33874604ab0',
    messagingSenderId: '66676988689',
    projectId: 'sherlock-5ca63',
    storageBucket: 'sherlock-5ca63.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCINJXuK6LAD9glYq8b18-1G_XiZjQedQ',
    appId: '1:66676988689:ios:3170484cb7cd852c604ab0',
    messagingSenderId: '66676988689',
    projectId: 'sherlock-5ca63',
    storageBucket: 'sherlock-5ca63.appspot.com',
    iosBundleId: 'guidevtecgmail.com.sherlock',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCINJXuK6LAD9glYq8b18-1G_XiZjQedQ',
    appId: '1:66676988689:ios:3170484cb7cd852c604ab0',
    messagingSenderId: '66676988689',
    projectId: 'sherlock-5ca63',
    storageBucket: 'sherlock-5ca63.appspot.com',
    iosBundleId: 'guidevtecgmail.com.sherlock',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD3FaLKnQelB_Tw6NKLGyjvglb_hW7tYI4',
    appId: '1:66676988689:web:81aa66a0e1442c4f604ab0',
    messagingSenderId: '66676988689',
    projectId: 'sherlock-5ca63',
    authDomain: 'sherlock-5ca63.firebaseapp.com',
    storageBucket: 'sherlock-5ca63.appspot.com',
    measurementId: 'G-CQDCS3CNRE',
  );
}