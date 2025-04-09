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
    apiKey: 'AIzaSyAOTUmGeWvnULlen4sZQl62AviVTRiuZfE',
    appId: '1:1049076270818:web:42456432562854d37200bb',
    messagingSenderId: '1049076270818',
    projectId: 'lora-multihop',
    authDomain: 'lora-multihop.firebaseapp.com',
    storageBucket: 'lora-multihop.firebasestorage.app',
    measurementId: 'G-8L3NKLJTRC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5iT04_hiyfcxSdVI51oIPsyyA5sm3dIQ',
    appId: '1:1049076270818:android:4d9e197980f4d36d7200bb',
    messagingSenderId: '1049076270818',
    projectId: 'lora-multihop',
    storageBucket: 'lora-multihop.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNCPFHu9jRwxNiJMqptu3Vu802jSDDsxw',
    appId: '1:1049076270818:ios:39244311b65359087200bb',
    messagingSenderId: '1049076270818',
    projectId: 'lora-multihop',
    storageBucket: 'lora-multihop.firebasestorage.app',
    iosClientId: '1049076270818-22l88bft7rrkdv994r75qjrqefacj7dv.apps.googleusercontent.com',
    iosBundleId: 'com.example.smartAgricultureJadi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCNCPFHu9jRwxNiJMqptu3Vu802jSDDsxw',
    appId: '1:1049076270818:ios:39244311b65359087200bb',
    messagingSenderId: '1049076270818',
    projectId: 'lora-multihop',
    storageBucket: 'lora-multihop.firebasestorage.app',
    iosClientId: '1049076270818-22l88bft7rrkdv994r75qjrqefacj7dv.apps.googleusercontent.com',
    iosBundleId: 'com.example.smartAgricultureJadi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAOTUmGeWvnULlen4sZQl62AviVTRiuZfE',
    appId: '1:1049076270818:web:c99a1fd1bf10e1b67200bb',
    messagingSenderId: '1049076270818',
    projectId: 'lora-multihop',
    authDomain: 'lora-multihop.firebaseapp.com',
    storageBucket: 'lora-multihop.firebasestorage.app',
    measurementId: 'G-CVRV835ZXX',
  );
}
