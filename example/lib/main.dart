import 'dart:ui';

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
  late SmsUserConsent smsUserConsent;

  @override
  void initState() {
    super.initState();
    smsUserConsent = SmsUserConsent(
        phoneNumberListener: () => setState(() {}),
        smsListener: () => setState(() {}));
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
              title: const Text('sms_user_consent Example'),
            ),
            body: Center(
                child: SizedBox(
              width: 250,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('To retrieve SMS, make sure the following: '),
                    SizedBox(height: 8.0),
                    Text(
                        '''- The message contains a 4-10 character alphanumeric string with at least one number.'''),
                    Text(
                        '''- The message was sent by a phone number that's not in the user's contacts.'''),
                    Text(
                        '''- If you specified the sender's phone number, the message was sent by that number.'''),
                    SizedBox(height: 16.0),
                    Text('Tap FABs to request Phone number and SMS',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.0),
                    Text(
                        'Selected Phone number: ${smsUserConsent.selectedPhoneNumber}'),
                    SizedBox(height: 8.0),
                    Text('Received SMS: ${smsUserConsent.receivedSms}')
                  ]),
            )),
            floatingActionButton:
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                child: Icon(Icons.phone_android),
                onPressed: () => smsUserConsent.requestPhoneNumber(),
              ),
              SizedBox(height: 16.0),
              Builder(
                  builder: (context) => FloatingActionButton(
                      child: Icon(Icons.sms),
                      onPressed: () {
                        // call your server for sms, then
                        // requestOtp();

                        smsUserConsent.requestSms();

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Listening for SMS...')));
                      }))
            ])));
  }
}
