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

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

Future setupOneSignal() async {
  try {
    const String appId = "91eebd03-3003-4676-8534-99e9e4f6df92";

    // Инициализация OneSignal
    OneSignal.Debug.setLogLevel(OSLogLevel.none);
    OneSignal.initialize(appId);
    OneSignal.Notifications.requestPermission(true);

    // Безопасное получение инстанса Supabase
    supa.SupabaseClient? client;
    try {
      client = supa.Supabase.instance.client;
    } catch (e) {
      debugPrint("OS_DEBUG: Supabase not yet initialized, skipping login for now.");
      return;
    }

    // Слушатель изменений авторизации
    client.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      if (user != null) {
        OneSignal.login(user.id);
        OneSignal.User.pushSubscription.optIn();
      }
    });

    // Проверка текущего юзера при старте
    final currentUid = client.auth.currentUser?.id;
    if (currentUid != null && currentUid.isNotEmpty) {
      OneSignal.login(currentUid);
      OneSignal.User.pushSubscription.optIn();
    }
  } catch (e) {
    debugPrint("OS_DEBUG: Critical Error in setupOneSignal: $e");
  }
}
