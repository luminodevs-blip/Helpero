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

Future<BookingDraftStruct> updateBookingAddon(
  BookingDraftStruct currentDraft,
  String addonId,
  String addonName,
  double addonPrice,
  double? addonComparePrice,
  int addonDuration,
  String action,
  String displayStage,
) async {
  List<SelectedAddonStruct> items = currentDraft.selectedAddons.toList();
  int index = items.indexWhere((item) => item.id == addonId);
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
  double newUpsellSum = 0.0;
  double newCustomizeSum = 0.0;
  int newDurationSum = 0;
  double newSavingsSum = 0.0;
  for (var item in items) {
    newDurationSum += (item.totalDuration ?? 0);
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
  currentDraft.selectedAddons = items;
  currentDraft.itemsPrice = newUpsellSum;
  double totalAddons = newCustomizeSum + newUpsellSum;
  double minOrderThreshold = currentDraft.basePrice ?? 0.0;
  double subtotal =
      totalAddons < minOrderThreshold ? minOrderThreshold : totalAddons;
  currentDraft.totalPrice = subtotal;
  // Минимальное время визита (kitchen + буфер, например 230 мин)
  final int minDuration = currentDraft.durationMinutes ?? 0;
  // Фиксированное время кухни+коридора (берётся из kitchenDurationMinutes)
  final int kitchenTime = currentDraft.kitchenDurationMinutes ?? 0;
  // Итоговое время = кухня + выбранные комнаты, но не меньше минимума
  final int rawDuration = kitchenTime + newDurationSum;
  currentDraft.totalDuration =
      newDurationSum > 0 ? max(minDuration, rawDuration) : minDuration;
  currentDraft.totalSavings = newSavingsSum;
  return currentDraft;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
