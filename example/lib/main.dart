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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Plugin example app'),
            ),
            body: Center(
              child: Text('Tap FAB to request Phone number'),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.phone_android),
              onPressed: () => SmsUserConsent.requestPhoneNumber,
            )));
  }
}
