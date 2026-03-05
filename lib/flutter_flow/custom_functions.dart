import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

String? formatPhoneNumber(String? phone) {
  if (phone == null || phone.isEmpty) {
    return '';
  }

  // 1. Очищаем номер от всего, кроме цифр
  String cleanPhone = phone.replaceAll(RegExp(r'\D'), '');

  // 2. Если номер начинается с 1 или 7 (Россия/США) и длина 11 цифр
  // Пример входа: 15551234567 -> Выход: +1 (555) 123-4567
  if (cleanPhone.length == 11) {
    return '+${cleanPhone[0]} (${cleanPhone.substring(1, 4)}) ${cleanPhone.substring(4, 7)}-${cleanPhone.substring(7)}';
  }

  // 3. Если длина 12 цифр (например +44...)
  if (cleanPhone.length == 12) {
    return '+${cleanPhone.substring(0, 2)} ${cleanPhone.substring(2, 6)} ${cleanPhone.substring(6)}';
  }

  // 4. Если просто 10 цифр (без кода страны)
  // Пример: 5551234567 -> (555) 123-4567
  if (cleanPhone.length == 10) {
    return '(${cleanPhone.substring(0, 3)}) ${cleanPhone.substring(3, 6)}-${cleanPhone.substring(6)}';
  }

  // Если формат не распознан, возвращаем как есть, добавив плюс если надо
  return phone;
}

int getAddonQty(
  List<SelectedAddonStruct> addonList,
  String addonId,
) {
// 1. Если список выбранных услуг пуст, сразу возвращаем 0
  if (addonList.isEmpty) return 0;

// 2. Ищем айтем в списке выбранных
  for (var item in addonList) {
    // Сравниваем ID как строки (самый надежный способ для Supabase и FlutterFlow)
    if (item.id.toString() == addonId.toString()) {
      // 3. Если нашли, возвращаем его количество (или 0, если данных нет)
      return item.qty ?? 0;
    }
  }

// 4. Если прошлись по всему списку и не нашли такой ID — возвращаем 0
  return 0;
}

List<SelectedAddonStruct> updateAddonInList(
  List<SelectedAddonStruct> addonList,
  String addonId,
  String addonName,
  double unitPrice,
  int change,
) {
  final result = addonList.toList();
  final idx = result.indexWhere((e) => e.id == addonId);
  if (idx >= 0) {
    final newQty = result[idx].qty + change;
    if (newQty <= 0) {
      result.removeAt(idx);
    } else {
      result.removeAt(idx);
      result.insert(
          idx,
          SelectedAddonStruct(
            id: addonId,
            name: addonName,
            qty: newQty,
            unitPrice: unitPrice,
            totalPrice: newQty * unitPrice,
          ));
    }
  } else if (change > 0) {
    result.add(SelectedAddonStruct(
      id: addonId,
      name: addonName,
      qty: 1,
      unitPrice: unitPrice,
      totalPrice: unitPrice,
    ));
  }
  return result;
}

String? formatDuration(double? totalMinutes) {
  if (totalMinutes == null) return null;
  int hours = totalMinutes ~/ 60;
  int minutes = (totalMinutes % 60).toInt();
  if (hours == 0) return '${minutes}m';
  if (minutes == 0) return '${hours}h';
  return '${hours}h ${minutes}m';
}

double? ratingPercent(
  int? starCount,
  int? totalCount,
) {
  double ratingPercent(int starCount, int totalCount) {
    if (totalCount == 0) return 0.0;
    return starCount / totalCount;
  }
}

String formatAddonsShortSummary(List<SelectedAddonStruct> selectedAddons) {
  if (selectedAddons == null || selectedAddons.isEmpty) return "";

  List<String> parts = [];
  for (var addon in selectedAddons) {
    // Берем только те аддоны, которые предназначены для хедера
    // (displayStage == 'customize')
    if (addon.displayStage == 'customize' &&
        addon.qty != null &&
        addon.qty! > 0) {
      parts.add("${addon.qty} ${addon.name}");
    }
  }

  // Соединяем "1 Bathrooms • 2 Bedrooms"
  return parts.join(" • ");
}

List<SelectedAddonStruct> filterAddonsByStage(
  List<SelectedAddonStruct> selectedAddonsf,
  String stage,
) {
  if (selectedAddonsf == null || selectedAddonsf.isEmpty) return [];

  // Правильная фильтрация по стадии
  return selectedAddonsf.where((addon) => addon.displayStage == stage).toList();
}

DateTime? dateTimeFromIso(String? isoString) {
  if (isoString == null || isoString.isEmpty) return null;
  try {
    return DateTime.parse(isoString);
  } catch (e) {
    return null;
  }
}

ArrivalOptionStructStruct? getInitialStandardSlot(
    List<ArrivalOptionStructStruct>? slots) {
  if (slots == null || slots.isEmpty) return null;

  // Ищем тот самый "Золотой слот" (isGolden == true)
  for (var slot in slots) {
    if (slot.isGolden == true) {
      return slot;
    }
  }

  // Если по какой-то причине золотого нет, возвращаем первый режим "standard"
  for (var slot in slots) {
    if (slot.mode == 'standard') {
      return slot;
    }
  }

  return slots.first;
}

double calculateSubtotal(List<SelectedAddonStruct>? selectedAddons) {
  double total = 0.0;
  // Мы добавили ?? [] чтобы избежать ошибки Null
  for (var item in (selectedAddons ?? [])) {
    total += (item.unitPrice ?? 0.0) * (item.qty ?? 0);
  }
  return total;
}

double? calculateVisitFee(
  double subtotal,
  double minOrderAmount,
) {
  // Если мы уже набрали больше минимума, доплата = 0
  if (subtotal >= minOrderAmount) return 0.0;
  // Иначе считаем разницу
  return minOrderAmount - subtotal;
}

double calculateTaxes(
  double taxableAmount,
  double taxRate,
  bool isInclusive,
) {
  if (isInclusive) {
    // Налог включен: Сумма - (Сумма / (1 + Rate))
    return taxableAmount - (taxableAmount / (1 + taxRate));
  }
  // Налог сверху: Сумма * Rate
  return taxableAmount * taxRate;
}

double calculateFinalTotal(
  double subtotal,
  double bookingFee,
  double visitFee,
  double priorityFee,
  double tripFee,
  double highDemandFee,
  double promoDiscount,
  double creditsUsed,
  double taxRate,
  bool taxIsInclusive,
) {
  // Хелпер для округления до 2 знаков внутри функции
  double round2(double val) => (val * 100).round() / 100;
  // 1. Считаем чистую базу (все услуги и сборы за вычетом промо-скидки)
  double taxableBase = subtotal +
      bookingFee +
      visitFee +
      priorityFee +
      tripFee +
      highDemandFee -
      promoDiscount;
  taxableBase = round2(taxableBase);
  // 2. Считаем налоги
  double taxes = 0.0;
  if (taxIsInclusive) {
    // Налог уже внутри суммы
    taxes = round2(taxableBase - (taxableBase / (1 + taxRate)));
  } else {
    // Налог начисляется сверху
    taxes = round2(taxableBase * taxRate);
  }
  // 3. Финальный расчет
  double total;
  if (taxIsInclusive) {
    // Если налог включен, он уже в taxableBase
    total = taxableBase - creditsUsed;
  } else {
    // Если налог сверху, прибавляем его
    total = taxableBase + taxes - creditsUsed;
  }
  // Возвращаем округленный результат, не меньше нуля
  return math.max(0.0, round2(total));
}

dynamic getBestApplicablePromo(
  double subtotal,
  List<PromocodeStructStruct> automaticPromos,
  List<PromocodeStructStruct> userVouchers,
  bool isFirstOrder,
  int? categoryId,
  int? userOverrideId,
  bool isCancelled,
) {
  if (isCancelled) return null;
  double round2(double val) => (val * 100).round() / 100;
  // Используем PromocodeStructStruct
  List<PromocodeStructStruct> autoCandidates = automaticPromos.where((p) {
    if (subtotal < (p.minOrderSubtotal ?? 0)) return false;
    if (p.allowedCategories != null && p.allowedCategories!.isNotEmpty) {
      if (categoryId != null && !p.allowedCategories!.contains(categoryId))
        return false;
    }
    if (p.targetAudience == 'new_users_only' && !isFirstOrder) return false;
    return true;
  }).toList();
  List<PromocodeStructStruct> userCandidates = userVouchers.where((p) {
    if (subtotal < (p.minOrderSubtotal ?? 0)) return false;
    if (p.allowedCategories != null && p.allowedCategories!.isNotEmpty) {
      if (categoryId != null && !p.allowedCategories!.contains(categoryId))
        return false;
    }
    return true;
  }).toList();
  PromocodeStructStruct? bestAuto;
  double maxAutoDiscount = 0;
  for (var p in autoCandidates) {
    double d = _calculateSingleDiscount(subtotal, p);
    if (d > maxAutoDiscount) {
      maxAutoDiscount = d;
      bestAuto = p;
    }
  }
  PromocodeStructStruct? selectedVoucher;
  double voucherDiscount = 0;
  if (userOverrideId != null && userOverrideId > 0) {
    selectedVoucher = userCandidates.firstWhere(
      (p) => p.id == userOverrideId,
      orElse: () => PromocodeStructStruct(),
    );
    if (selectedVoucher.id != null) {
      voucherDiscount = _calculateSingleDiscount(subtotal, selectedVoucher);
    }
  }
  double finalDiscount = 0;
  List<int> appliedIds = [];
  String finalTitle = "";
  if (selectedVoucher != null && selectedVoucher.id != null) {
    if ((selectedVoucher.isStackable ?? false) &&
        (bestAuto?.isStackable ?? false)) {
      finalDiscount = voucherDiscount + maxAutoDiscount;
      appliedIds = [selectedVoucher.id!, bestAuto!.id!];
      finalTitle = "${selectedVoucher.title} + ${bestAuto.title}";
    } else {
      if (voucherDiscount >= maxAutoDiscount) {
        finalDiscount = voucherDiscount;
        appliedIds = [selectedVoucher.id!];
        finalTitle = selectedVoucher.title ?? "";
      } else {
        finalDiscount = maxAutoDiscount;
        appliedIds = [bestAuto!.id!];
        finalTitle = bestAuto.title ?? "";
      }
    }
  } else {
    finalDiscount = maxAutoDiscount;
    appliedIds = bestAuto != null ? [bestAuto.id!] : [];
    finalTitle = bestAuto?.title ?? "";
  }
  if (finalDiscount <= 0) return null;
  return {
    'totalDiscount': round2(finalDiscount),
    'appliedIds': appliedIds,
    'title': finalTitle,
  };
}

double _calculateSingleDiscount(double subtotal, PromocodeStructStruct p) {
  double discount = 0;
  if (p.discountType == 'percent') {
    discount = subtotal * (p.discountValue ?? 0);
    if (p.maxDiscountLimit != null && p.maxDiscountLimit! > 0) {
      discount = math.min(discount, p.maxDiscountLimit!);
    }
  } else {
    discount = (p.discountValue ?? 0);
  }
  return discount;
}

String? addonsToJson(
  int serviceId,
  List<SelectedAddonStruct> selectedAddons,
) {
  final items = selectedAddons
      .where((a) => a.qty > 0)
      .map((a) => {
            'service_id': serviceId,
            'addon_id': a.id,
            'quantity': a.qty,
            'unit_price': a.unitPrice,
          })
      .toList();
  return jsonEncode(items);
}

String dateTimeToIso(DateTime dt) {
  return dt.toUtc().toIso8601String();
}

ArrivalOptionStructStruct? findStandardSlot(
    List<ArrivalOptionStructStruct> slots) {
  try {
    return slots.firstWhere((s) => s.mode == 'standard');
  } catch (_) {
    return slots.isNotEmpty ? slots.first : null;
  }
}

String getDaysLeftText(String? expiryDateString) {
  if (expiryDateString == null || expiryDateString.isEmpty) {
    return 'No Expiry';
  }

  try {
    DateTime expiryDate = DateTime.parse(expiryDateString);
    DateTime now = DateTime.now();

    // Считаем разницу в днях
    int differenceInDays = expiryDate.difference(now).inDays;

    if (differenceInDays < 0) {
      return 'Expired';
    } else if (differenceInDays == 0) {
      return 'Expires today';
    } else if (differenceInDays == 1) {
      return 'Expires tomorrow';
    } else {
      return 'Expires in $differenceInDays days';
    }
  } catch (e) {
    return 'Invalid Date';
  }
}

List<UserVoucherStruct> parseUserVouchers(List<dynamic>? jsonList) {
  if (jsonList == null || jsonList.isEmpty) {
    return [];
  }

  List<UserVoucherStruct> result = [];

  for (var item in jsonList) {
    // Вспомогательная мапа, если вдруг это не Map
    if (item is! Map<String, dynamic>) continue;

    // Тут 'item' - это корневой объект user_voucher (включающий is_applicable),
    // а внутри него лежит 'voucher' (с title, description и т.д.)
    var voucherData = item['voucher'] ?? {};

    result.add(UserVoucherStruct(
      // из корня user_voucher
      id: item['id']
          ?.toString(), // или id ваучера, смотря что у тебя в Data Type
      isApplicable: item['is_applicable'] ?? true,
      disableReason: item['disable_reason']?.toString(),

      // из вложенного объекта voucher
      title: voucherData['title']?.toString(),
      description: voucherData['description']?.toString(),
      targetAudience: voucherData['target_audience']?.toString(),
      expiresAt: voucherData['expires_at']?.toString(),
      // добавь остальные поля, если они есть в Data Type
    ));
  }

  return result;
}
