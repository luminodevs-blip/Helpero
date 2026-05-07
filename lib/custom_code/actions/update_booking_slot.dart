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
import 'dart:math' as math;

Future<BookingDraftStruct> updateBookingSlot(
  BookingDraftStruct currentDraft,
  ArrivalOptionStructStruct selectedSlot,
) async {
  // 1. Получаем Priority Fee из выбранного слота (если он есть)
  double newPriorityFee = selectedSlot.fee ?? 0.0;
  String mode = (selectedSlot.mode ?? '').toLowerCase();

  // 2. Обновляем детали визита в черновике
  currentDraft.updateVisit((v) {
    v.mode = mode;
    v.arrivalDateDisplay = selectedSlot.displayDate;
    v.arrivalTimeDisplay = selectedSlot.displayTime;

    // Сбрасываем или устанавливаем временной слот
    if (selectedSlot.timeStart != null && selectedSlot.timeStart != '') {
      if (selectedSlot.timeEnd != null && selectedSlot.timeEnd != '') {
        v.arrivalTimeSlot = "${selectedSlot.timeStart}-${selectedSlot.timeEnd}";
      } else {
        v.arrivalTimeSlot = selectedSlot.timeStart;
      }
    } else {
      v.arrivalTimeSlot = null;
    }
  });

  // 3. Расчет сабтотала
  double subtotal = currentDraft.serverCheckout.subtotal ?? 0.0;
  if (subtotal <= 0) {
    double addonsSum = 0.0;
    for (var addon in currentDraft.selectedAddons) {
      addonsSum += (addon.totalPrice ?? 0.0);
    }
    subtotal = math.max(currentDraft.basePrice ?? 0.0, addonsSum);
  }

  // 4. Итоговая цена
  double finalTotal = subtotal + newPriorityFee;
  currentDraft.totalPrice = finalTotal;

  // 5. Синхронизируем объект чекаута
  currentDraft.updateServerCheckout((s) {
    s.priorityFee = newPriorityFee;
    s.totalToPay = finalTotal;
  });

  return currentDraft;
}
