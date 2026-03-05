// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Что входит в уборку (с картинкой).
class IncludedItemStructStruct extends BaseStruct {
  IncludedItemStructStruct({
    String? name,
    String? image,
  })  : _name = name,
        _image = image;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

  static IncludedItemStructStruct fromMap(Map<String, dynamic> data) =>
      IncludedItemStructStruct(
        name: data['name'] as String?,
        image: data['image'] as String?,
      );

  static IncludedItemStructStruct? maybeFromMap(dynamic data) => data is Map
      ? IncludedItemStructStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'image': _image,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'image': serializeParam(
          _image,
          ParamType.String,
        ),
      }.withoutNulls;

  static IncludedItemStructStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      IncludedItemStructStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        image: deserializeParam(
          data['image'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'IncludedItemStructStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is IncludedItemStructStruct &&
        name == other.name &&
        image == other.image;
  }

  @override
  int get hashCode => const ListEquality().hash([name, image]);
}

IncludedItemStructStruct createIncludedItemStructStruct({
  String? name,
  String? image,
}) =>
    IncludedItemStructStruct(
      name: name,
      image: image,
    );
