// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SelectedAddonStruct extends BaseStruct {
  SelectedAddonStruct({
    String? id,
    String? name,
    int? qty,

    /// Тут мы будем хранить "старую" цену конкретного аддона для сравнения.
    double? compareAtPrice,
    double? unitPrice,
    double? totalPrice,

    /// *Длительность одного айтема (мин)*
    int? unitDuration,

    /// *Суммарная длительность (qty × unitDuration)*
    int? totalDuration,
    String? displayStage,
  })  : _id = id,
        _name = name,
        _qty = qty,
        _compareAtPrice = compareAtPrice,
        _unitPrice = unitPrice,
        _totalPrice = totalPrice,
        _unitDuration = unitDuration,
        _totalDuration = totalDuration,
        _displayStage = displayStage;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "qty" field.
  int? _qty;
  int get qty => _qty ?? 0;
  set qty(int? val) => _qty = val;

  void incrementQty(int amount) => qty = qty + amount;

  bool hasQty() => _qty != null;

  // "compareAtPrice" field.
  double? _compareAtPrice;
  double get compareAtPrice => _compareAtPrice ?? 0.0;
  set compareAtPrice(double? val) => _compareAtPrice = val;

  void incrementCompareAtPrice(double amount) =>
      compareAtPrice = compareAtPrice + amount;

  bool hasCompareAtPrice() => _compareAtPrice != null;

  // "unitPrice" field.
  double? _unitPrice;
  double get unitPrice => _unitPrice ?? 0.0;
  set unitPrice(double? val) => _unitPrice = val;

  void incrementUnitPrice(double amount) => unitPrice = unitPrice + amount;

  bool hasUnitPrice() => _unitPrice != null;

  // "totalPrice" field.
  double? _totalPrice;
  double get totalPrice => _totalPrice ?? 0.0;
  set totalPrice(double? val) => _totalPrice = val;

  void incrementTotalPrice(double amount) => totalPrice = totalPrice + amount;

  bool hasTotalPrice() => _totalPrice != null;

  // "unitDuration" field.
  int? _unitDuration;
  int get unitDuration => _unitDuration ?? 0;
  set unitDuration(int? val) => _unitDuration = val;

  void incrementUnitDuration(int amount) =>
      unitDuration = unitDuration + amount;

  bool hasUnitDuration() => _unitDuration != null;

  // "totalDuration" field.
  int? _totalDuration;
  int get totalDuration => _totalDuration ?? 0;
  set totalDuration(int? val) => _totalDuration = val;

  void incrementTotalDuration(int amount) =>
      totalDuration = totalDuration + amount;

  bool hasTotalDuration() => _totalDuration != null;

  // "displayStage" field.
  String? _displayStage;
  String get displayStage => _displayStage ?? '';
  set displayStage(String? val) => _displayStage = val;

  bool hasDisplayStage() => _displayStage != null;

  static SelectedAddonStruct fromMap(Map<String, dynamic> data) =>
      SelectedAddonStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        qty: castToType<int>(data['qty']),
        compareAtPrice: castToType<double>(data['compareAtPrice']),
        unitPrice: castToType<double>(data['unitPrice']),
        totalPrice: castToType<double>(data['totalPrice']),
        unitDuration: castToType<int>(data['unitDuration']),
        totalDuration: castToType<int>(data['totalDuration']),
        displayStage: data['displayStage'] as String?,
      );

  static SelectedAddonStruct? maybeFromMap(dynamic data) => data is Map
      ? SelectedAddonStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'qty': _qty,
        'compareAtPrice': _compareAtPrice,
        'unitPrice': _unitPrice,
        'totalPrice': _totalPrice,
        'unitDuration': _unitDuration,
        'totalDuration': _totalDuration,
        'displayStage': _displayStage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'qty': serializeParam(
          _qty,
          ParamType.int,
        ),
        'compareAtPrice': serializeParam(
          _compareAtPrice,
          ParamType.double,
        ),
        'unitPrice': serializeParam(
          _unitPrice,
          ParamType.double,
        ),
        'totalPrice': serializeParam(
          _totalPrice,
          ParamType.double,
        ),
        'unitDuration': serializeParam(
          _unitDuration,
          ParamType.int,
        ),
        'totalDuration': serializeParam(
          _totalDuration,
          ParamType.int,
        ),
        'displayStage': serializeParam(
          _displayStage,
          ParamType.String,
        ),
      }.withoutNulls;

  static SelectedAddonStruct fromSerializableMap(Map<String, dynamic> data) =>
      SelectedAddonStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        qty: deserializeParam(
          data['qty'],
          ParamType.int,
          false,
        ),
        compareAtPrice: deserializeParam(
          data['compareAtPrice'],
          ParamType.double,
          false,
        ),
        unitPrice: deserializeParam(
          data['unitPrice'],
          ParamType.double,
          false,
        ),
        totalPrice: deserializeParam(
          data['totalPrice'],
          ParamType.double,
          false,
        ),
        unitDuration: deserializeParam(
          data['unitDuration'],
          ParamType.int,
          false,
        ),
        totalDuration: deserializeParam(
          data['totalDuration'],
          ParamType.int,
          false,
        ),
        displayStage: deserializeParam(
          data['displayStage'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SelectedAddonStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SelectedAddonStruct &&
        id == other.id &&
        name == other.name &&
        qty == other.qty &&
        compareAtPrice == other.compareAtPrice &&
        unitPrice == other.unitPrice &&
        totalPrice == other.totalPrice &&
        unitDuration == other.unitDuration &&
        totalDuration == other.totalDuration &&
        displayStage == other.displayStage;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        qty,
        compareAtPrice,
        unitPrice,
        totalPrice,
        unitDuration,
        totalDuration,
        displayStage
      ]);
}

SelectedAddonStruct createSelectedAddonStruct({
  String? id,
  String? name,
  int? qty,
  double? compareAtPrice,
  double? unitPrice,
  double? totalPrice,
  int? unitDuration,
  int? totalDuration,
  String? displayStage,
}) =>
    SelectedAddonStruct(
      id: id,
      name: name,
      qty: qty,
      compareAtPrice: compareAtPrice,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      unitDuration: unitDuration,
      totalDuration: totalDuration,
      displayStage: displayStage,
    );
