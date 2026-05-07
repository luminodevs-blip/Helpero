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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'dart:math' as math;

Future<BookingDraftStruct> updateBookingAddon(
  BookingDraftStruct currentDraft,
  String addonId,
  String addonName,
  double addonPrice,
  double? addonComparePrice,
  int addonDuration,
  String action,
  String displayStage,
  int? minSpecialists,
) async {
  List<SelectedAddonStruct> items = currentDraft.selectedAddons.toList();
  int index = items.indexWhere((item) => item.id == addonId);

  // 1. Добавление/Удаление аддонов
  if (action == 'add') {
    if (index >= 0) {
      items[index].qty = (items[index].qty ?? 0) + 1;
      items[index].totalPrice =
          items[index].qty! * (items[index].unitPrice ?? 0.0);
      items[index].totalDuration =
          items[index].qty! * (items[index].unitDuration ?? 0);
    } else {
      items.add(SelectedAddonStruct(
        id: addonId,
        name: addonName,
        qty: 1,
        unitPrice: addonPrice,
        compareAtPrice: addonComparePrice ?? addonPrice,
        totalPrice: addonPrice,
        unitDuration: addonDuration,
        totalDuration: addonDuration,
        displayStage: displayStage,
        minSpecialists: minSpecialists ?? 1,
      ));
    }
  } else if (action == 'remove') {
    if (index >= 0) {
      if ((items[index].qty ?? 0) > 1) {
        items[index].qty = (items[index].qty ?? 0) - 1;
        items[index].totalPrice =
            items[index].qty! * (items[index].unitPrice ?? 0.0);
        items[index].totalDuration =
            items[index].qty! * (items[index].unitDuration ?? 0);
      } else {
        items.removeAt(index);
      }
    }
  }

  // 2. Расчет сумм и «человеко-часов»
  double newUpsellSum = 0.0;
  double newCustomizeSum = 0.0;
  int addonsDurationSum = 0;
  double newSavingsSum = 0.0;
  int maxForcedSpecs = 1;

  for (var item in items) {
    addonsDurationSum += (item.totalDuration ?? 0);

    if ((item.minSpecialists ?? 1) > maxForcedSpecs) {
      maxForcedSpecs = item.minSpecialists!;
    }

    double unitSavings = (item.compareAtPrice ?? 0.0) > (item.unitPrice ?? 0.0)
        ? (item.compareAtPrice! - item.unitPrice!)
        : 0.0;
    newSavingsSum += unitSavings * (item.qty ?? 0);

    if (item.displayStage == 'customize') {
      newCustomizeSum += (item.totalPrice ?? 0.0);
    } else {
      newUpsellSum += (item.totalPrice ?? 0.0);
    }
  }

  // 3. Расчет ЦЕНЫ
  double totalAddonsPrice = newCustomizeSum + newUpsellSum;
  double minOrderThreshold = currentDraft.basePrice ?? 0.0;
  double subtotal = math.max(minOrderThreshold, totalAddonsPrice);

  // 4. УМНЫЙ РАСЧЕТ КОМАНДЫ
  final int baseDuration = currentDraft.durationMinutes ?? 0;
  final int kitchenTime = currentDraft.kitchenDurationMinutes ?? 0;

  int rawManHours = addonsDurationSum > 0
      ? math.max(baseDuration, kitchenTime + addonsDurationSum)
      : baseDuration;

  int timeBasedSpecs = (rawManHours / 360.0).ceil();
  int specialistsCount = math.max(timeBasedSpecs, maxForcedSpecs);
  if (specialistsCount < 1) specialistsCount = 1;

  // Рассчитываем время визита (ЧИСТЫЙ РАСЧЕТ БЕЗ МНОЖИТЕЛЕЙ)
  int visitDuration = (rawManHours / specialistsCount).ceil();
  visitDuration =
      math.max(visitDuration, (baseDuration / specialistsCount).ceil());

  // 5. Записываем всё обратно
  currentDraft.selectedAddons = items;
  currentDraft.itemsPrice = newUpsellSum;
  currentDraft.totalPrice = subtotal;
  currentDraft.totalDuration = visitDuration;
  currentDraft.totalSavings = newSavingsSum;
  currentDraft.specialistsCount = specialistsCount;

  currentDraft.updateServerCheckout((s) {
    s.subtotal = subtotal;
    s.totalToPay = subtotal;
    s.priorityFee = 0.0;
    s.specialistsCount = specialistsCount;
  });

  return currentDraft;
}
