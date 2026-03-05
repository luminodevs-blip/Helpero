// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StripeStruct extends BaseStruct {
  StripeStruct({
    String? stripeTestKey,
    String? stripeLiveKey,
  })  : _stripeTestKey = stripeTestKey,
        _stripeLiveKey = stripeLiveKey;

  // "stripeTestKey" field.
  String? _stripeTestKey;
  String get stripeTestKey => _stripeTestKey ?? '';
  set stripeTestKey(String? val) => _stripeTestKey = val;

  bool hasStripeTestKey() => _stripeTestKey != null;

  // "stripeLiveKey" field.
  String? _stripeLiveKey;
  String get stripeLiveKey => _stripeLiveKey ?? '';
  set stripeLiveKey(String? val) => _stripeLiveKey = val;

  bool hasStripeLiveKey() => _stripeLiveKey != null;

  static StripeStruct fromMap(Map<String, dynamic> data) => StripeStruct(
        stripeTestKey: data['stripeTestKey'] as String?,
        stripeLiveKey: data['stripeLiveKey'] as String?,
      );

  static StripeStruct? maybeFromMap(dynamic data) =>
      data is Map ? StripeStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'stripeTestKey': _stripeTestKey,
        'stripeLiveKey': _stripeLiveKey,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'stripeTestKey': serializeParam(
          _stripeTestKey,
          ParamType.String,
        ),
        'stripeLiveKey': serializeParam(
          _stripeLiveKey,
          ParamType.String,
        ),
      }.withoutNulls;

  static StripeStruct fromSerializableMap(Map<String, dynamic> data) =>
      StripeStruct(
        stripeTestKey: deserializeParam(
          data['stripeTestKey'],
          ParamType.String,
          false,
        ),
        stripeLiveKey: deserializeParam(
          data['stripeLiveKey'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'StripeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StripeStruct &&
        stripeTestKey == other.stripeTestKey &&
        stripeLiveKey == other.stripeLiveKey;
  }

  @override
  int get hashCode => const ListEquality().hash([stripeTestKey, stripeLiveKey]);
}

StripeStruct createStripeStruct({
  String? stripeTestKey,
  String? stripeLiveKey,
}) =>
    StripeStruct(
      stripeTestKey: stripeTestKey,
      stripeLiveKey: stripeLiveKey,
    );
