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

import 'index.dart'; // Imports other custom actions

import 'package:onesignal_flutter/onesignal_flutter.dart';
import '/auth/supabase_auth/auth_util.dart';

Future manualOneSignalLogin() async {
  // 1. Получаем текущий UID пользователя
  final String? uid = currentUserUid;

  if (uid == null || uid.isEmpty) {
    print("OS_DEBUG: UID is null or empty. Login skipped.");
    return;
  }

  try {
    print("OS_DEBUG: Starting manual OneSignal login for $uid");

    // 2. Принудительно привязываем UID к OneSignal
    OneSignal.login(uid);

    print("OS_DEBUG: OneSignal login command sent successfully.");
  } catch (e) {
    print("OS_DEBUG: OneSignal SDK Error: $e");
  }
}
