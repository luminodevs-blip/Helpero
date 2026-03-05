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

// Imports for the action
import 'package:supabase_flutter/supabase_flutter.dart';

Future signInWithSupabaseTokens(String refreshToken) async {
  // Получаем доступ к клиенту Supabase
  final supabase = Supabase.instance.client;

  try {
    // Устанавливаем сессию, используя refresh token полученный из API
    await supabase.auth.setSession(refreshToken);
  } catch (e) {
    print('Ошибка при установке сессии: $e');
    // Можно выбросить ошибку или обработать её
  }
}
