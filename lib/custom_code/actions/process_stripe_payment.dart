// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<bool> processStripePayment(
  BuildContext context,
  String clientSecret,
  String customerId,
  String ephemeralKey,
  String publishableKey,
  String merchantDisplayName,
  double amount,
  String paymentMethod,
) async {
  Stripe.publishableKey = publishableKey;
  Stripe.merchantIdentifier = 'merchant.com.helpero.app';

  try {
    if (paymentMethod == 'platform_pay') {
      // 🍎 Apple Pay / 🤖 Google Pay — шторка только с Apple Pay
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKey,
          merchantDisplayName: merchantDisplayName,
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'CA',
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'CA',
            testEnv: true,
          ),
          style: ThemeMode.system,
        ),
      );
    } else {
      // 💳 Только форма карты — без Apple Pay, без Link
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKey,
          merchantDisplayName: merchantDisplayName,
          style: ThemeMode.system,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF4B39EF),
            ),
          ),
        ),
      );
    }

    await Stripe.instance.presentPaymentSheet();
    return true;
  } catch (e) {
    if (e is StripeException) {
      if (e.error.code == FailureCode.Canceled) return false;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 6),
      ),
    );
    return false;
  }
}
