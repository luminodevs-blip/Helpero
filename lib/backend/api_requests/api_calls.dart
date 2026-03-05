import 'dart:convert';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class SendPhoneOTPCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
  }) async {
    final ffApiRequestBody = '''
{
  "phone": "${escapeStringForJson(phone)}",
  "type": "sms"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SendPhoneOTP',
      apiUrl: 'https://hwgmjlsoeebgounmthmr.supabase.co/auth/v1/otp',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class VerifyPhoneOTPCall {
  static Future<ApiCallResponse> call({
    String? phone = '',
    String? token = '',
  }) async {
    final ffApiRequestBody = '''
{
  "phone": "${escapeStringForJson(phone)}",
  "token": "${escapeStringForJson(token)}",
  "type": "sms"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'VerifyPhoneOTP',
      apiUrl: 'https://hwgmjlsoeebgounmthmr.supabase.co/auth/v1/verify',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GoogleMapsAutocompleteCall {
  static Future<ApiCallResponse> call({
    String? input = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'GoogleMapsAutocomplete',
      apiUrl: 'https://maps.googleapis.com/maps/api/place/autocomplete/json',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'input': input,
        'key': "AIzaSyDMAz7bK8pW4FAUsbR3o9hzBYM2bAKRkQY",
        'language': "en",
        'components': "country:ca",
        'types': "address",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? predictions(dynamic response) => getJsonField(
        response,
        r'''$.predictions''',
        true,
      ) as List?;
  static List<String>? mainText(dynamic response) => (getJsonField(
        response,
        r'''$.predictions[:].structured_formatting.main_text''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? secondaryText(dynamic response) => (getJsonField(
        response,
        r'''$.predictions[:].structured_formatting.secondary_text''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class MapboxAutocompleteCall {
  static Future<ApiCallResponse> call({
    String? query = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'MapboxAutocomplete',
      apiUrl: 'https://api.mapbox.com/geocoding/v5/mapbox.places/${query}.json',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'access_token':
            "pk.eyJ1IjoibWF4bWloMzg2IiwiYSI6ImNtanl0MHVncDFqc3YzZHM5aG9vZ2dqdTUifQ.x3C6VjgWTVMITzCwwArp_A",
        'language': "en",
        'autocomplet': "true",
        'limit': "10",
        'types': "address,poi,place",
        'country': "ca,gb",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? predictions(dynamic response) => getJsonField(
        response,
        r'''$.features''',
        true,
      ) as List?;
  static List<String>? mainText(dynamic response) => (getJsonField(
        response,
        r'''$.features[:].text''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? secondaryText(dynamic response) => (getJsonField(
        response,
        r'''$.features[:].place_name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List? location(dynamic response) => getJsonField(
        response,
        r'''$.features[:].center''',
        true,
      ) as List?;
}

class SendEmailOTPCall {
  static Future<ApiCallResponse> call({
    String? email = '',
  }) async {
    final ffApiRequestBody = '''
{
  "email": "${escapeStringForJson(email)}",
  "type": "magiclink",
  "create_user": true
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SendEmailOTP',
      apiUrl: 'https://hwgmjlsoeebgounmthmr.supabase.co/auth/v1/otp',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class VerifyEmailOTPCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? token = '',
  }) async {
    final ffApiRequestBody = '''
{
  "email": "${escapeStringForJson(email)}",
  "token": "${escapeStringForJson(token)}",
  "type": "email"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'VerifyEmailOTP',
      apiUrl: 'https://hwgmjlsoeebgounmthmr.supabase.co/auth/v1/verify',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CheckAvailabilityCall {
  static Future<ApiCallResponse> call({
    int? houseId,
    int? serviceId,
    int? durationMinutes,
    String? targetDate = '',
  }) async {
    final ffApiRequestBody = '''
{
  "house_id": ${houseId},
  "service_id": ${serviceId},
  "duration_minutes": ${durationMinutes}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CheckAvailability',
      apiUrl:
          'https://hwgmjlsoeebgounmthmr.supabase.co/functions/v1/check_availability',
      callType: ApiCallType.POST,
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<ArrivalOptionStructStruct>? slotslist(dynamic response) =>
      (getJsonField(
        response,
        r'''$.slots''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => ArrivalOptionStructStruct.maybeFromMap(x))
          .withoutNulls
          .toList();
  static bool? success(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.success''',
      ));
  static String? errormsg(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.error''',
      ));
}

class GetWeeklyAvailabilityCall {
  static Future<ApiCallResponse> call() async {
    final ffApiRequestBody = '''
{
  "house_id": "80687707-160a-4712-8703-9e450ce4826b",
  "service_id": 1,
  "duration_minutes": 120
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetWeeklyAvailability',
      apiUrl:
          'https://hwgmjlsoeebgounmthmr.supabase.co/functions/v1/get_weekly_availability',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreatePaymentIntentCall {
  static Future<ApiCallResponse> call({
    double? amount,
    String? orderId = '',
    String? email = '',
  }) async {
    final ffApiRequestBody = '''
{
  "amount": ${amount},
  "currency": "cad",
  "order_id": "${escapeStringForJson(orderId)}",
  "customer_email": "${escapeStringForJson(email)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreatePaymentIntent',
      apiUrl:
          'https://hwgmjlsoeebgounmthmr.functions.supabase.co/process_payment',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SyncCartCall {
  static Future<ApiCallResponse> call({
    String? cartId = '',
    String? userId = '',
    String? items = '',
    String? authToken = '',
    int? pCategory,
  }) async {
    final ffApiRequestBody = '''
{
  "p_cart_id": "${escapeStringForJson(cartId)}",
  "p_user_id": "${escapeStringForJson(userId)}",
  "p_items": "${escapeStringForJson(items)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SyncCart',
      apiUrl: 'https://hwgmjlsoeebgounmthmr.supabase.co/rest/v1/rpc/sync_cart',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4',
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CalculateCheckoutCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? cartId = '',
    int? houseId,
    String? arrivalModeId = '',
    String? slotStart = '',
    String? voucherId = '',
    bool? useBalance,
  }) async {
    final ffApiRequestBody = '''
{
  "cart_id": "${escapeStringForJson(cartId)}",
  "house_id": ${houseId},
  "arrival_mode_id": "${escapeStringForJson(arrivalModeId)}",
  "slot_start": "${escapeStringForJson(slotStart)}",
  "voucher_id": "${escapeStringForJson(voucherId)}",
  "use_balance": ${useBalance}
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'CalculateCheckout',
      apiUrl:
          'https://hwgmjlsoeebgounmthmr.supabase.co/functions/v1/calculate-checkout',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4',
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ProcessPaymentCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? cartId = '',
    int? houseId,
    String? arrivalModeId = '',
    String? slotStart = '',
    String? voucherId = '',
    bool? useBalance,
    String? customerEmail = '',
  }) async {
    final ffApiRequestBody = '''
{
  "cart_id": "${escapeStringForJson(cartId)}",
  "house_id": ${houseId},
  "arrival_mode_id": "${escapeStringForJson(arrivalModeId)}",
  "slot_start": "${escapeStringForJson(slotStart)}",
  "voucher_id": "${escapeStringForJson(voucherId)}",
  "use_balance": ${useBalance},
  "customer_email": "${escapeStringForJson(customerEmail)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ProcessPayment',
      apiUrl:
          'https://hwgmjlsoeebgounmthmr.supabase.co/functions/v1/process_payment',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4',
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserVouchersCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? cartId = '',
  }) async {
    final ffApiRequestBody = '''
{
    "cart_id": "${escapeStringForJson(cartId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getUserVouchers',
      apiUrl:
          'https://hwgmjlsoeebgounmthmr.supabase.co/functions/v1/get_user_vouchers',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<UserVoucherStruct>? vouchers(dynamic response) => (getJsonField(
        response,
        r'''$.vouchers''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => UserVoucherStruct.maybeFromMap(x))
          .withoutNulls
          .toList();
}

class ClaimVoucherCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? code = '',
  }) async {
    final ffApiRequestBody = '''
{
  "code": "${escapeStringForJson(code)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'claimVoucher',
      apiUrl:
          'https://hwgmjlsoeebgounmthmr.supabase.co/functions/v1/claim_voucher',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetPromotionsCall {
  static Future<ApiCallResponse> call({
    int? categoryId,
    int? cityId,
    int? zoneId,
  }) async {
    final ffApiRequestBody = '''
{
    "category_id": ${categoryId},
    "city_id": ${cityId},
    "zone_id": ${zoneId}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getPromotions',
      apiUrl:
          'https://hwgmjlsoeebgounmthmr.supabase.co/functions/v1/get_promotions',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CancelpaymentCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? paymentIntentId = '',
    int? orderId,
  }) async {
    final ffApiRequestBody = '''
{
  "payment_intent_id": "${escapeStringForJson(paymentIntentId)}",
  "order_id": ${orderId}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'cancelpayment',
      apiUrl:
          'https://hwgmjlsoeebgounmthmr.supabase.co/functions/v1/cancel-payment',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
