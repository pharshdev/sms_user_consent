import 'dart:async';

import 'package:flutter/services.dart';

class SmsUserConsent {
  static const MethodChannel _channel = const MethodChannel('sms_user_consent');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> get requestPhoneNumber async {
    await _channel.invokeMethod('requestPhoneNumber');
  }
}
