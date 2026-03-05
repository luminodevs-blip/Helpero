// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Адрес пользователя.
class AddressStructStruct extends BaseStruct {
  AddressStructStruct({
    int? id,
    String? nameLabel,
    String? fullAddress,
    double? lat,
    double? lng,
    String? zipCode,
    String? city,
    bool? isDefault,
  })  : _id = id,
        _nameLabel = nameLabel,
        _fullAddress = fullAddress,
        _lat = lat,
        _lng = lng,
        _zipCode = zipCode,
        _city = city,
        _isDefault = isDefault;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "name_label" field.
  String? _nameLabel;
  String get nameLabel => _nameLabel ?? '';
  set nameLabel(String? val) => _nameLabel = val;

  bool hasNameLabel() => _nameLabel != null;

  // "fullAddress" field.
  String? _fullAddress;
  String get fullAddress => _fullAddress ?? '';
  set fullAddress(String? val) => _fullAddress = val;

  bool hasFullAddress() => _fullAddress != null;

  // "lat" field.
  double? _lat;
  double get lat => _lat ?? 0.0;
  set lat(double? val) => _lat = val;

  void incrementLat(double amount) => lat = lat + amount;

  bool hasLat() => _lat != null;

  // "lng" field.
  double? _lng;
  double get lng => _lng ?? 0.0;
  set lng(double? val) => _lng = val;

  void incrementLng(double amount) => lng = lng + amount;

  bool hasLng() => _lng != null;

  // "zipCode" field.
  String? _zipCode;
  String get zipCode => _zipCode ?? '';
  set zipCode(String? val) => _zipCode = val;

  bool hasZipCode() => _zipCode != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "isDefault" field.
  bool? _isDefault;
  bool get isDefault => _isDefault ?? false;
  set isDefault(bool? val) => _isDefault = val;

  bool hasIsDefault() => _isDefault != null;

  static AddressStructStruct fromMap(Map<String, dynamic> data) =>
      AddressStructStruct(
        id: castToType<int>(data['id']),
        nameLabel: data['name_label'] as String?,
        fullAddress: data['fullAddress'] as String?,
        lat: castToType<double>(data['lat']),
        lng: castToType<double>(data['lng']),
        zipCode: data['zipCode'] as String?,
        city: data['city'] as String?,
        isDefault: data['isDefault'] as bool?,
      );

  static AddressStructStruct? maybeFromMap(dynamic data) => data is Map
      ? AddressStructStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name_label': _nameLabel,
        'fullAddress': _fullAddress,
        'lat': _lat,
        'lng': _lng,
        'zipCode': _zipCode,
        'city': _city,
        'isDefault': _isDefault,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'name_label': serializeParam(
          _nameLabel,
          ParamType.String,
        ),
        'fullAddress': serializeParam(
          _fullAddress,
          ParamType.String,
        ),
        'lat': serializeParam(
          _lat,
          ParamType.double,
        ),
        'lng': serializeParam(
          _lng,
          ParamType.double,
        ),
        'zipCode': serializeParam(
          _zipCode,
          ParamType.String,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'isDefault': serializeParam(
          _isDefault,
          ParamType.bool,
        ),
      }.withoutNulls;

  static AddressStructStruct fromSerializableMap(Map<String, dynamic> data) =>
      AddressStructStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        nameLabel: deserializeParam(
          data['name_label'],
          ParamType.String,
          false,
        ),
        fullAddress: deserializeParam(
          data['fullAddress'],
          ParamType.String,
          false,
        ),
        lat: deserializeParam(
          data['lat'],
          ParamType.double,
          false,
        ),
        lng: deserializeParam(
          data['lng'],
          ParamType.double,
          false,
        ),
        zipCode: deserializeParam(
          data['zipCode'],
          ParamType.String,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        isDefault: deserializeParam(
          data['isDefault'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'AddressStructStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AddressStructStruct &&
        id == other.id &&
        nameLabel == other.nameLabel &&
        fullAddress == other.fullAddress &&
        lat == other.lat &&
        lng == other.lng &&
        zipCode == other.zipCode &&
        city == other.city &&
        isDefault == other.isDefault;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, nameLabel, fullAddress, lat, lng, zipCode, city, isDefault]);
}

AddressStructStruct createAddressStructStruct({
  int? id,
  String? nameLabel,
  String? fullAddress,
  double? lat,
  double? lng,
  String? zipCode,
  String? city,
  bool? isDefault,
}) =>
    AddressStructStruct(
      id: id,
      nameLabel: nameLabel,
      fullAddress: fullAddress,
      lat: lat,
      lng: lng,
      zipCode: zipCode,
      city: city,
      isDefault: isDefault,
    );
