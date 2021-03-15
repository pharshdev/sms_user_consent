import 'package:flutter/services.dart';

/// SmsUserConsent implements Android's
/// [SMS User Consent API](https://developers.google.com/identity/sms-retriever/user-consent/overview#user_flow_for_sms_user_consent_api).
///
/// This plugin can be used to retrieve user's phone number and request user
/// consent to read a single SMS verification message.
class SmsUserConsent {
  static const MethodChannel _channel = const MethodChannel('sms_user_consent');
  Function? _phoneNumberListener;
  Function? _smsListener;
  String? _selectedPhoneNumber;
  String? _receivedSms;

  /// Last selected phone number
  String? get selectedPhoneNumber => _selectedPhoneNumber;

  /// Last received sms
  String? get receivedSms => _receivedSms;

  /// SmsUserConsent plugin works only on Android, hence make sure to check the
  /// platform is Android.
  ///
  /// Optional phone number listener, called when user selects a
  /// phone number (returns null if user selects none of the above or
  /// taps out of the phone number selection dialog).
  ///
  /// Optional sms listener, called when sms is retrieved if it meets these criteria:
  /// - The message contains a 4-10 character alphanumeric string with at least one number.
  /// - The message was sent by a phone number that's not in the user's contacts.
  /// - If you specified the sender's phone number, the message was sent by that number.
  SmsUserConsent({Function? phoneNumberListener, Function? smsListener}) {
    _phoneNumberListener = phoneNumberListener;
    _smsListener = smsListener;
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'selectedPhoneNumber':
          _selectedPhoneNumber = call.arguments;
          _phoneNumberListener!();
          break;
        case 'receivedSms':
          _receivedSms = call.arguments;
          _smsListener!();
          break;
        default:
      }
    });
  }

  /// Clears last phone number, sms and their respective listeners.
  void dispose() {
    _selectedPhoneNumber = null;
    _receivedSms = null;
    _phoneNumberListener = null;
    _smsListener = null;
  }

  /// Updates Phone number listener
  void updatePhoneNumberListener(Function listener) =>
      _phoneNumberListener = listener;

  /// Updates Sms listener
  void updateSmsListener(Function listener) => _smsListener = listener;

  /// Optional (not required for receiving sms): Get user's phone number.
  ///
  /// In case of multiple sim, a dialog is displayed.
  void requestPhoneNumber() async =>
      await _channel.invokeMethod('requestPhoneNumber');

  /// Start listening for an incoming message for the next five minutes.
  ///
  /// If you know the phone number from which the SMS message will originate,
  /// specify it (otherwise, sms from any number satisfying the
  /// [SMS User Consent API](https://developers.google.com/identity/sms-retriever/user-consent/request#2_start_listening_for_incoming_messages)
  /// will be received.
  ///
  /// Once a sms is received, you will have to call this method again to receive
  /// another sms.
  void requestSms({String? senderPhoneNumber}) async => await _channel
      .invokeMethod('requestSms', {"senderPhoneNumber": senderPhoneNumber});
}
