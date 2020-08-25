import 'package:flutter/services.dart';

class SmsUserConsent {
  static const MethodChannel _channel = const MethodChannel('sms_user_consent');
  Function _phoneNumberListener;
  String _selectedPhoneNumber;

  SmsUserConsent({Function phoneNumberListener}) {
    _phoneNumberListener = phoneNumberListener;
    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case 'selectedPhoneNumber':
          _selectedPhoneNumber = call.arguments;
          _phoneNumberListener();
          break;
        default:
      }
      return;
    });
  }

  void dispose() {
    _phoneNumberListener = null;
  }

  void updatePhoneNumberListener(Function listener) =>
      _phoneNumberListener = listener;

  String get selectedPhoneNumber => _selectedPhoneNumber;

  void requestPhoneNumber() async =>
      await _channel.invokeMethod('requestPhoneNumber');
}
