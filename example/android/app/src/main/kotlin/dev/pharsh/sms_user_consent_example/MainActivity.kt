package dev.pharsh.sms_user_consent_example

import android.app.Activity
import android.content.*
import androidx.annotation.NonNull
import com.google.android.gms.auth.api.credentials.Credential
import com.google.android.gms.auth.api.credentials.Credentials
import com.google.android.gms.auth.api.credentials.HintRequest
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var methodChannel: MethodChannel
    private val CHANNEL = "sms_user_consent"
    private val CREDENTIAL_PICKER_REQUEST = 1  // Set to an unused request code
    private val SMS_CONSENT_REQUEST = 2  // Set to an unused request code

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel =
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            if (call.method == "requestPhoneNumber") {
                requestHint()
                result.success(null)
            }
            if (call.method == "requestSms") {
                val senderPhoneNumber = call.argument<String>("senderPhoneNumber")
                SmsRetriever.getClient(context).startSmsUserConsent(senderPhoneNumber)

                val intentFilter = IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION)
                registerReceiver(smsVerificationReceiver, intentFilter)
                result.success(null)
            }
        }
    }


    // Construct a request for phone numbers and show the picker
    private fun requestHint() {
        val hintRequest = HintRequest.Builder()
                .setPhoneNumberIdentifierSupported(true)
                .build()
        val credentialsClient = Credentials.getClient(this)
        val intent = credentialsClient.getHintPickerIntent(hintRequest)
        startIntentSenderForResult(
                intent.intentSender,
                CREDENTIAL_PICKER_REQUEST,
                null, 0, 0, 0
        )
    }

    private val smsVerificationReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (SmsRetriever.SMS_RETRIEVED_ACTION == intent.action) {
                val extras = intent.extras
                val smsRetrieverStatus = extras?.get(SmsRetriever.EXTRA_STATUS) as Status

                when (smsRetrieverStatus.statusCode) {
                    CommonStatusCodes.SUCCESS -> {
                        // Get consent intent
                        val consentIntent = extras.getParcelable<Intent>(SmsRetriever.EXTRA_CONSENT_INTENT)
                        try {
                            // Start activity to show consent dialog to user, activity must be started in
                            // 5 minutes, otherwise you'll receive another TIMEOUT intent
                            startActivityForResult(consentIntent, SMS_CONSENT_REQUEST)
                        } catch (e: ActivityNotFoundException) {
                            // Handle the exception ...
                        }
                    }
                    CommonStatusCodes.TIMEOUT -> {
                        // Time out occurred, handle the error.
                    }
                }
            }
        }
    }

    public override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            CREDENTIAL_PICKER_REQUEST ->
                // Obtain the phone number from the result
                if (resultCode == Activity.RESULT_OK && data != null) {
                    val credential = data.getParcelableExtra<Credential>(Credential.EXTRA_KEY)
                    // credential.getId();  <-- will need to process phone number string
                    methodChannel
                            .invokeMethod("selectedPhoneNumber", credential.id)
                } else {
                    methodChannel.invokeMethod("selectedPhoneNumber", null)
                }

            SMS_CONSENT_REQUEST ->
                // Obtain the phone number from the result
                if (resultCode == Activity.RESULT_OK && data != null) {
                    // Get SMS message content
                    val message = data.getStringExtra(SmsRetriever.EXTRA_SMS_MESSAGE)
                    // Extract one-time code from the message and complete verification
                    // `message` contains the entire text of the SMS message, so you will need
                    // to parse the string.
                    // val oneTimeCode = parseOneTimeCode(message) // do this dart side
                    methodChannel
                            .invokeMethod("receivedSms", message)
                    unregisterReceiver(smsVerificationReceiver)
                } else {
                    // Consent denied. User can type OTC manually.
                    methodChannel.invokeMethod("receivedSms", null)
                    unregisterReceiver(smsVerificationReceiver)
                }
        }
    }
}


