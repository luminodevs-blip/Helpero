// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ServicePackageStruct extends BaseStruct {
  ServicePackageStruct({
    int? id,
    String? name,

    /// Превью услуги в списке
    String? imageUrl,

    /// shortDescription
    String? shortDescription,
    List<String>? cardBullets,

    /// "package" or "mini"
    String? groupType,
    double? basePrice,

    /// "home_size" or "itemized"
    String? flowType,
    double? rating,
    int? reviewsCount,
    List<IncludedItemStructStruct>? includedItems,
    List<String>? excludedItems,
    String? includeNote,
    List<RequirementStructStruct>? requirements,
    List<String>? beforeAfterImages,
    int? categoryId,

    /// Список ID зон, где услуга доступна.
    ///
    /// Если пусто/null — доступна везде.
    List<int>? allowedZoneIds,
    int? durationMinutes,
    String? configBanner,
    String? configHeader1,
    String? configHeader2,
  })  : _id = id,
        _name = name,
        _imageUrl = imageUrl,
        _shortDescription = shortDescription,
        _cardBullets = cardBullets,
        _groupType = groupType,
        _basePrice = basePrice,
        _flowType = flowType,
        _rating = rating,
        _reviewsCount = reviewsCount,
        _includedItems = includedItems,
        _excludedItems = excludedItems,
        _includeNote = includeNote,
        _requirements = requirements,
        _beforeAfterImages = beforeAfterImages,
        _categoryId = categoryId,
        _allowedZoneIds = allowedZoneIds,
        _durationMinutes = durationMinutes,
        _configBanner = configBanner,
        _configHeader1 = configHeader1,
        _configHeader2 = configHeader2;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "shortDescription" field.
  String? _shortDescription;
  String get shortDescription => _shortDescription ?? '';
  set shortDescription(String? val) => _shortDescription = val;

  bool hasShortDescription() => _shortDescription != null;

  // "cardBullets" field.
  List<String>? _cardBullets;
  List<String> get cardBullets => _cardBullets ?? const [];
  set cardBullets(List<String>? val) => _cardBullets = val;

  void updateCardBullets(Function(List<String>) updateFn) {
    updateFn(_cardBullets ??= []);
  }

  bool hasCardBullets() => _cardBullets != null;

  // "groupType" field.
  String? _groupType;
  String get groupType => _groupType ?? '';
  set groupType(String? val) => _groupType = val;

  bool hasGroupType() => _groupType != null;

  // "basePrice" field.
  double? _basePrice;
  double get basePrice => _basePrice ?? 0.0;
  set basePrice(double? val) => _basePrice = val;

  void incrementBasePrice(double amount) => basePrice = basePrice + amount;

  bool hasBasePrice() => _basePrice != null;

  // "flowType" field.
  String? _flowType;
  String get flowType => _flowType ?? '';
  set flowType(String? val) => _flowType = val;

  bool hasFlowType() => _flowType != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  set rating(double? val) => _rating = val;

  void incrementRating(double amount) => rating = rating + amount;

  bool hasRating() => _rating != null;

  // "reviewsCount" field.
  int? _reviewsCount;
  int get reviewsCount => _reviewsCount ?? 0;
  set reviewsCount(int? val) => _reviewsCount = val;

  void incrementReviewsCount(int amount) =>
      reviewsCount = reviewsCount + amount;

  bool hasReviewsCount() => _reviewsCount != null;

  // "includedItems" field.
  List<IncludedItemStructStruct>? _includedItems;
  List<IncludedItemStructStruct> get includedItems =>
      _includedItems ?? const [];
  set includedItems(List<IncludedItemStructStruct>? val) =>
      _includedItems = val;

  void updateIncludedItems(Function(List<IncludedItemStructStruct>) updateFn) {
    updateFn(_includedItems ??= []);
  }

  bool hasIncludedItems() => _includedItems != null;

  // "excluded_items" field.
  List<String>? _excludedItems;
  List<String> get excludedItems => _excludedItems ?? const [];
  set excludedItems(List<String>? val) => _excludedItems = val;

  void updateExcludedItems(Function(List<String>) updateFn) {
    updateFn(_excludedItems ??= []);
  }

  bool hasExcludedItems() => _excludedItems != null;

  // "includeNote" field.
  String? _includeNote;
  String get includeNote => _includeNote ?? '';
  set includeNote(String? val) => _includeNote = val;

  bool hasIncludeNote() => _includeNote != null;

  // "requirements" field.
  List<RequirementStructStruct>? _requirements;
  List<RequirementStructStruct> get requirements => _requirements ?? const [];
  set requirements(List<RequirementStructStruct>? val) => _requirements = val;

  void updateRequirements(Function(List<RequirementStructStruct>) updateFn) {
    updateFn(_requirements ??= []);
  }

  bool hasRequirements() => _requirements != null;

  // "beforeAfterImages" field.
  List<String>? _beforeAfterImages;
  List<String> get beforeAfterImages => _beforeAfterImages ?? const [];
  set beforeAfterImages(List<String>? val) => _beforeAfterImages = val;

  void updateBeforeAfterImages(Function(List<String>) updateFn) {
    updateFn(_beforeAfterImages ??= []);
  }

  bool hasBeforeAfterImages() => _beforeAfterImages != null;

  // "categoryId" field.
  int? _categoryId;
  int get categoryId => _categoryId ?? 0;
  set categoryId(int? val) => _categoryId = val;

  void incrementCategoryId(int amount) => categoryId = categoryId + amount;

  bool hasCategoryId() => _categoryId != null;

  // "allowedZoneIds" field.
  List<int>? _allowedZoneIds;
  List<int> get allowedZoneIds => _allowedZoneIds ?? const [];
  set allowedZoneIds(List<int>? val) => _allowedZoneIds = val;

  void updateAllowedZoneIds(Function(List<int>) updateFn) {
    updateFn(_allowedZoneIds ??= []);
  }

  bool hasAllowedZoneIds() => _allowedZoneIds != null;

  // "duration_minutes" field.
  int? _durationMinutes;
  int get durationMinutes => _durationMinutes ?? 0;
  set durationMinutes(int? val) => _durationMinutes = val;

  void incrementDurationMinutes(int amount) =>
      durationMinutes = durationMinutes + amount;

  bool hasDurationMinutes() => _durationMinutes != null;

  // "configBanner" field.
  String? _configBanner;
  String get configBanner => _configBanner ?? '';
  set configBanner(String? val) => _configBanner = val;

  bool hasConfigBanner() => _configBanner != null;

  // "configHeader1" field.
  String? _configHeader1;
  String get configHeader1 => _configHeader1 ?? '';
  set configHeader1(String? val) => _configHeader1 = val;

  bool hasConfigHeader1() => _configHeader1 != null;

  // "configHeader2" field.
  String? _configHeader2;
  String get configHeader2 => _configHeader2 ?? '';
  set configHeader2(String? val) => _configHeader2 = val;

  bool hasConfigHeader2() => _configHeader2 != null;

  static ServicePackageStruct fromMap(Map<String, dynamic> data) =>
      ServicePackageStruct(
        id: castToType<int>(data['id']),
        name: data['name'] as String?,
        imageUrl: data['imageUrl'] as String?,
        shortDescription: data['shortDescription'] as String?,
        cardBullets: getDataList(data['cardBullets']),
        groupType: data['groupType'] as String?,
        basePrice: castToType<double>(data['basePrice']),
        flowType: data['flowType'] as String?,
        rating: castToType<double>(data['rating']),
        reviewsCount: castToType<int>(data['reviewsCount']),
        includedItems: getStructList(
          data['includedItems'],
          IncludedItemStructStruct.fromMap,
        ),
        excludedItems: getDataList(data['excluded_items']),
        includeNote: data['includeNote'] as String?,
        requirements: getStructList(
          data['requirements'],
          RequirementStructStruct.fromMap,
        ),
        beforeAfterImages: getDataList(data['beforeAfterImages']),
        categoryId: castToType<int>(data['categoryId']),
        allowedZoneIds: getDataList(data['allowedZoneIds']),
        durationMinutes: castToType<int>(data['duration_minutes']),
        configBanner: data['configBanner'] as String?,
        configHeader1: data['configHeader1'] as String?,
        configHeader2: data['configHeader2'] as String?,
      );

  static ServicePackageStruct? maybeFromMap(dynamic data) => data is Map
      ? ServicePackageStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'imageUrl': _imageUrl,
        'shortDescription': _shortDescription,
        'cardBullets': _cardBullets,
        'groupType': _groupType,
        'basePrice': _basePrice,
        'flowType': _flowType,
        'rating': _rating,
        'reviewsCount': _reviewsCount,
        'includedItems': _includedItems?.map((e) => e.toMap()).toList(),
        'excluded_items': _excludedItems,
        'includeNote': _includeNote,
        'requirements': _requirements?.map((e) => e.toMap()).toList(),
        'beforeAfterImages': _beforeAfterImages,
        'categoryId': _categoryId,
        'allowedZoneIds': _allowedZoneIds,
        'duration_minutes': _durationMinutes,
        'configBanner': _configBanner,
        'configHeader1': _configHeader1,
        'configHeader2': _configHeader2,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'imageUrl': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'shortDescription': serializeParam(
          _shortDescription,
          ParamType.String,
        ),
        'cardBullets': serializeParam(
          _cardBullets,
          ParamType.String,
          isList: true,
        ),
        'groupType': serializeParam(
          _groupType,
          ParamType.String,
        ),
        'basePrice': serializeParam(
          _basePrice,
          ParamType.double,
        ),
        'flowType': serializeParam(
          _flowType,
          ParamType.String,
        ),
        'rating': serializeParam(
          _rating,
          ParamType.double,
        ),
        'reviewsCount': serializeParam(
          _reviewsCount,
          ParamType.int,
        ),
        'includedItems': serializeParam(
          _includedItems,
          ParamType.DataStruct,
          isList: true,
        ),
        'excluded_items': serializeParam(
          _excludedItems,
          ParamType.String,
          isList: true,
        ),
        'includeNote': serializeParam(
          _includeNote,
          ParamType.String,
        ),
        'requirements': serializeParam(
          _requirements,
          ParamType.DataStruct,
          isList: true,
        ),
        'beforeAfterImages': serializeParam(
          _beforeAfterImages,
          ParamType.String,
          isList: true,
        ),
        'categoryId': serializeParam(
          _categoryId,
          ParamType.int,
        ),
        'allowedZoneIds': serializeParam(
          _allowedZoneIds,
          ParamType.int,
          isList: true,
        ),
        'duration_minutes': serializeParam(
          _durationMinutes,
          ParamType.int,
        ),
        'configBanner': serializeParam(
          _configBanner,
          ParamType.String,
        ),
        'configHeader1': serializeParam(
          _configHeader1,
          ParamType.String,
        ),
        'configHeader2': serializeParam(
          _configHeader2,
          ParamType.String,
        ),
      }.withoutNulls;

  static ServicePackageStruct fromSerializableMap(Map<String, dynamic> data) =>
      ServicePackageStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['imageUrl'],
          ParamType.String,
          false,
        ),
        shortDescription: deserializeParam(
          data['shortDescription'],
          ParamType.String,
          false,
        ),
        cardBullets: deserializeParam<String>(
          data['cardBullets'],
          ParamType.String,
          true,
        ),
        groupType: deserializeParam(
          data['groupType'],
          ParamType.String,
          false,
        ),
        basePrice: deserializeParam(
          data['basePrice'],
          ParamType.double,
          false,
        ),
        flowType: deserializeParam(
          data['flowType'],
          ParamType.String,
          false,
        ),
        rating: deserializeParam(
          data['rating'],
          ParamType.double,
          false,
        ),
        reviewsCount: deserializeParam(
          data['reviewsCount'],
          ParamType.int,
          false,
        ),
        includedItems: deserializeStructParam<IncludedItemStructStruct>(
          data['includedItems'],
          ParamType.DataStruct,
          true,
          structBuilder: IncludedItemStructStruct.fromSerializableMap,
        ),
        excludedItems: deserializeParam<String>(
          data['excluded_items'],
          ParamType.String,
          true,
        ),
        includeNote: deserializeParam(
          data['includeNote'],
          ParamType.String,
          false,
        ),
        requirements: deserializeStructParam<RequirementStructStruct>(
          data['requirements'],
          ParamType.DataStruct,
          true,
          structBuilder: RequirementStructStruct.fromSerializableMap,
        ),
        beforeAfterImages: deserializeParam<String>(
          data['beforeAfterImages'],
          ParamType.String,
          true,
        ),
        categoryId: deserializeParam(
          data['categoryId'],
          ParamType.int,
          false,
        ),
        allowedZoneIds: deserializeParam<int>(
          data['allowedZoneIds'],
          ParamType.int,
          true,
        ),
        durationMinutes: deserializeParam(
          data['duration_minutes'],
          ParamType.int,
          false,
        ),
        configBanner: deserializeParam(
          data['configBanner'],
          ParamType.String,
          false,
        ),
        configHeader1: deserializeParam(
          data['configHeader1'],
          ParamType.String,
          false,
        ),
        configHeader2: deserializeParam(
          data['configHeader2'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ServicePackageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ServicePackageStruct &&
        id == other.id &&
        name == other.name &&
        imageUrl == other.imageUrl &&
        shortDescription == other.shortDescription &&
        listEquality.equals(cardBullets, other.cardBullets) &&
        groupType == other.groupType &&
        basePrice == other.basePrice &&
        flowType == other.flowType &&
        rating == other.rating &&
        reviewsCount == other.reviewsCount &&
        listEquality.equals(includedItems, other.includedItems) &&
        listEquality.equals(excludedItems, other.excludedItems) &&
        includeNote == other.includeNote &&
        listEquality.equals(requirements, other.requirements) &&
        listEquality.equals(beforeAfterImages, other.beforeAfterImages) &&
        categoryId == other.categoryId &&
        listEquality.equals(allowedZoneIds, other.allowedZoneIds) &&
        durationMinutes == other.durationMinutes &&
        configBanner == other.configBanner &&
        configHeader1 == other.configHeader1 &&
        configHeader2 == other.configHeader2;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        imageUrl,
        shortDescription,
        cardBullets,
        groupType,
        basePrice,
        flowType,
        rating,
        reviewsCount,
        includedItems,
        excludedItems,
        includeNote,
        requirements,
        beforeAfterImages,
        categoryId,
        allowedZoneIds,
        durationMinutes,
        configBanner,
        configHeader1,
        configHeader2
      ]);
}

ServicePackageStruct createServicePackageStruct({
  int? id,
  String? name,
  String? imageUrl,
  String? shortDescription,
  String? groupType,
  double? basePrice,
  String? flowType,
  double? rating,
  int? reviewsCount,
  String? includeNote,
  int? categoryId,
  int? durationMinutes,
  String? configBanner,
  String? configHeader1,
  String? configHeader2,
}) =>
    ServicePackageStruct(
      id: id,
      name: name,
      imageUrl: imageUrl,
      shortDescription: shortDescription,
      groupType: groupType,
      basePrice: basePrice,
      flowType: flowType,
      rating: rating,
      reviewsCount: reviewsCount,
      includeNote: includeNote,
      categoryId: categoryId,
      durationMinutes: durationMinutes,
      configBanner: configBanner,
      configHeader1: configHeader1,
      configHeader2: configHeader2,
    );
