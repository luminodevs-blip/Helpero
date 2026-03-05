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

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> universalVerifyOTP(
  String target,
  String token,
  bool isEmail,
) async {
  try {
    final response = await Supabase.instance.client.auth.verifyOTP(
      email: isEmail ? target : null,
      phone: isEmail ? null : target,
      token: token,
      // Исправлено: используем OtpType.email для проверки кода
      type: isEmail ? OtpType.email : OtpType.sms,
    );

    return response.session != null;
  } catch (e) {
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
