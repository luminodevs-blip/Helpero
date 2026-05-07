import 'dart:convert';

import 'package:flutter/material.dart';

import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';

import '../../flutter_flow/place.dart';
import '../../flutter_flow/uploaded_file.dart';

/// SERIALIZATION HELPERS

String dateTimeToString(DateTime dateTime) =>
    '${dateTime.isUtc ? 'u' : 'l'}${dateTime.millisecondsSinceEpoch}';

String dateTimeRangeToString(DateTimeRange dateTimeRange) {
  final start = dateTimeRange.start;
  final end = dateTimeRange.end;
  final startStr = '${start.isUtc ? 'u' : 'l'}${start.millisecondsSinceEpoch}';
  final endStr = '${end.isUtc ? 'u' : 'l'}${end.millisecondsSinceEpoch}';
  return '$startStr|$endStr';
}

String placeToString(FFPlace place) => jsonEncode({
      'latLng': place.latLng.serialize(),
      'name': place.name,
      'address': place.address,
      'city': place.city,
      'state': place.state,
      'country': place.country,
      'zipCode': place.zipCode,
    });

String uploadedFileToString(FFUploadedFile uploadedFile) =>
    uploadedFile.serialize();

String? serializeParam(
  dynamic param,
  ParamType paramType, {
  bool isList = false,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final serializedValues = (param as Iterable)
          .map((p) => serializeParam(p, paramType, isList: false))
          .where((p) => p != null)
          .map((p) => p!)
          .toList();
      return json.encode(serializedValues);
    }
    String? data;
    switch (paramType) {
      case ParamType.int:
        data = param.toString();
      case ParamType.double:
        data = param.toString();
      case ParamType.String:
        data = param;
      case ParamType.bool:
        data = param ? 'true' : 'false';
      case ParamType.DateTime:
        data = dateTimeToString(param as DateTime);
      case ParamType.DateTimeRange:
        data = dateTimeRangeToString(param as DateTimeRange);
      case ParamType.LatLng:
        data = (param as LatLng).serialize();
      case ParamType.Color:
        data = (param as Color).toCssString();
      case ParamType.FFPlace:
        data = placeToString(param as FFPlace);
      case ParamType.FFUploadedFile:
        data = uploadedFileToString(param as FFUploadedFile);
      case ParamType.JSON:
        data = json.encode(param);

      case ParamType.DataStruct:
        data = param is BaseStruct ? param.serialize() : null;

      case ParamType.Enum:
        data = (param is Enum) ? param.serialize() : null;

      case ParamType.SupabaseRow:
        return json.encode((param as SupabaseDataRow).data);

      default:
        data = null;
    }
    return data;
  } catch (e) {
    print('Error serializing parameter: $e');
    return null;
  }
}

/// END SERIALIZATION HELPERS

/// DESERIALIZATION HELPERS

DateTime? dateTimeFromString(String? dateTimeStr) {
  if (dateTimeStr == null || dateTimeStr.isEmpty) {
    return null;
  }
  final hasPrefix = dateTimeStr.startsWith('u') || dateTimeStr.startsWith('l');
  final milliseconds = int.tryParse(
    hasPrefix ? dateTimeStr.substring(1) : dateTimeStr,
  );
  return milliseconds != null
      ? DateTime.fromMillisecondsSinceEpoch(
          milliseconds,
          isUtc: hasPrefix ? dateTimeStr.startsWith('u') : false,
        )
      : null;
}

DateTimeRange? dateTimeRangeFromString(String dateTimeRangeStr) {
  final pieces = dateTimeRangeStr.split('|');
  if (pieces.length != 2) {
    return null;
  }
  DateTime? parseDateTime(String value) {
    final hasPrefix = value.startsWith('u') || value.startsWith('l');
    final milliseconds = int.tryParse(hasPrefix ? value.substring(1) : value);
    return milliseconds != null
        ? DateTime.fromMillisecondsSinceEpoch(
            milliseconds,
            isUtc: hasPrefix ? value.startsWith('u') : false,
          )
        : null;
  }

  final start = parseDateTime(pieces.first);
  final end = parseDateTime(pieces.last);
  if (start == null || end == null) {
    return null;
  }
  return DateTimeRange(
    start: start,
    end: end,
  );
}

LatLng? latLngFromString(String? latLngStr) {
  final pieces = latLngStr?.split(',');
  if (pieces == null || pieces.length != 2) {
    return null;
  }
  return LatLng(
    double.parse(pieces.first.trim()),
    double.parse(pieces.last.trim()),
  );
}

FFPlace placeFromString(String placeStr) {
  final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
  final data = {
    'latLng': serializedData.containsKey('latLng')
        ? latLngFromString(serializedData['latLng'] as String)
        : const LatLng(0.0, 0.0),
    'name': serializedData['name'] ?? '',
    'address': serializedData['address'] ?? '',
    'city': serializedData['city'] ?? '',
    'state': serializedData['state'] ?? '',
    'country': serializedData['country'] ?? '',
    'zipCode': serializedData['zipCode'] ?? '',
  };
  return FFPlace(
    latLng: data['latLng'] as LatLng,
    name: data['name'] as String,
    address: data['address'] as String,
    city: data['city'] as String,
    state: data['state'] as String,
    country: data['country'] as String,
    zipCode: data['zipCode'] as String,
  );
}

FFUploadedFile uploadedFileFromString(String uploadedFileStr) =>
    FFUploadedFile.deserialize(uploadedFileStr);

enum ParamType {
  int,
  double,
  String,
  bool,
  DateTime,
  DateTimeRange,
  LatLng,
  Color,
  FFPlace,
  FFUploadedFile,
  JSON,

  DataStruct,
  Enum,
  SupabaseRow,
}

dynamic deserializeParam<T>(
  String? param,
  ParamType paramType,
  bool isList, {
  StructBuilder<T>? structBuilder,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final paramValues = json.decode(param);
      if (paramValues is! Iterable || paramValues.isEmpty) {
        return null;
      }
      return paramValues
          .where((p) => p is String)
          .map((p) => p as String)
          .map((p) => deserializeParam<T>(
                p,
                paramType,
                false,
                structBuilder: structBuilder,
              ))
          .where((p) => p != null)
          .map((p) => p! as T)
          .toList();
    }
    switch (paramType) {
      case ParamType.int:
        return int.tryParse(param);
      case ParamType.double:
        return double.tryParse(param);
      case ParamType.String:
        return param;
      case ParamType.bool:
        return param == 'true';
      case ParamType.DateTime:
        return dateTimeFromString(param);
      case ParamType.DateTimeRange:
        return dateTimeRangeFromString(param);
      case ParamType.LatLng:
        return latLngFromString(param);
      case ParamType.Color:
        return fromCssColor(param);
      case ParamType.FFPlace:
        return placeFromString(param);
      case ParamType.FFUploadedFile:
        return uploadedFileFromString(param);
      case ParamType.JSON:
        return json.decode(param);

      case ParamType.SupabaseRow:
        final data = json.decode(param) as Map<String, dynamic>;
        switch (T) {
          case ActiveCategoryPromotionsRow:
            return ActiveCategoryPromotionsRow(data);
          case AdminLogsRow:
            return AdminLogsRow(data);
          case AppBannersRow:
            return AppBannersRow(data);
          case AppConfigRow:
            return AppConfigRow(data);
          case BookingIntentsRow:
            return BookingIntentsRow(data);
          case CartItemsRow:
            return CartItemsRow(data);
          case CartsRow:
            return CartsRow(data);
          case CitiesRow:
            return CitiesRow(data);
          case CommunicationPhonePoolRow:
            return CommunicationPhonePoolRow(data);
          case CommunicationSessionsRow:
            return CommunicationSessionsRow(data);
          case CountriesRow:
            return CountriesRow(data);
          case CountryPaymentMethodsRow:
            return CountryPaymentMethodsRow(data);
          case DebugLogsRow:
            return DebugLogsRow(data);
          case EquipmentRow:
            return EquipmentRow(data);
          case FavoritesRow:
            return FavoritesRow(data);
          case GeographyColumnsRow:
            return GeographyColumnsRow(data);
          case GeometryColumnsRow:
            return GeometryColumnsRow(data);
          case HousesRow:
            return HousesRow(data);
          case MarketingCampaignsRow:
            return MarketingCampaignsRow(data);
          case OrderChatMessagesRow:
            return OrderChatMessagesRow(data);
          case OrderItemAddonsRow:
            return OrderItemAddonsRow(data);
          case OrderItemsRow:
            return OrderItemsRow(data);
          case OrderReassignmentLogsRow:
            return OrderReassignmentLogsRow(data);
          case OrdersRow:
            return OrdersRow(data);
          case PartnerApplicationsRow:
            return PartnerApplicationsRow(data);
          case PaymentMethodsRow:
            return PaymentMethodsRow(data);
          case PaymentTypeCatalogRow:
            return PaymentTypeCatalogRow(data);
          case PricesRow:
            return PricesRow(data);
          case ProfilesRow:
            return ProfilesRow(data);
          case PromotionsRow:
            return PromotionsRow(data);
          case ReferralRedemptionsRow:
            return ReferralRedemptionsRow(data);
          case RegionalPackageItemPricesRow:
            return RegionalPackageItemPricesRow(data);
          case RegionsRow:
            return RegionsRow(data);
          case ReviewsRow:
            return ReviewsRow(data);
          case ServiceAddonsRow:
            return ServiceAddonsRow(data);
          case ServiceArrivalModesRow:
            return ServiceArrivalModesRow(data);
          case ServiceCategoriesRow:
            return ServiceCategoriesRow(data);
          case ServiceEquipmentRow:
            return ServiceEquipmentRow(data);
          case ServicePackageConfigsRow:
            return ServicePackageConfigsRow(data);
          case ServiceTasksRow:
            return ServiceTasksRow(data);
          case ServiceZonesRow:
            return ServiceZonesRow(data);
          case ServicesRow:
            return ServicesRow(data);
          case SettingsRow:
            return SettingsRow(data);
          case SpatialRefSysRow:
            return SpatialRefSysRow(data);
          case SpecialistScheduleConfigRow:
            return SpecialistScheduleConfigRow(data);
          case SpecialistServicesRow:
            return SpecialistServicesRow(data);
          case SpecialistsRow:
            return SpecialistsRow(data);
          case SupportCategoriesRow:
            return SupportCategoriesRow(data);
          case SupportChatsRow:
            return SupportChatsRow(data);
          case SupportFaqsRow:
            return SupportFaqsRow(data);
          case SupportMessagesRow:
            return SupportMessagesRow(data);
          case UserBalanceRow:
            return UserBalanceRow(data);
          case UserReferralCodesRow:
            return UserReferralCodesRow(data);
          case UserSettingsRow:
            return UserSettingsRow(data);
          case UserVouchersRow:
            return UserVouchersRow(data);
          case VActiveOrderDetailsRow:
            return VActiveOrderDetailsRow(data);
          case VArrivalModesRow:
            return VArrivalModesRow(data);
          case VReviewsWithUserRow:
            return VReviewsWithUserRow(data);
          case VServiceEquipmentDetailsRow:
            return VServiceEquipmentDetailsRow(data);
          case VSmartCatalogRow:
            return VSmartCatalogRow(data);
          case VSpecialistScheduleMonitoringRow:
            return VSpecialistScheduleMonitoringRow(data);
          case VouchersRow:
            return VouchersRow(data);
          case ZoneAnalyticsRow:
            return ZoneAnalyticsRow(data);
          case ZoneLeadsRow:
            return ZoneLeadsRow(data);
          default:
            return null;
        }

      case ParamType.DataStruct:
        final data = json.decode(param) as Map<String, dynamic>? ?? {};
        return structBuilder != null ? structBuilder(data) : null;

      case ParamType.Enum:
        return deserializeEnum<T>(param);

      default:
        return null;
    }
  } catch (e) {
    print('Error deserializing parameter: $e');
    return null;
  }
}
