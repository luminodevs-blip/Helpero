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

import 'package:flutter_stripe/flutter_stripe.dart';

Future processStripePayment(
  BuildContext context,
  String clientSecret,
  String customerId, // ДОБАВЛЕНО ИЗ БЭКЕНДА
  String ephemeralKey, // ДОБАВЛЕНО ИЗ БЭКЕНДА
  String publishableKey,
  String merchantDisplayName,
) async {
  // 1. Устанавливаем ключ (он публичный, это безопасно)
  Stripe.publishableKey = publishableKey;

  // 2. Инициализируем нативный платежный лист (Payment Sheet)
  try {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        customerId: customerId, // ВАЖНО: для сохраненных карт
        customerEphemeralKeySecret:
            ephemeralKey, // ВАЖНО: для доступа к сохраненным картам
        merchantDisplayName: merchantDisplayName,
        style: ThemeMode.light,
        // Включаем Apple Pay (нужно для iOS)
        applePay: const PaymentSheetApplePay(
          merchantCountryCode: 'CA', // Страна мерчанта
        ),
        // Включаем Google Pay (нужно для Android)
        googlePay: const PaymentSheetGooglePay(
          merchantCountryCode: 'CA',
          testEnv: true, // ПОТОМ НЕ ЗАБУДЬ ПОМЕНЯТЬ НА FALSE В ПРОДАКШЕНЕ
        ),
        appearance: PaymentSheetAppearance(
          colors: PaymentSheetAppearanceColors(
            primary: Color(0xFF4B39EF), // Твой Helpero Indigo
          ),
        ),
      ),
    );

    // 3. Показываем окно оплаты
    await Stripe.instance.presentPaymentSheet();

    // Если мы здесь — оплата (холд) подтверждена!
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment successfully authorized')),
    );
  } catch (e) {
    if (e is StripeException) {
      // Пользователь мог просто закрыть окно — это не ошибка
      if (e.error.code == FailureCode.Canceled) {
        return;
      }
      throw Exception('Stripe Error: ${e.error.localizedMessage}');
    } else {
      throw Exception('Error: $e');
    }
  }
}
