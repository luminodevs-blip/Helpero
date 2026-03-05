// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Черновик заказа (то, что летит в корзину).
class BookingDraftStruct extends BaseStruct {
  BookingDraftStruct({
    ServiceCategoryStruct? categoryId,
    int? serviceId,
    String? serviceName,
    String? imageURL,
    double? basePrice,

    /// Это будет общая сумма экономии на весь заказ.
    double? totalSavings,

    ///  сумма аддонов
    double? itemsPrice,
    double? totalPrice,
    List<SelectedAddonStruct>? selectedAddons,
    AddressStructStruct? address,
    String? configBanner,

    /// *Базовая длительность основной услуги*
    int? durationMinutes,
    int? kitchenDurationMinutes,

    /// *Общая сумма (база + айтемы)*
    int? totalDuration,
    VisitDetailsStruct? visit,
    String? currentCartId,
    ServerCheckoutStruct? serverCheckout,
    String? selectedVoucherId,
  })  : _categoryId = categoryId,
        _serviceId = serviceId,
        _serviceName = serviceName,
        _imageURL = imageURL,
        _basePrice = basePrice,
        _totalSavings = totalSavings,
        _itemsPrice = itemsPrice,
        _totalPrice = totalPrice,
        _selectedAddons = selectedAddons,
        _address = address,
        _configBanner = configBanner,
        _durationMinutes = durationMinutes,
        _kitchenDurationMinutes = kitchenDurationMinutes,
        _totalDuration = totalDuration,
        _visit = visit,
        _currentCartId = currentCartId,
        _serverCheckout = serverCheckout,
        _selectedVoucherId = selectedVoucherId;

  // "categoryId" field.
  ServiceCategoryStruct? _categoryId;
  ServiceCategoryStruct get categoryId =>
      _categoryId ?? ServiceCategoryStruct();
  set categoryId(ServiceCategoryStruct? val) => _categoryId = val;

  void updateCategoryId(Function(ServiceCategoryStruct) updateFn) {
    updateFn(_categoryId ??= ServiceCategoryStruct());
  }

  bool hasCategoryId() => _categoryId != null;

  // "serviceId" field.
  int? _serviceId;
  int get serviceId => _serviceId ?? 0;
  set serviceId(int? val) => _serviceId = val;

  void incrementServiceId(int amount) => serviceId = serviceId + amount;

  bool hasServiceId() => _serviceId != null;

  // "serviceName" field.
  String? _serviceName;
  String get serviceName => _serviceName ?? '';
  set serviceName(String? val) => _serviceName = val;

  bool hasServiceName() => _serviceName != null;

  // "imageURL" field.
  String? _imageURL;
  String get imageURL => _imageURL ?? '';
  set imageURL(String? val) => _imageURL = val;

  bool hasImageURL() => _imageURL != null;

  // "basePrice" field.
  double? _basePrice;
  double get basePrice => _basePrice ?? 0.0;
  set basePrice(double? val) => _basePrice = val;

  void incrementBasePrice(double amount) => basePrice = basePrice + amount;

  bool hasBasePrice() => _basePrice != null;

  // "totalSavings" field.
  double? _totalSavings;
  double get totalSavings => _totalSavings ?? 0.0;
  set totalSavings(double? val) => _totalSavings = val;

  void incrementTotalSavings(double amount) =>
      totalSavings = totalSavings + amount;

  bool hasTotalSavings() => _totalSavings != null;

  // "itemsPrice" field.
  double? _itemsPrice;
  double get itemsPrice => _itemsPrice ?? 0.0;
  set itemsPrice(double? val) => _itemsPrice = val;

  void incrementItemsPrice(double amount) => itemsPrice = itemsPrice + amount;

  bool hasItemsPrice() => _itemsPrice != null;

  // "totalPrice" field.
  double? _totalPrice;
  double get totalPrice => _totalPrice ?? 0.0;
  set totalPrice(double? val) => _totalPrice = val;

  void incrementTotalPrice(double amount) => totalPrice = totalPrice + amount;

  bool hasTotalPrice() => _totalPrice != null;

  // "selectedAddons" field.
  List<SelectedAddonStruct>? _selectedAddons;
  List<SelectedAddonStruct> get selectedAddons => _selectedAddons ?? const [];
  set selectedAddons(List<SelectedAddonStruct>? val) => _selectedAddons = val;

  void updateSelectedAddons(Function(List<SelectedAddonStruct>) updateFn) {
    updateFn(_selectedAddons ??= []);
  }

  bool hasSelectedAddons() => _selectedAddons != null;

  // "address" field.
  AddressStructStruct? _address;
  AddressStructStruct get address => _address ?? AddressStructStruct();
  set address(AddressStructStruct? val) => _address = val;

  void updateAddress(Function(AddressStructStruct) updateFn) {
    updateFn(_address ??= AddressStructStruct());
  }

  bool hasAddress() => _address != null;

  // "config_banner" field.
  String? _configBanner;
  String get configBanner => _configBanner ?? '';
  set configBanner(String? val) => _configBanner = val;

  bool hasConfigBanner() => _configBanner != null;

  // "duration_minutes" field.
  int? _durationMinutes;
  int get durationMinutes => _durationMinutes ?? 0;
  set durationMinutes(int? val) => _durationMinutes = val;

  void incrementDurationMinutes(int amount) =>
      durationMinutes = durationMinutes + amount;

  bool hasDurationMinutes() => _durationMinutes != null;

  // "kitchenDurationMinutes" field.
  int? _kitchenDurationMinutes;
  int get kitchenDurationMinutes => _kitchenDurationMinutes ?? 0;
  set kitchenDurationMinutes(int? val) => _kitchenDurationMinutes = val;

  void incrementKitchenDurationMinutes(int amount) =>
      kitchenDurationMinutes = kitchenDurationMinutes + amount;

  bool hasKitchenDurationMinutes() => _kitchenDurationMinutes != null;

  // "totalDuration" field.
  int? _totalDuration;
  int get totalDuration => _totalDuration ?? 0;
  set totalDuration(int? val) => _totalDuration = val;

  void incrementTotalDuration(int amount) =>
      totalDuration = totalDuration + amount;

  bool hasTotalDuration() => _totalDuration != null;

  // "visit" field.
  VisitDetailsStruct? _visit;
  VisitDetailsStruct get visit => _visit ?? VisitDetailsStruct();
  set visit(VisitDetailsStruct? val) => _visit = val;

  void updateVisit(Function(VisitDetailsStruct) updateFn) {
    updateFn(_visit ??= VisitDetailsStruct());
  }

  bool hasVisit() => _visit != null;

  // "currentCartId" field.
  String? _currentCartId;
  String get currentCartId => _currentCartId ?? '';
  set currentCartId(String? val) => _currentCartId = val;

  bool hasCurrentCartId() => _currentCartId != null;

  // "serverCheckout" field.
  ServerCheckoutStruct? _serverCheckout;
  ServerCheckoutStruct get serverCheckout =>
      _serverCheckout ?? ServerCheckoutStruct();
  set serverCheckout(ServerCheckoutStruct? val) => _serverCheckout = val;

  void updateServerCheckout(Function(ServerCheckoutStruct) updateFn) {
    updateFn(_serverCheckout ??= ServerCheckoutStruct());
  }

  bool hasServerCheckout() => _serverCheckout != null;

  // "selectedVoucherId" field.
  String? _selectedVoucherId;
  String get selectedVoucherId => _selectedVoucherId ?? '';
  set selectedVoucherId(String? val) => _selectedVoucherId = val;

  bool hasSelectedVoucherId() => _selectedVoucherId != null;

  static BookingDraftStruct fromMap(Map<String, dynamic> data) =>
      BookingDraftStruct(
        categoryId: data['categoryId'] is ServiceCategoryStruct
            ? data['categoryId']
            : ServiceCategoryStruct.maybeFromMap(data['categoryId']),
        serviceId: castToType<int>(data['serviceId']),
        serviceName: data['serviceName'] as String?,
        imageURL: data['imageURL'] as String?,
        basePrice: castToType<double>(data['basePrice']),
        totalSavings: castToType<double>(data['totalSavings']),
        itemsPrice: castToType<double>(data['itemsPrice']),
        totalPrice: castToType<double>(data['totalPrice']),
        selectedAddons: getStructList(
          data['selectedAddons'],
          SelectedAddonStruct.fromMap,
        ),
        address: data['address'] is AddressStructStruct
            ? data['address']
            : AddressStructStruct.maybeFromMap(data['address']),
        configBanner: data['config_banner'] as String?,
        durationMinutes: castToType<int>(data['duration_minutes']),
        kitchenDurationMinutes: castToType<int>(data['kitchenDurationMinutes']),
        totalDuration: castToType<int>(data['totalDuration']),
        visit: data['visit'] is VisitDetailsStruct
            ? data['visit']
            : VisitDetailsStruct.maybeFromMap(data['visit']),
        currentCartId: data['currentCartId'] as String?,
        serverCheckout: data['serverCheckout'] is ServerCheckoutStruct
            ? data['serverCheckout']
            : ServerCheckoutStruct.maybeFromMap(data['serverCheckout']),
        selectedVoucherId: data['selectedVoucherId'] as String?,
      );

  static BookingDraftStruct? maybeFromMap(dynamic data) => data is Map
      ? BookingDraftStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'categoryId': _categoryId?.toMap(),
        'serviceId': _serviceId,
        'serviceName': _serviceName,
        'imageURL': _imageURL,
        'basePrice': _basePrice,
        'totalSavings': _totalSavings,
        'itemsPrice': _itemsPrice,
        'totalPrice': _totalPrice,
        'selectedAddons': _selectedAddons?.map((e) => e.toMap()).toList(),
        'address': _address?.toMap(),
        'config_banner': _configBanner,
        'duration_minutes': _durationMinutes,
        'kitchenDurationMinutes': _kitchenDurationMinutes,
        'totalDuration': _totalDuration,
        'visit': _visit?.toMap(),
        'currentCartId': _currentCartId,
        'serverCheckout': _serverCheckout?.toMap(),
        'selectedVoucherId': _selectedVoucherId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'categoryId': serializeParam(
          _categoryId,
          ParamType.DataStruct,
        ),
        'serviceId': serializeParam(
          _serviceId,
          ParamType.int,
        ),
        'serviceName': serializeParam(
          _serviceName,
          ParamType.String,
        ),
        'imageURL': serializeParam(
          _imageURL,
          ParamType.String,
        ),
        'basePrice': serializeParam(
          _basePrice,
          ParamType.double,
        ),
        'totalSavings': serializeParam(
          _totalSavings,
          ParamType.double,
        ),
        'itemsPrice': serializeParam(
          _itemsPrice,
          ParamType.double,
        ),
        'totalPrice': serializeParam(
          _totalPrice,
          ParamType.double,
        ),
        'selectedAddons': serializeParam(
          _selectedAddons,
          ParamType.DataStruct,
          isList: true,
        ),
        'address': serializeParam(
          _address,
          ParamType.DataStruct,
        ),
        'config_banner': serializeParam(
          _configBanner,
          ParamType.String,
        ),
        'duration_minutes': serializeParam(
          _durationMinutes,
          ParamType.int,
        ),
        'kitchenDurationMinutes': serializeParam(
          _kitchenDurationMinutes,
          ParamType.int,
        ),
        'totalDuration': serializeParam(
          _totalDuration,
          ParamType.int,
        ),
        'visit': serializeParam(
          _visit,
          ParamType.DataStruct,
        ),
        'currentCartId': serializeParam(
          _currentCartId,
          ParamType.String,
        ),
        'serverCheckout': serializeParam(
          _serverCheckout,
          ParamType.DataStruct,
        ),
        'selectedVoucherId': serializeParam(
          _selectedVoucherId,
          ParamType.String,
        ),
      }.withoutNulls;

  static BookingDraftStruct fromSerializableMap(Map<String, dynamic> data) =>
      BookingDraftStruct(
        categoryId: deserializeStructParam(
          data['categoryId'],
          ParamType.DataStruct,
          false,
          structBuilder: ServiceCategoryStruct.fromSerializableMap,
        ),
        serviceId: deserializeParam(
          data['serviceId'],
          ParamType.int,
          false,
        ),
        serviceName: deserializeParam(
          data['serviceName'],
          ParamType.String,
          false,
        ),
        imageURL: deserializeParam(
          data['imageURL'],
          ParamType.String,
          false,
        ),
        basePrice: deserializeParam(
          data['basePrice'],
          ParamType.double,
          false,
        ),
        totalSavings: deserializeParam(
          data['totalSavings'],
          ParamType.double,
          false,
        ),
        itemsPrice: deserializeParam(
          data['itemsPrice'],
          ParamType.double,
          false,
        ),
        totalPrice: deserializeParam(
          data['totalPrice'],
          ParamType.double,
          false,
        ),
        selectedAddons: deserializeStructParam<SelectedAddonStruct>(
          data['selectedAddons'],
          ParamType.DataStruct,
          true,
          structBuilder: SelectedAddonStruct.fromSerializableMap,
        ),
        address: deserializeStructParam(
          data['address'],
          ParamType.DataStruct,
          false,
          structBuilder: AddressStructStruct.fromSerializableMap,
        ),
        configBanner: deserializeParam(
          data['config_banner'],
          ParamType.String,
          false,
        ),
        durationMinutes: deserializeParam(
          data['duration_minutes'],
          ParamType.int,
          false,
        ),
        kitchenDurationMinutes: deserializeParam(
          data['kitchenDurationMinutes'],
          ParamType.int,
          false,
        ),
        totalDuration: deserializeParam(
          data['totalDuration'],
          ParamType.int,
          false,
        ),
        visit: deserializeStructParam(
          data['visit'],
          ParamType.DataStruct,
          false,
          structBuilder: VisitDetailsStruct.fromSerializableMap,
        ),
        currentCartId: deserializeParam(
          data['currentCartId'],
          ParamType.String,
          false,
        ),
        serverCheckout: deserializeStructParam(
          data['serverCheckout'],
          ParamType.DataStruct,
          false,
          structBuilder: ServerCheckoutStruct.fromSerializableMap,
        ),
        selectedVoucherId: deserializeParam(
          data['selectedVoucherId'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'BookingDraftStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is BookingDraftStruct &&
        categoryId == other.categoryId &&
        serviceId == other.serviceId &&
        serviceName == other.serviceName &&
        imageURL == other.imageURL &&
        basePrice == other.basePrice &&
        totalSavings == other.totalSavings &&
        itemsPrice == other.itemsPrice &&
        totalPrice == other.totalPrice &&
        listEquality.equals(selectedAddons, other.selectedAddons) &&
        address == other.address &&
        configBanner == other.configBanner &&
        durationMinutes == other.durationMinutes &&
        kitchenDurationMinutes == other.kitchenDurationMinutes &&
        totalDuration == other.totalDuration &&
        visit == other.visit &&
        currentCartId == other.currentCartId &&
        serverCheckout == other.serverCheckout &&
        selectedVoucherId == other.selectedVoucherId;
  }

  @override
  int get hashCode => const ListEquality().hash([
        categoryId,
        serviceId,
        serviceName,
        imageURL,
        basePrice,
        totalSavings,
        itemsPrice,
        totalPrice,
        selectedAddons,
        address,
        configBanner,
        durationMinutes,
        kitchenDurationMinutes,
        totalDuration,
        visit,
        currentCartId,
        serverCheckout,
        selectedVoucherId
      ]);
}

BookingDraftStruct createBookingDraftStruct({
  ServiceCategoryStruct? categoryId,
  int? serviceId,
  String? serviceName,
  String? imageURL,
  double? basePrice,
  double? totalSavings,
  double? itemsPrice,
  double? totalPrice,
  AddressStructStruct? address,
  String? configBanner,
  int? durationMinutes,
  int? kitchenDurationMinutes,
  int? totalDuration,
  VisitDetailsStruct? visit,
  String? currentCartId,
  ServerCheckoutStruct? serverCheckout,
  String? selectedVoucherId,
}) =>
    BookingDraftStruct(
      categoryId: categoryId ?? ServiceCategoryStruct(),
      serviceId: serviceId,
      serviceName: serviceName,
      imageURL: imageURL,
      basePrice: basePrice,
      totalSavings: totalSavings,
      itemsPrice: itemsPrice,
      totalPrice: totalPrice,
      address: address ?? AddressStructStruct(),
      configBanner: configBanner,
      durationMinutes: durationMinutes,
      kitchenDurationMinutes: kitchenDurationMinutes,
      totalDuration: totalDuration,
      visit: visit ?? VisitDetailsStruct(),
      currentCartId: currentCartId,
      serverCheckout: serverCheckout ?? ServerCheckoutStruct(),
      selectedVoucherId: selectedVoucherId,
    );
