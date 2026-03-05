// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// описывает объект уборки.
class DtHouseInfoStruct extends BaseStruct {
  DtHouseInfoStruct({
    /// ID дома из Supabase.
    int? id,

    /// Красивое название (например, «Дом в Торонто» или «Офис»).
    String? nameLabel,

    /// тип (Apartment, House, Office).
    String? propertyType,
    String? fullAddress,

    /// Почтовый индекс (важно для налогов и точности).
    String? zipCode,

    /// Город (Oakville, Toronto).
    String? city,

    /// общая квадратура.
    double? areaSize,

    /// количество спален/комнат.
    int? numBedrooms,

    /// количество туалетов/ванных.
    int? numBathrooms,

    /// широта (для расчета дистанции).
    double? lat,

    /// долгота.
    double? lng,
  })  : _id = id,
        _nameLabel = nameLabel,
        _propertyType = propertyType,
        _fullAddress = fullAddress,
        _zipCode = zipCode,
        _city = city,
        _areaSize = areaSize,
        _numBedrooms = numBedrooms,
        _numBathrooms = numBathrooms,
        _lat = lat,
        _lng = lng;

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

  // "property_type" field.
  String? _propertyType;
  String get propertyType => _propertyType ?? '';
  set propertyType(String? val) => _propertyType = val;

  bool hasPropertyType() => _propertyType != null;

  // "full_address" field.
  String? _fullAddress;
  String get fullAddress => _fullAddress ?? '';
  set fullAddress(String? val) => _fullAddress = val;

  bool hasFullAddress() => _fullAddress != null;

  // "zip_code" field.
  String? _zipCode;
  String get zipCode => _zipCode ?? '';
  set zipCode(String? val) => _zipCode = val;

  bool hasZipCode() => _zipCode != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "area_size" field.
  double? _areaSize;
  double get areaSize => _areaSize ?? 0.0;
  set areaSize(double? val) => _areaSize = val;

  void incrementAreaSize(double amount) => areaSize = areaSize + amount;

  bool hasAreaSize() => _areaSize != null;

  // "num_bedrooms" field.
  int? _numBedrooms;
  int get numBedrooms => _numBedrooms ?? 0;
  set numBedrooms(int? val) => _numBedrooms = val;

  void incrementNumBedrooms(int amount) => numBedrooms = numBedrooms + amount;

  bool hasNumBedrooms() => _numBedrooms != null;

  // "num_bathrooms" field.
  int? _numBathrooms;
  int get numBathrooms => _numBathrooms ?? 0;
  set numBathrooms(int? val) => _numBathrooms = val;

  void incrementNumBathrooms(int amount) =>
      numBathrooms = numBathrooms + amount;

  bool hasNumBathrooms() => _numBathrooms != null;

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

  static DtHouseInfoStruct fromMap(Map<String, dynamic> data) =>
      DtHouseInfoStruct(
        id: castToType<int>(data['id']),
        nameLabel: data['name_label'] as String?,
        propertyType: data['property_type'] as String?,
        fullAddress: data['full_address'] as String?,
        zipCode: data['zip_code'] as String?,
        city: data['city'] as String?,
        areaSize: castToType<double>(data['area_size']),
        numBedrooms: castToType<int>(data['num_bedrooms']),
        numBathrooms: castToType<int>(data['num_bathrooms']),
        lat: castToType<double>(data['lat']),
        lng: castToType<double>(data['lng']),
      );

  static DtHouseInfoStruct? maybeFromMap(dynamic data) => data is Map
      ? DtHouseInfoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name_label': _nameLabel,
        'property_type': _propertyType,
        'full_address': _fullAddress,
        'zip_code': _zipCode,
        'city': _city,
        'area_size': _areaSize,
        'num_bedrooms': _numBedrooms,
        'num_bathrooms': _numBathrooms,
        'lat': _lat,
        'lng': _lng,
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
        'property_type': serializeParam(
          _propertyType,
          ParamType.String,
        ),
        'full_address': serializeParam(
          _fullAddress,
          ParamType.String,
        ),
        'zip_code': serializeParam(
          _zipCode,
          ParamType.String,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'area_size': serializeParam(
          _areaSize,
          ParamType.double,
        ),
        'num_bedrooms': serializeParam(
          _numBedrooms,
          ParamType.int,
        ),
        'num_bathrooms': serializeParam(
          _numBathrooms,
          ParamType.int,
        ),
        'lat': serializeParam(
          _lat,
          ParamType.double,
        ),
        'lng': serializeParam(
          _lng,
          ParamType.double,
        ),
      }.withoutNulls;

  static DtHouseInfoStruct fromSerializableMap(Map<String, dynamic> data) =>
      DtHouseInfoStruct(
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
          data['property_type'],
          ParamType.String,
          false,
        ),
        fullAddress: deserializeParam(
          data['full_address'],
          ParamType.String,
          false,
        ),
        zipCode: deserializeParam(
          data['zip_code'],
          ParamType.String,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        areaSize: deserializeParam(
          data['area_size'],
          ParamType.double,
          false,
        ),
        numBedrooms: deserializeParam(
          data['num_bedrooms'],
          ParamType.int,
          false,
        ),
        numBathrooms: deserializeParam(
          data['num_bathrooms'],
          ParamType.int,
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
      );

  @override
  String toString() => 'DtHouseInfoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DtHouseInfoStruct &&
        id == other.id &&
        nameLabel == other.nameLabel &&
        propertyType == other.propertyType &&
        fullAddress == other.fullAddress &&
        zipCode == other.zipCode &&
        city == other.city &&
        areaSize == other.areaSize &&
        numBedrooms == other.numBedrooms &&
        numBathrooms == other.numBathrooms &&
        lat == other.lat &&
        lng == other.lng;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        nameLabel,
        propertyType,
        fullAddress,
        zipCode,
        city,
        areaSize,
        numBedrooms,
        numBathrooms,
        lat,
        lng
      ]);
}

DtHouseInfoStruct createDtHouseInfoStruct({
  int? id,
  String? nameLabel,
  String? propertyType,
  String? fullAddress,
  String? zipCode,
  String? city,
  double? areaSize,
  int? numBedrooms,
  int? numBathrooms,
  double? lat,
  double? lng,
}) =>
    DtHouseInfoStruct(
      id: id,
      nameLabel: nameLabel,
      propertyType: propertyType,
      fullAddress: fullAddress,
      zipCode: zipCode,
      city: city,
      areaSize: areaSize,
      numBedrooms: numBedrooms,
      numBathrooms: numBathrooms,
      lat: lat,
      lng: lng,
    );
