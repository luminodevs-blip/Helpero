// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Требования (например, пылесос).
class RequirementStructStruct extends BaseStruct {
  RequirementStructStruct({
    String? text,

    /// ссылка на иконку или название
    String? icon,
  })  : _text = text,
        _icon = icon;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  set text(String? val) => _text = val;

  bool hasText() => _text != null;

  // "icon" field.
  String? _icon;
  String get icon => _icon ?? '';
  set icon(String? val) => _icon = val;

  bool hasIcon() => _icon != null;

  static RequirementStructStruct fromMap(Map<String, dynamic> data) =>
      RequirementStructStruct(
        text: data['text'] as String?,
        icon: data['icon'] as String?,
      );

  static RequirementStructStruct? maybeFromMap(dynamic data) => data is Map
      ? RequirementStructStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'text': _text,
        'icon': _icon,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'text': serializeParam(
          _text,
          ParamType.String,
        ),
        'icon': serializeParam(
          _icon,
          ParamType.String,
        ),
      }.withoutNulls;

  static RequirementStructStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      RequirementStructStruct(
        text: deserializeParam(
          data['text'],
          ParamType.String,
          false,
        ),
        icon: deserializeParam(
          data['icon'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RequirementStructStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RequirementStructStruct &&
        text == other.text &&
        icon == other.icon;
  }

  @override
  int get hashCode => const ListEquality().hash([text, icon]);
}

RequirementStructStruct createRequirementStructStruct({
  String? text,
  String? icon,
}) =>
    RequirementStructStruct(
      text: text,
      icon: icon,
    );
