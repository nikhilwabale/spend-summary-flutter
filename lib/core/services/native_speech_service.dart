import 'package:flutter/services.dart';

class NativeSpeechService {
  static const MethodChannel _channel = MethodChannel('spend_summary.native.speech');

  static Future<String?> startListening() async {
    try {
      final result = await _channel.invokeMethod<String>('startListening');
      return result;
    } catch (_) {
      return null;
    }
  }
}
