// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Адрес пользователя.
class AddressStructStruct extends BaseStruct {
  AddressStructStruct({
    int? id,
    String? nameLabel,
    String? propertyType,
    String? fullAddress,
    double? lat,
    double? lng,
    String? zipCode,
    String? city,
    bool? isDefault,
    String? floor,
    String? unit,
    String? buzzCode,
    String? gateCode,
    String? companyName,
    String? instructions,
  })  : _id = id,
        _nameLabel = nameLabel,
        _propertyType = propertyType,
        _fullAddress = fullAddress,
        _lat = lat,
        _lng = lng,
        _zipCode = zipCode,
        _city = city,
        _isDefault = isDefault,
        _floor = floor,
        _unit = unit,
        _buzzCode = buzzCode,
        _gateCode = gateCode,
        _companyName = companyName,
        _instructions = instructions;

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

  // "propertyType" field.
  String? _propertyType;
  String get propertyType => _propertyType ?? '';
  set propertyType(String? val) => _propertyType = val;

  bool hasPropertyType() => _propertyType != null;

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

  // "floor" field.
  String? _floor;
  String get floor => _floor ?? '';
  set floor(String? val) => _floor = val;

  bool hasFloor() => _floor != null;

  // "unit" field.
  String? _unit;
  String get unit => _unit ?? '';
  set unit(String? val) => _unit = val;

  bool hasUnit() => _unit != null;

  // "buzzCode" field.
  String? _buzzCode;
  String get buzzCode => _buzzCode ?? '';
  set buzzCode(String? val) => _buzzCode = val;

  bool hasBuzzCode() => _buzzCode != null;

  // "gateCode" field.
  String? _gateCode;
  String get gateCode => _gateCode ?? '';
  set gateCode(String? val) => _gateCode = val;

  bool hasGateCode() => _gateCode != null;

  // "companyName" field.
  String? _companyName;
  String get companyName => _companyName ?? '';
  set companyName(String? val) => _companyName = val;

  bool hasCompanyName() => _companyName != null;

  // "instructions" field.
  String? _instructions;
  String get instructions => _instructions ?? '';
  set instructions(String? val) => _instructions = val;

  bool hasInstructions() => _instructions != null;

  static AddressStructStruct fromMap(Map<String, dynamic> data) =>
      AddressStructStruct(
        id: castToType<int>(data['id']),
        nameLabel: data['name_label'] as String?,
        propertyType: data['propertyType'] as String?,
        fullAddress: data['fullAddress'] as String?,
        lat: castToType<double>(data['lat']),
        lng: castToType<double>(data['lng']),
        zipCode: data['zipCode'] as String?,
        city: data['city'] as String?,
        isDefault: data['isDefault'] as bool?,
        floor: data['floor'] as String?,
        unit: data['unit'] as String?,
        buzzCode: data['buzzCode'] as String?,
        gateCode: data['gateCode'] as String?,
        companyName: data['companyName'] as String?,
        instructions: data['instructions'] as String?,
      );

  static AddressStructStruct? maybeFromMap(dynamic data) => data is Map
      ? AddressStructStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name_label': _nameLabel,
        'propertyType': _propertyType,
        'fullAddress': _fullAddress,
        'lat': _lat,
        'lng': _lng,
        'zipCode': _zipCode,
        'city': _city,
        'isDefault': _isDefault,
        'floor': _floor,
        'unit': _unit,
        'buzzCode': _buzzCode,
        'gateCode': _gateCode,
        'companyName': _companyName,
        'instructions': _instructions,
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
        'propertyType': serializeParam(
          _propertyType,
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
        'floor': serializeParam(
          _floor,
          ParamType.String,
        ),
        'unit': serializeParam(
          _unit,
          ParamType.String,
        ),
        'buzzCode': serializeParam(
          _buzzCode,
          ParamType.String,
        ),
        'gateCode': serializeParam(
          _gateCode,
          ParamType.String,
        ),
        'companyName': serializeParam(
          _companyName,
          ParamType.String,
        ),
        'instructions': serializeParam(
          _instructions,
          ParamType.String,
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
        propertyType: deserializeParam(
          data['propertyType'],
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
        floor: deserializeParam(
          data['floor'],
          ParamType.String,
          false,
        ),
        unit: deserializeParam(
          data['unit'],
          ParamType.String,
          false,
        ),
        buzzCode: deserializeParam(
          data['buzzCode'],
          ParamType.String,
          false,
        ),
        gateCode: deserializeParam(
          data['gateCode'],
          ParamType.String,
          false,
        ),
        companyName: deserializeParam(
          data['companyName'],
          ParamType.String,
          false,
        ),
        instructions: deserializeParam(
          data['instructions'],
          ParamType.String,
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
        propertyType == other.propertyType &&
        fullAddress == other.fullAddress &&
        lat == other.lat &&
        lng == other.lng &&
        zipCode == other.zipCode &&
        city == other.city &&
        isDefault == other.isDefault &&
        floor == other.floor &&
        unit == other.unit &&
        buzzCode == other.buzzCode &&
        gateCode == other.gateCode &&
        companyName == other.companyName &&
        instructions == other.instructions;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        nameLabel,
        propertyType,
        fullAddress,
        lat,
        lng,
        zipCode,
        city,
        isDefault,
        floor,
        unit,
        buzzCode,
        gateCode,
        companyName,
        instructions
      ]);
}

AddressStructStruct createAddressStructStruct({
  int? id,
  String? nameLabel,
  String? propertyType,
  String? fullAddress,
  double? lat,
  double? lng,
  String? zipCode,
  String? city,
  bool? isDefault,
  String? floor,
  String? unit,
  String? buzzCode,
  String? gateCode,
  String? companyName,
  String? instructions,
}) =>
    AddressStructStruct(
      id: id,
      nameLabel: nameLabel,
      propertyType: propertyType,
      fullAddress: fullAddress,
      lat: lat,
      lng: lng,
      zipCode: zipCode,
      city: city,
      isDefault: isDefault,
      floor: floor,
      unit: unit,
      buzzCode: buzzCode,
      gateCode: gateCode,
      companyName: companyName,
      instructions: instructions,
    );
