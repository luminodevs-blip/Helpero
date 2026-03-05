// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// чтобы не делать два экрана для OTP
class AuthTypeStruct extends BaseStruct {
  AuthTypeStruct({
    EnVerificationType? authType,
    String? targetValue,
  })  : _authType = authType,
        _targetValue = targetValue;

  // "authType" field.
  EnVerificationType? _authType;
  EnVerificationType? get authType => _authType;
  set authType(EnVerificationType? val) => _authType = val;

  bool hasAuthType() => _authType != null;

  // "targetValue" field.
  String? _targetValue;
  String get targetValue => _targetValue ?? '';
  set targetValue(String? val) => _targetValue = val;

  bool hasTargetValue() => _targetValue != null;

  static AuthTypeStruct fromMap(Map<String, dynamic> data) => AuthTypeStruct(
        authType: data['authType'] is EnVerificationType
            ? data['authType']
            : deserializeEnum<EnVerificationType>(data['authType']),
        targetValue: data['targetValue'] as String?,
      );

  static AuthTypeStruct? maybeFromMap(dynamic data) =>
      data is Map ? AuthTypeStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'authType': _authType?.serialize(),
        'targetValue': _targetValue,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'authType': serializeParam(
          _authType,
          ParamType.Enum,
        ),
        'targetValue': serializeParam(
          _targetValue,
          ParamType.String,
        ),
      }.withoutNulls;

  static AuthTypeStruct fromSerializableMap(Map<String, dynamic> data) =>
      AuthTypeStruct(
        authType: deserializeParam<EnVerificationType>(
          data['authType'],
          ParamType.Enum,
          false,
        ),
        targetValue: deserializeParam(
          data['targetValue'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AuthTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AuthTypeStruct &&
        authType == other.authType &&
        targetValue == other.targetValue;
  }

  @override
  int get hashCode => const ListEquality().hash([authType, targetValue]);
}

AuthTypeStruct createAuthTypeStruct({
  EnVerificationType? authType,
  String? targetValue,
}) =>
    AuthTypeStruct(
      authType: authType,
      targetValue: targetValue,
    );
