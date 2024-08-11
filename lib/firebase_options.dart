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
    apiKey: 'AIzaSyAftNhvzdRYhWmOh5bH47qg74Itz8uNNJU',
    appId: '1:1021544544778:web:daf204d702f9e56baf7df3',
    messagingSenderId: '1021544544778',
    projectId: 'medicaplus-26848',
    authDomain: 'medicaplus-26848.firebaseapp.com',
    databaseURL: 'https://medicaplus-26848-default-rtdb.firebaseio.com',
    storageBucket: 'medicaplus-26848.appspot.com',
    measurementId: 'G-E1C9WRBC1W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOviNEm34t0HTF9ZPMfXvundH7ZResE2k',
    appId: '1:1021544544778:android:897da9a51e4a6500af7df3',
    messagingSenderId: '1021544544778',
    projectId: 'medicaplus-26848',
    databaseURL: 'https://medicaplus-26848-default-rtdb.firebaseio.com',
    storageBucket: 'medicaplus-26848.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDR8F3FzENQvNJHL1NAHHmpFzgTuRoD5EU',
    appId: '1:1021544544778:ios:21a3a8ce038900ffaf7df3',
    messagingSenderId: '1021544544778',
    projectId: 'medicaplus-26848',
    databaseURL: 'https://medicaplus-26848-default-rtdb.firebaseio.com',
    storageBucket: 'medicaplus-26848.appspot.com',
    iosBundleId: 'com.example.moussaProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDR8F3FzENQvNJHL1NAHHmpFzgTuRoD5EU',
    appId: '1:1021544544778:ios:21a3a8ce038900ffaf7df3',
    messagingSenderId: '1021544544778',
    projectId: 'medicaplus-26848',
    databaseURL: 'https://medicaplus-26848-default-rtdb.firebaseio.com',
    storageBucket: 'medicaplus-26848.appspot.com',
    iosBundleId: 'com.example.moussaProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAftNhvzdRYhWmOh5bH47qg74Itz8uNNJU',
    appId: '1:1021544544778:web:6721e1f9385d1808af7df3',
    messagingSenderId: '1021544544778',
    projectId: 'medicaplus-26848',
    authDomain: 'medicaplus-26848.firebaseapp.com',
    databaseURL: 'https://medicaplus-26848-default-rtdb.firebaseio.com',
    storageBucket: 'medicaplus-26848.appspot.com',
    measurementId: 'G-PW9ET8TGFM',
  );
}