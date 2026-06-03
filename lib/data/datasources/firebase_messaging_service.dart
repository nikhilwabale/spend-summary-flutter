import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  Future<void> initializeIfConfigured() async {
    // Run FlutterFire configure later and initialize Firebase here.
    if (Firebase.apps.isEmpty) return;
    await FirebaseMessaging.instance.requestPermission();
  }

  Future<String?> getTokenIfConfigured() async {
    if (Firebase.apps.isEmpty) return null;
    return FirebaseMessaging.instance.getToken();
  }
}
