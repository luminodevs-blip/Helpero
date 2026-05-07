// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SupportOptionStruct extends BaseStruct {
  SupportOptionStruct({
    bool? hasText,
    bool? textField,
  })  : _hasText = hasText,
        _textField = textField;

  // "hasText" field.
  bool? _hasText;
  bool get hasText => _hasText ?? false;
  set hasText(bool? val) => _hasText = val;

  bool hasHasText() => _hasText != null;

  // "textField" field.
  bool? _textField;
  bool get textField => _textField ?? false;
  set textField(bool? val) => _textField = val;

  bool hasTextField() => _textField != null;

  static SupportOptionStruct fromMap(Map<String, dynamic> data) =>
      SupportOptionStruct(
        hasText: data['hasText'] as bool?,
        textField: data['textField'] as bool?,
      );

  static SupportOptionStruct? maybeFromMap(dynamic data) => data is Map
      ? SupportOptionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'hasText': _hasText,
        'textField': _textField,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'hasText': serializeParam(
          _hasText,
          ParamType.bool,
        ),
        'textField': serializeParam(
          _textField,
          ParamType.bool,
        ),
      }.withoutNulls;

  static SupportOptionStruct fromSerializableMap(Map<String, dynamic> data) =>
      SupportOptionStruct(
        hasText: deserializeParam(
          data['hasText'],
          ParamType.bool,
          false,
        ),
        textField: deserializeParam(
          data['textField'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'SupportOptionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SupportOptionStruct &&
        hasText == other.hasText &&
        textField == other.textField;
  }

  @override
  int get hashCode => const ListEquality().hash([hasText, textField]);
}

SupportOptionStruct createSupportOptionStruct({
  bool? hasText,
  bool? textField,
}) =>
    SupportOptionStruct(
      hasText: hasText,
      textField: textField,
    );
