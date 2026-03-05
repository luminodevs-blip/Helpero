// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CategoryCartStruct extends BaseStruct {
  CategoryCartStruct({
    String? categoryId,
    String? categoryName,
    String? categoryImage,
    List<BookingDraftStruct>? services,
    double? totalPrice,
  })  : _categoryId = categoryId,
        _categoryName = categoryName,
        _categoryImage = categoryImage,
        _services = services,
        _totalPrice = totalPrice;

  // "categoryId" field.
  String? _categoryId;
  String get categoryId => _categoryId ?? '';
  set categoryId(String? val) => _categoryId = val;

  bool hasCategoryId() => _categoryId != null;

  // "categoryName" field.
  String? _categoryName;
  String get categoryName => _categoryName ?? '';
  set categoryName(String? val) => _categoryName = val;

  bool hasCategoryName() => _categoryName != null;

  // "categoryImage" field.
  String? _categoryImage;
  String get categoryImage => _categoryImage ?? '';
  set categoryImage(String? val) => _categoryImage = val;

  bool hasCategoryImage() => _categoryImage != null;

  // "services" field.
  List<BookingDraftStruct>? _services;
  List<BookingDraftStruct> get services => _services ?? const [];
  set services(List<BookingDraftStruct>? val) => _services = val;

  void updateServices(Function(List<BookingDraftStruct>) updateFn) {
    updateFn(_services ??= []);
  }

  bool hasServices() => _services != null;

  // "totalPrice" field.
  double? _totalPrice;
  double get totalPrice => _totalPrice ?? 0.0;
  set totalPrice(double? val) => _totalPrice = val;

  void incrementTotalPrice(double amount) => totalPrice = totalPrice + amount;

  bool hasTotalPrice() => _totalPrice != null;

  static CategoryCartStruct fromMap(Map<String, dynamic> data) =>
      CategoryCartStruct(
        categoryId: data['categoryId'] as String?,
        categoryName: data['categoryName'] as String?,
        categoryImage: data['categoryImage'] as String?,
        services: getStructList(
          data['services'],
          BookingDraftStruct.fromMap,
        ),
        totalPrice: castToType<double>(data['totalPrice']),
      );

  static CategoryCartStruct? maybeFromMap(dynamic data) => data is Map
      ? CategoryCartStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'categoryId': _categoryId,
        'categoryName': _categoryName,
        'categoryImage': _categoryImage,
        'services': _services?.map((e) => e.toMap()).toList(),
        'totalPrice': _totalPrice,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'categoryId': serializeParam(
          _categoryId,
          ParamType.String,
        ),
        'categoryName': serializeParam(
          _categoryName,
          ParamType.String,
        ),
        'categoryImage': serializeParam(
          _categoryImage,
          ParamType.String,
        ),
        'services': serializeParam(
          _services,
          ParamType.DataStruct,
          isList: true,
        ),
        'totalPrice': serializeParam(
          _totalPrice,
          ParamType.double,
        ),
      }.withoutNulls;

  static CategoryCartStruct fromSerializableMap(Map<String, dynamic> data) =>
      CategoryCartStruct(
        categoryId: deserializeParam(
          data['categoryId'],
          ParamType.String,
          false,
        ),
        categoryName: deserializeParam(
          data['categoryName'],
          ParamType.String,
          false,
        ),
        categoryImage: deserializeParam(
          data['categoryImage'],
          ParamType.String,
          false,
        ),
        services: deserializeStructParam<BookingDraftStruct>(
          data['services'],
          ParamType.DataStruct,
          true,
          structBuilder: BookingDraftStruct.fromSerializableMap,
        ),
        totalPrice: deserializeParam(
          data['totalPrice'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'CategoryCartStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CategoryCartStruct &&
        categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        categoryImage == other.categoryImage &&
        listEquality.equals(services, other.services) &&
        totalPrice == other.totalPrice;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([categoryId, categoryName, categoryImage, services, totalPrice]);
}

CategoryCartStruct createCategoryCartStruct({
  String? categoryId,
  String? categoryName,
  String? categoryImage,
  double? totalPrice,
}) =>
    CategoryCartStruct(
      categoryId: categoryId,
      categoryName: categoryName,
      categoryImage: categoryImage,
      totalPrice: totalPrice,
    );
