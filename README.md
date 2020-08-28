# sms_user_consent

Request user's phone number (supports dual sim) and/or consent to read SMS without adding any permissions, using Android's [SMS User Consent API](https://developers.google.com/identity/sms-retriever/user-consent/overview)

## Screenshots

<p float="left">
  <img src="https://raw.githubusercontent.com/pharshdev/sms_user_consent/master/ss4.png" width="250" />
  <img src="https://raw.githubusercontent.com/pharshdev/sms_user_consent/master/ss1.png" width="250" />
  <img src="https://raw.githubusercontent.com/pharshdev/sms_user_consent/master/ss2.png" width="250" /> 
  <img src="https://raw.githubusercontent.com/pharshdev/sms_user_consent/master/ss3.png" width="250" />
</p>

## Steps to use

1] Create an instance, **optionally** supply phone number listener and sms listener
```
SmsUserConsent smsUserConsent = SmsUserConsent(
        // optionally, do something when user selects a number.
        // You can even add/update this listener later on by simply 
        // calling smsUserConsent.updatePhoneNumberListener(updatedListener)
        phoneNumberListener: () {},
        
        // optionally, do something when user receives sms.
        // You can even add/update this listener later on by simply 
        // calling smsUserConsent.updateSmsListener(updatedListener)
        smsListener: () {}
);
```

2a] **OPTIONAL** : Request user's phone number

```
smsUserConsent.requestPhoneNumber();
```
Once the user selects a phone number, it can be accessed as
```
smsUserConsent.selectedPhoneNumber;
```

2b] **OPTIONAL** : Request to receive SMS 
```
smsUserConsent.requestSms(); 
```
or you can specify the phone number you wish to capture the SMS from
```
smsUserConsent.requestSms(senderPhoneNumber: sender_number);
```
Once the user receives a SMS and the user taps **Allow**, it can be accessed as
```
smsUserConsent.receivedSms;
```

3] Finally, dispose the instance
```
smsUserConsent.dispose();
```

### Note

As per the [SMS User Consent API](https://developers.google.com/identity/sms-retriever/user-consent/overview),  message will be received by the plugin only if it meets these criteria:

* The message contains a 4-10 character alphanumeric string with at least one number.
* The message was sent by a phone number that's not in the user's contacts.
* If you specified the sender's phone number, the message was sent by that number.

## Contributing

* Found a bug or idea to improve the plugin? Send a PR.
* Found this plugin helpful and want to thank me? I love [:coffee:](https://paypal.me/pharshdev) 
* Want to hire me for a gig? Let's talk on [LinkedIn](https://linkedin.com/in/pharshdev)

## License

MIT © 2020 [Harsh P](https://github.com/pharshdev)
