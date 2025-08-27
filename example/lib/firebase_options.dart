import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIProject DeletedKy5hSN1GsE-R-LvQ',
    authDomain: 'kill-switProject Deletedseapp.com',
    projectId: 'kill-sProject Deletedtter',
    storageBucket: 'kill-swiProject Deletedp',
    messagingSenderId: '10Project Deleted6071',
    appId: '1:101630858Project Deleted38df588f53512',
    measurementId: 'G-1Project DeletedVJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'PUT_YOUR_API_KEY_HERE',
    appId: 'PUT_YOUR_APP_ID_HERE',
    messagingSenderId: 'PUT_YOUR_MESSAGING_SENDER_ID_HERE',
    projectId: 'PUT_YOUR_PROJECT_ID_HERE',
    storageBucket: 'PUT_YOUR_STORAGE_BUCKET_HERE',
  );
}
