// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Дополнительная опция (например, "Inside Fridge" или "Hide Wires").
class ServiceAddonStruct extends BaseStruct {
  ServiceAddonStruct({
    /// UUID from DB
    String? id,
    String? name,
    double? price,
    double? oldPrice,

    /// "main" or "extra"
    String? category,
    String? displayStage,
    String? description,
    int? durationMinutes,
    List<String>? includedItems,
    List<String>? excludedItems,
    String? imageURL,
  })  : _id = id,
        _name = name,
        _price = price,
        _oldPrice = oldPrice,
        _category = category,
        _displayStage = displayStage,
        _description = description,
        _durationMinutes = durationMinutes,
        _includedItems = includedItems,
        _excludedItems = excludedItems,
        _imageURL = imageURL;

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

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "oldPrice" field.
  double? _oldPrice;
  double get oldPrice => _oldPrice ?? 0.0;
  set oldPrice(double? val) => _oldPrice = val;

  void incrementOldPrice(double amount) => oldPrice = oldPrice + amount;

  bool hasOldPrice() => _oldPrice != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;

  bool hasCategory() => _category != null;

  // "displayStage" field.
  String? _displayStage;
  String get displayStage => _displayStage ?? '';
  set displayStage(String? val) => _displayStage = val;

  bool hasDisplayStage() => _displayStage != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "durationMinutes" field.
  int? _durationMinutes;
  int get durationMinutes => _durationMinutes ?? 0;
  set durationMinutes(int? val) => _durationMinutes = val;

  void incrementDurationMinutes(int amount) =>
      durationMinutes = durationMinutes + amount;

  bool hasDurationMinutes() => _durationMinutes != null;

  // "includedItems" field.
  List<String>? _includedItems;
  List<String> get includedItems => _includedItems ?? const [];
  set includedItems(List<String>? val) => _includedItems = val;

  void updateIncludedItems(Function(List<String>) updateFn) {
    updateFn(_includedItems ??= []);
  }

  bool hasIncludedItems() => _includedItems != null;

  // "excludedItems" field.
  List<String>? _excludedItems;
  List<String> get excludedItems => _excludedItems ?? const [];
  set excludedItems(List<String>? val) => _excludedItems = val;

  void updateExcludedItems(Function(List<String>) updateFn) {
    updateFn(_excludedItems ??= []);
  }

  bool hasExcludedItems() => _excludedItems != null;

  // "imageURL" field.
  String? _imageURL;
  String get imageURL => _imageURL ?? '';
  set imageURL(String? val) => _imageURL = val;

  bool hasImageURL() => _imageURL != null;

  static ServiceAddonStruct fromMap(Map<String, dynamic> data) =>
      ServiceAddonStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        price: castToType<double>(data['price']),
        oldPrice: castToType<double>(data['oldPrice']),
        category: data['category'] as String?,
        displayStage: data['displayStage'] as String?,
        description: data['description'] as String?,
        durationMinutes: castToType<int>(data['durationMinutes']),
        includedItems: getDataList(data['includedItems']),
        excludedItems: getDataList(data['excludedItems']),
        imageURL: data['imageURL'] as String?,
      );

  static ServiceAddonStruct? maybeFromMap(dynamic data) => data is Map
      ? ServiceAddonStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'price': _price,
        'oldPrice': _oldPrice,
        'category': _category,
        'displayStage': _displayStage,
        'description': _description,
        'durationMinutes': _durationMinutes,
        'includedItems': _includedItems,
        'excludedItems': _excludedItems,
        'imageURL': _imageURL,
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
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'oldPrice': serializeParam(
          _oldPrice,
          ParamType.double,
        ),
        'category': serializeParam(
          _category,
          ParamType.String,
        ),
        'displayStage': serializeParam(
          _displayStage,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'durationMinutes': serializeParam(
          _durationMinutes,
          ParamType.int,
        ),
        'includedItems': serializeParam(
          _includedItems,
          ParamType.String,
          isList: true,
        ),
        'excludedItems': serializeParam(
          _excludedItems,
          ParamType.String,
          isList: true,
        ),
        'imageURL': serializeParam(
          _imageURL,
          ParamType.String,
        ),
      }.withoutNulls;

  static ServiceAddonStruct fromSerializableMap(Map<String, dynamic> data) =>
      ServiceAddonStruct(
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
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        oldPrice: deserializeParam(
          data['oldPrice'],
          ParamType.double,
          false,
        ),
        category: deserializeParam(
          data['category'],
          ParamType.String,
          false,
        ),
        displayStage: deserializeParam(
          data['displayStage'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        durationMinutes: deserializeParam(
          data['durationMinutes'],
          ParamType.int,
          false,
        ),
        includedItems: deserializeParam<String>(
          data['includedItems'],
          ParamType.String,
          true,
        ),
        excludedItems: deserializeParam<String>(
          data['excludedItems'],
          ParamType.String,
          true,
        ),
        imageURL: deserializeParam(
          data['imageURL'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ServiceAddonStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ServiceAddonStruct &&
        id == other.id &&
        name == other.name &&
        price == other.price &&
        oldPrice == other.oldPrice &&
        category == other.category &&
        displayStage == other.displayStage &&
        description == other.description &&
        durationMinutes == other.durationMinutes &&
        listEquality.equals(includedItems, other.includedItems) &&
        listEquality.equals(excludedItems, other.excludedItems) &&
        imageURL == other.imageURL;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        price,
        oldPrice,
        category,
        displayStage,
        description,
        durationMinutes,
        includedItems,
        excludedItems,
        imageURL
      ]);
}

ServiceAddonStruct createServiceAddonStruct({
  String? id,
  String? name,
  double? price,
  double? oldPrice,
  String? category,
  String? displayStage,
  String? description,
  int? durationMinutes,
  String? imageURL,
}) =>
    ServiceAddonStruct(
      id: id,
      name: name,
      price: price,
      oldPrice: oldPrice,
      category: category,
      displayStage: displayStage,
      description: description,
      durationMinutes: durationMinutes,
      imageURL: imageURL,
    );
