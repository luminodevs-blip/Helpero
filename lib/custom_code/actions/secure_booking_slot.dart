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

Future<bool> secureBookingSlot(
  String specialistId,
  String
      scheduledStart, // Теперь принимаем String (ISO), как и в структуре слота
) async {
  final supabase = Supabase.instance.client;
  final draft = FFAppState().activeBookingDraft;

  try {
    // Вызываем RPC функцию в Supabase
    // Так как scheduledStart уже строка ISO, передаем её как есть

    await supabase.rpc(
      'secure_booking_slot',
      params: {
        'p_house_id': draft.address.id,
        'p_duration_min': draft.totalDuration,
        'p_mode_slug': draft.visit.mode,
        'p_target_start': scheduledStart,
      },
    );

    return true;
  } catch (e) {
    print('Error securing slot: $e');
    return false;
  }
}
