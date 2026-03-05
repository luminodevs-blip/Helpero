// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PromocodeStructStruct extends BaseStruct {
  PromocodeStructStruct({
    int? id,
    String? title,
    String? discountType,
    double? discountValue,
    double? maxDiscountLimit,
    double? minOrderSubtotal,
    bool? isStackable,
    String? targetAudience,
    List<int>? allowedCategories,
    String? color,
  })  : _id = id,
        _title = title,
        _discountType = discountType,
        _discountValue = discountValue,
        _maxDiscountLimit = maxDiscountLimit,
        _minOrderSubtotal = minOrderSubtotal,
        _isStackable = isStackable,
        _targetAudience = targetAudience,
        _allowedCategories = allowedCategories,
        _color = color;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "discount_type" field.
  String? _discountType;
  String get discountType => _discountType ?? '';
  set discountType(String? val) => _discountType = val;

  bool hasDiscountType() => _discountType != null;

  // "discount_value" field.
  double? _discountValue;
  double get discountValue => _discountValue ?? 0.0;
  set discountValue(double? val) => _discountValue = val;

  void incrementDiscountValue(double amount) =>
      discountValue = discountValue + amount;

  bool hasDiscountValue() => _discountValue != null;

  // "max_discount_limit" field.
  double? _maxDiscountLimit;
  double get maxDiscountLimit => _maxDiscountLimit ?? 0.0;
  set maxDiscountLimit(double? val) => _maxDiscountLimit = val;

  void incrementMaxDiscountLimit(double amount) =>
      maxDiscountLimit = maxDiscountLimit + amount;

  bool hasMaxDiscountLimit() => _maxDiscountLimit != null;

  // "min_order_subtotal" field.
  double? _minOrderSubtotal;
  double get minOrderSubtotal => _minOrderSubtotal ?? 0.0;
  set minOrderSubtotal(double? val) => _minOrderSubtotal = val;

  void incrementMinOrderSubtotal(double amount) =>
      minOrderSubtotal = minOrderSubtotal + amount;

  bool hasMinOrderSubtotal() => _minOrderSubtotal != null;

  // "is_stackable" field.
  bool? _isStackable;
  bool get isStackable => _isStackable ?? false;
  set isStackable(bool? val) => _isStackable = val;

  bool hasIsStackable() => _isStackable != null;

  // "target_audience" field.
  String? _targetAudience;
  String get targetAudience => _targetAudience ?? '';
  set targetAudience(String? val) => _targetAudience = val;

  bool hasTargetAudience() => _targetAudience != null;

  // "allowed_categories" field.
  List<int>? _allowedCategories;
  List<int> get allowedCategories => _allowedCategories ?? const [];
  set allowedCategories(List<int>? val) => _allowedCategories = val;

  void updateAllowedCategories(Function(List<int>) updateFn) {
    updateFn(_allowedCategories ??= []);
  }

  bool hasAllowedCategories() => _allowedCategories != null;

  // "Color" field.
  String? _color;
  String get color => _color ?? '';
  set color(String? val) => _color = val;

  bool hasColor() => _color != null;

  static PromocodeStructStruct fromMap(Map<String, dynamic> data) =>
      PromocodeStructStruct(
        id: castToType<int>(data['id']),
        title: data['title'] as String?,
        discountType: data['discount_type'] as String?,
        discountValue: castToType<double>(data['discount_value']),
        maxDiscountLimit: castToType<double>(data['max_discount_limit']),
        minOrderSubtotal: castToType<double>(data['min_order_subtotal']),
        isStackable: data['is_stackable'] as bool?,
        targetAudience: data['target_audience'] as String?,
        allowedCategories: getDataList(data['allowed_categories']),
        color: data['Color'] as String?,
      );

  static PromocodeStructStruct? maybeFromMap(dynamic data) => data is Map
      ? PromocodeStructStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'discount_type': _discountType,
        'discount_value': _discountValue,
        'max_discount_limit': _maxDiscountLimit,
        'min_order_subtotal': _minOrderSubtotal,
        'is_stackable': _isStackable,
        'target_audience': _targetAudience,
        'allowed_categories': _allowedCategories,
        'Color': _color,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'discount_type': serializeParam(
          _discountType,
          ParamType.String,
        ),
        'discount_value': serializeParam(
          _discountValue,
          ParamType.double,
        ),
        'max_discount_limit': serializeParam(
          _maxDiscountLimit,
          ParamType.double,
        ),
        'min_order_subtotal': serializeParam(
          _minOrderSubtotal,
          ParamType.double,
        ),
        'is_stackable': serializeParam(
          _isStackable,
          ParamType.bool,
        ),
        'target_audience': serializeParam(
          _targetAudience,
          ParamType.String,
        ),
        'allowed_categories': serializeParam(
          _allowedCategories,
          ParamType.int,
          isList: true,
        ),
        'Color': serializeParam(
          _color,
          ParamType.String,
        ),
      }.withoutNulls;

  static PromocodeStructStruct fromSerializableMap(Map<String, dynamic> data) =>
      PromocodeStructStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        discountType: deserializeParam(
          data['discount_type'],
          ParamType.String,
          false,
        ),
        discountValue: deserializeParam(
          data['discount_value'],
          ParamType.double,
          false,
        ),
        maxDiscountLimit: deserializeParam(
          data['max_discount_limit'],
          ParamType.double,
          false,
        ),
        minOrderSubtotal: deserializeParam(
          data['min_order_subtotal'],
          ParamType.double,
          false,
        ),
        isStackable: deserializeParam(
          data['is_stackable'],
          ParamType.bool,
          false,
        ),
        targetAudience: deserializeParam(
          data['target_audience'],
          ParamType.String,
          false,
        ),
        allowedCategories: deserializeParam<int>(
          data['allowed_categories'],
          ParamType.int,
          true,
        ),
        color: deserializeParam(
          data['Color'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PromocodeStructStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is PromocodeStructStruct &&
        id == other.id &&
        title == other.title &&
        discountType == other.discountType &&
        discountValue == other.discountValue &&
        maxDiscountLimit == other.maxDiscountLimit &&
        minOrderSubtotal == other.minOrderSubtotal &&
        isStackable == other.isStackable &&
        targetAudience == other.targetAudience &&
        listEquality.equals(allowedCategories, other.allowedCategories) &&
        color == other.color;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        title,
        discountType,
        discountValue,
        maxDiscountLimit,
        minOrderSubtotal,
        isStackable,
        targetAudience,
        allowedCategories,
        color
      ]);
}

PromocodeStructStruct createPromocodeStructStruct({
  int? id,
  String? title,
  String? discountType,
  double? discountValue,
  double? maxDiscountLimit,
  double? minOrderSubtotal,
  bool? isStackable,
  String? targetAudience,
  String? color,
}) =>
    PromocodeStructStruct(
      id: id,
      title: title,
      discountType: discountType,
      discountValue: discountValue,
      maxDiscountLimit: maxDiscountLimit,
      minOrderSubtotal: minOrderSubtotal,
      isStackable: isStackable,
      targetAudience: targetAudience,
      color: color,
    );
