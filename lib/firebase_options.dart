// Generated from google-services.json for project: kigali-city-services-7dcf4

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
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAMchMj23iXW9gnHaqeGA9tB5tSwTLVm5w',
    appId: '1:3941121829:android:33db1330b61e7f63aca4cc',
    messagingSenderId: '3941121829',
    projectId: 'kigali-city-services-7dcf4',
    storageBucket: 'kigali-city-services-7dcf4.firebasestorage.app',
  );

  // Add your iOS GoogleService-Info.plist values here if targeting iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMchMj23iXW9gnHaqeGA9tB5tSwTLVm5w',
    appId: '1:3941121829:ios:33db1330b61e7f63aca4cc',
    messagingSenderId: '3941121829',
    projectId: 'kigali-city-services-7dcf4',
    storageBucket: 'kigali-city-services-7dcf4.firebasestorage.app',
    iosBundleId: 'com.example.kigaliCityService',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAMchMj23iXW9gnHaqeGA9tB5tSwTLVm5w',
    appId: '1:3941121829:web:33db1330b61e7f63aca4cc',
    messagingSenderId: '3941121829',
    projectId: 'kigali-city-services-7dcf4',
    authDomain: 'kigali-city-services-7dcf4.firebaseapp.com',
    storageBucket: 'kigali-city-services-7dcf4.firebasestorage.app',
  );
}
