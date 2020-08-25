import 'package:flutter/material.dart';
import 'package:sms_user_consent/sms_user_consent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SmsUserConsent smsUserConsent;

  @override
  void initState() {
    super.initState();
    smsUserConsent = SmsUserConsent(phoneNumberListener: () => setState(() {}));
  }

  @override
  void dispose() {
    smsUserConsent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Plugin example app'),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text('Tap FAB to request Phone number'),
                  SizedBox(height: 16.0),
                  Text(
                      'Selected Phone number: ${smsUserConsent.selectedPhoneNumber}')
                ])),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.phone_android),
              onPressed: () => smsUserConsent.requestPhoneNumber(),
            )));
  }
}
