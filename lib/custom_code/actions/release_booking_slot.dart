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

Future releaseBookingSlot() async {
  final supabase = Supabase.instance.client;
  final currentUser = supabase.auth.currentUser;

  if (currentUser == null) return;

  try {
    // Удаляем все активные бронирования (интенты) текущего пользователя
    await supabase
        .from('booking_intents')
        .delete()
        .eq('user_id', currentUser.id);
    print('Slot released successfully');
  } catch (e) {
    print('Error releasing slot: $e');
  }
}
