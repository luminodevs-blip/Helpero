// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserVoucherStruct extends BaseStruct {
  UserVoucherStruct({
    String? id,
    String? title,
    String? description,
    String? targetAudience,
    String? expiresAt,
    bool? isApplicable,
    String? disableReason,
    String? code,
    String? status,
  })  : _id = id,
        _title = title,
        _description = description,
        _targetAudience = targetAudience,
        _expiresAt = expiresAt,
        _isApplicable = isApplicable,
        _disableReason = disableReason,
        _code = code,
        _status = status;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "target_audience" field.
  String? _targetAudience;
  String get targetAudience => _targetAudience ?? '';
  set targetAudience(String? val) => _targetAudience = val;

  bool hasTargetAudience() => _targetAudience != null;

  // "expires_at" field.
  String? _expiresAt;
  String get expiresAt => _expiresAt ?? '';
  set expiresAt(String? val) => _expiresAt = val;

  bool hasExpiresAt() => _expiresAt != null;

  // "is_applicable" field.
  bool? _isApplicable;
  bool get isApplicable => _isApplicable ?? false;
  set isApplicable(bool? val) => _isApplicable = val;

  bool hasIsApplicable() => _isApplicable != null;

  // "disable_reason" field.
  String? _disableReason;
  String get disableReason => _disableReason ?? '';
  set disableReason(String? val) => _disableReason = val;

  bool hasDisableReason() => _disableReason != null;

  // "code" field.
  String? _code;
  String get code => _code ?? '';
  set code(String? val) => _code = val;

  bool hasCode() => _code != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  static UserVoucherStruct fromMap(Map<String, dynamic> data) =>
      UserVoucherStruct(
        id: data['id'] as String?,
        title: data['title'] as String?,
        description: data['description'] as String?,
        targetAudience: data['target_audience'] as String?,
        expiresAt: data['expires_at'] as String?,
        isApplicable: data['is_applicable'] as bool?,
        disableReason: data['disable_reason'] as String?,
        code: data['code'] as String?,
        status: data['status'] as String?,
      );

  static UserVoucherStruct? maybeFromMap(dynamic data) => data is Map
      ? UserVoucherStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'description': _description,
        'target_audience': _targetAudience,
        'expires_at': _expiresAt,
        'is_applicable': _isApplicable,
        'disable_reason': _disableReason,
        'code': _code,
        'status': _status,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'target_audience': serializeParam(
          _targetAudience,
          ParamType.String,
        ),
        'expires_at': serializeParam(
          _expiresAt,
          ParamType.String,
        ),
        'is_applicable': serializeParam(
          _isApplicable,
          ParamType.bool,
        ),
        'disable_reason': serializeParam(
          _disableReason,
          ParamType.String,
        ),
        'code': serializeParam(
          _code,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
      }.withoutNulls;

  static UserVoucherStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserVoucherStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        targetAudience: deserializeParam(
          data['target_audience'],
          ParamType.String,
          false,
        ),
        expiresAt: deserializeParam(
          data['expires_at'],
          ParamType.String,
          false,
        ),
        isApplicable: deserializeParam(
          data['is_applicable'],
          ParamType.bool,
          false,
        ),
        disableReason: deserializeParam(
          data['disable_reason'],
          ParamType.String,
          false,
        ),
        code: deserializeParam(
          data['code'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UserVoucherStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserVoucherStruct &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        targetAudience == other.targetAudience &&
        expiresAt == other.expiresAt &&
        isApplicable == other.isApplicable &&
        disableReason == other.disableReason &&
        code == other.code &&
        status == other.status;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        title,
        description,
        targetAudience,
        expiresAt,
        isApplicable,
        disableReason,
        code,
        status
      ]);
}

UserVoucherStruct createUserVoucherStruct({
  String? id,
  String? title,
  String? description,
  String? targetAudience,
  String? expiresAt,
  bool? isApplicable,
  String? disableReason,
  String? code,
  String? status,
}) =>
    UserVoucherStruct(
      id: id,
      title: title,
      description: description,
      targetAudience: targetAudience,
      expiresAt: expiresAt,
      isApplicable: isApplicable,
      disableReason: disableReason,
      code: code,
      status: status,
    );
