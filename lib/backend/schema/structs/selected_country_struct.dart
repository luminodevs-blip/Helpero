// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SelectedCountryStruct extends BaseStruct {
  SelectedCountryStruct({
    String? name,
    String? flag,
    String? countryCode,
  })  : _name = name,
        _flag = flag,
        _countryCode = countryCode;

  // "Name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "Flag" field.
  String? _flag;
  String get flag => _flag ?? '';
  set flag(String? val) => _flag = val;

  bool hasFlag() => _flag != null;

  // "CountryCode" field.
  String? _countryCode;
  String get countryCode => _countryCode ?? '';
  set countryCode(String? val) => _countryCode = val;

  bool hasCountryCode() => _countryCode != null;

  static SelectedCountryStruct fromMap(Map<String, dynamic> data) =>
      SelectedCountryStruct(
        name: data['Name'] as String?,
        flag: data['Flag'] as String?,
        countryCode: data['CountryCode'] as String?,
      );

  static SelectedCountryStruct? maybeFromMap(dynamic data) => data is Map
      ? SelectedCountryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'Name': _name,
        'Flag': _flag,
        'CountryCode': _countryCode,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Name': serializeParam(
          _name,
          ParamType.String,
        ),
        'Flag': serializeParam(
          _flag,
          ParamType.String,
        ),
        'CountryCode': serializeParam(
          _countryCode,
          ParamType.String,
        ),
      }.withoutNulls;

  static SelectedCountryStruct fromSerializableMap(Map<String, dynamic> data) =>
      SelectedCountryStruct(
        name: deserializeParam(
          data['Name'],
          ParamType.String,
          false,
        ),
        flag: deserializeParam(
          data['Flag'],
          ParamType.String,
          false,
        ),
        countryCode: deserializeParam(
          data['CountryCode'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SelectedCountryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SelectedCountryStruct &&
        name == other.name &&
        flag == other.flag &&
        countryCode == other.countryCode;
  }

  @override
  int get hashCode => const ListEquality().hash([name, flag, countryCode]);
}

SelectedCountryStruct createSelectedCountryStruct({
  String? name,
  String? flag,
  String? countryCode,
}) =>
    SelectedCountryStruct(
      name: name,
      flag: flag,
      countryCode: countryCode,
    );
