import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_userPrefs') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_userPrefs') ?? '{}';
          _userPrefs =
              DtUserPrefsStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      _isPro = await secureStorage.getBool('ff_isPro') ?? _isPro;
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_selectedHouse') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_selectedHouse') ?? '{}';
          _selectedHouse =
              DtHouseInfoStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      _FirstEntry = await secureStorage.getBool('ff_FirstEntry') ?? _FirstEntry;
    });
    await _safeInitAsync(() async {
      _countriesList = (await secureStorage.getStringList('ff_countriesList'))
              ?.map((x) {
                try {
                  return CountryStructStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _countriesList;
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_userProfile') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_userProfile') ?? '{}';
          _userProfile =
              UserProfileStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_currentCountry') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_currentCountry') ?? '{}';
          _currentCountry = CountryStructStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      _currentZoneId =
          await secureStorage.getInt('ff_currentZoneId') ?? _currentZoneId;
    });
    await _safeInitAsync(() async {
      _cart = (await secureStorage.getStringList('ff_cart'))
              ?.map((x) {
                try {
                  return BookingDraftStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _cart;
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_selectedAddress') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_selectedAddress') ?? '{}';
          _selectedAddress = AddressStructStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_activeBookingDraft') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_activeBookingDraft') ?? '{}';
          _activeBookingDraft = BookingDraftStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      _GeneralCarts = (await secureStorage.getStringList('ff_GeneralCarts'))
              ?.map((x) {
                try {
                  return BookingDraftStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _GeneralCarts;
    });
    await _safeInitAsync(() async {
      _currentSurgeMultiplier =
          await secureStorage.getDouble('ff_currentSurgeMultiplier') ??
              _currentSurgeMultiplier;
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_stripe') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_stripe') ?? '{}';
          _stripe =
              StripeStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_currentActiveOrder') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_currentActiveOrder') ?? '{}';
          _currentActiveOrder = ActiveOrderStateStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  /// Слой для "Поляка в Канаде".
  DtUserPrefsStruct _userPrefs = DtUserPrefsStruct.fromSerializableMap(jsonDecode(
      '{\"pref_currency_symbol\":\"\$\",\"exchange_rate\":\"1\",\"force_metric\":\"true\"}'));
  DtUserPrefsStruct get userPrefs => _userPrefs;
  set userPrefs(DtUserPrefsStruct value) {
    _userPrefs = value;
    secureStorage.setString('ff_userPrefs', value.serialize());
  }

  void deleteUserPrefs() {
    secureStorage.delete(key: 'ff_userPrefs');
  }

  void updateUserPrefsStruct(Function(DtUserPrefsStruct) updateFn) {
    updateFn(_userPrefs);
    secureStorage.setString('ff_userPrefs', _userPrefs.serialize());
  }

  /// (Cleany Pro Subscription).
  bool _isPro = false;
  bool get isPro => _isPro;
  set isPro(bool value) {
    _isPro = value;
    secureStorage.setBool('ff_isPro', value);
  }

  void deleteIsPro() {
    secureStorage.delete(key: 'ff_isPro');
  }

  /// информация о текущем выбранном доме
  DtHouseInfoStruct _selectedHouse =
      DtHouseInfoStruct.fromSerializableMap(jsonDecode('{}'));
  DtHouseInfoStruct get selectedHouse => _selectedHouse;
  set selectedHouse(DtHouseInfoStruct value) {
    _selectedHouse = value;
    secureStorage.setString('ff_selectedHouse', value.serialize());
  }

  void deleteSelectedHouse() {
    secureStorage.delete(key: 'ff_selectedHouse');
  }

  void updateSelectedHouseStruct(Function(DtHouseInfoStruct) updateFn) {
    updateFn(_selectedHouse);
    secureStorage.setString('ff_selectedHouse', _selectedHouse.serialize());
  }

  /// Рассчитанная цена выезда.
  double _currentTravelFee = 0.0;
  double get currentTravelFee => _currentTravelFee;
  set currentTravelFee(double value) {
    _currentTravelFee = value;
  }

  /// При запуске приложения нужно время, чтобы подтянуть данные из Supabase.
  ///
  /// Пока этот флаг false, мы показываем экран загрузки. Как только данные о
  /// стране и регионе в App State записаны — ставим true и открываем интерфейс.
  bool _isInitialised = false;
  bool get isInitialised => _isInitialised;
  set isInitialised(bool value) {
    _isInitialised = value;
  }

  AuthTypeStruct _activeAuth =
      AuthTypeStruct.fromSerializableMap(jsonDecode('{}'));
  AuthTypeStruct get activeAuth => _activeAuth;
  set activeAuth(AuthTypeStruct value) {
    _activeAuth = value;
  }

  void updateActiveAuthStruct(Function(AuthTypeStruct) updateFn) {
    updateFn(_activeAuth);
  }

  String _brandName = 'Helpero';
  String get brandName => _brandName;
  set brandName(String value) {
    _brandName = value;
  }

  double _sliderTest = 500.0;
  double get sliderTest => _sliderTest;
  set sliderTest(double value) {
    _sliderTest = value;
  }

  bool _FirstEntry = true;
  bool get FirstEntry => _FirstEntry;
  set FirstEntry(bool value) {
    _FirstEntry = value;
    secureStorage.setBool('ff_FirstEntry', value);
  }

  void deleteFirstEntry() {
    secureStorage.delete(key: 'ff_FirstEntry');
  }

  /// Список всех доступных стран (кэш из базы).
  ///
  /// Чтобы выбирать из списка.
  List<CountryStructStruct> _countriesList = [];
  List<CountryStructStruct> get countriesList => _countriesList;
  set countriesList(List<CountryStructStruct> value) {
    _countriesList = value;
    secureStorage.setStringList(
        'ff_countriesList', value.map((x) => x.serialize()).toList());
  }

  void deleteCountriesList() {
    secureStorage.delete(key: 'ff_countriesList');
  }

  void addToCountriesList(CountryStructStruct value) {
    countriesList.add(value);
    secureStorage.setStringList(
        'ff_countriesList', _countriesList.map((x) => x.serialize()).toList());
  }

  void removeFromCountriesList(CountryStructStruct value) {
    countriesList.remove(value);
    secureStorage.setStringList(
        'ff_countriesList', _countriesList.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromCountriesList(int index) {
    countriesList.removeAt(index);
    secureStorage.setStringList(
        'ff_countriesList', _countriesList.map((x) => x.serialize()).toList());
  }

  void updateCountriesListAtIndex(
    int index,
    CountryStructStruct Function(CountryStructStruct) updateFn,
  ) {
    countriesList[index] = updateFn(_countriesList[index]);
    secureStorage.setStringList(
        'ff_countriesList', _countriesList.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInCountriesList(int index, CountryStructStruct value) {
    countriesList.insert(index, value);
    secureStorage.setStringList(
        'ff_countriesList', _countriesList.map((x) => x.serialize()).toList());
  }

  /// Полный кэш профиля (чтобы не грузить каждый раз из базы).
  UserProfileStruct _userProfile = UserProfileStruct();
  UserProfileStruct get userProfile => _userProfile;
  set userProfile(UserProfileStruct value) {
    _userProfile = value;
    secureStorage.setString('ff_userProfile', value.serialize());
  }

  void deleteUserProfile() {
    secureStorage.delete(key: 'ff_userProfile');
  }

  void updateUserProfileStruct(Function(UserProfileStruct) updateFn) {
    updateFn(_userProfile);
    secureStorage.setString('ff_userProfile', _userProfile.serialize());
  }

  /// Флаги, налоги и коды всей страны.
  CountryStructStruct _currentCountry = CountryStructStruct.fromSerializableMap(
      jsonDecode(
          '{\"name\":\"Canada\",\"country_code\":\"CA\",\"country_flag\":\"🇨🇦\",\"phone_prefix\":\"+1\",\"tax_name\":\"HST\",\"is_metric\":\"true\",\"available_payment_methods\":\"[]\"}'));
  CountryStructStruct get currentCountry => _currentCountry;
  set currentCountry(CountryStructStruct value) {
    _currentCountry = value;
    secureStorage.setString('ff_currentCountry', value.serialize());
  }

  void deleteCurrentCountry() {
    secureStorage.delete(key: 'ff_currentCountry');
  }

  void updateCurrentCountryStruct(Function(CountryStructStruct) updateFn) {
    updateFn(_currentCountry);
    secureStorage.setString('ff_currentCountry', _currentCountry.serialize());
  }

  /// ID текущей зоны обслуживания (для фильтрации услуг).
  int _currentZoneId = 0;
  int get currentZoneId => _currentZoneId;
  set currentZoneId(int value) {
    _currentZoneId = value;
    secureStorage.setInt('ff_currentZoneId', value);
  }

  void deleteCurrentZoneId() {
    secureStorage.delete(key: 'ff_currentZoneId');
  }

  /// Корзина.
  ///
  /// Список черновиков заказов.
  List<BookingDraftStruct> _cart = [];
  List<BookingDraftStruct> get cart => _cart;
  set cart(List<BookingDraftStruct> value) {
    _cart = value;
    secureStorage.setStringList(
        'ff_cart', value.map((x) => x.serialize()).toList());
  }

  void deleteCart() {
    secureStorage.delete(key: 'ff_cart');
  }

  void addToCart(BookingDraftStruct value) {
    cart.add(value);
    secureStorage.setStringList(
        'ff_cart', _cart.map((x) => x.serialize()).toList());
  }

  void removeFromCart(BookingDraftStruct value) {
    cart.remove(value);
    secureStorage.setStringList(
        'ff_cart', _cart.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromCart(int index) {
    cart.removeAt(index);
    secureStorage.setStringList(
        'ff_cart', _cart.map((x) => x.serialize()).toList());
  }

  void updateCartAtIndex(
    int index,
    BookingDraftStruct Function(BookingDraftStruct) updateFn,
  ) {
    cart[index] = updateFn(_cart[index]);
    secureStorage.setStringList(
        'ff_cart', _cart.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInCart(int index, BookingDraftStruct value) {
    cart.insert(index, value);
    secureStorage.setStringList(
        'ff_cart', _cart.map((x) => x.serialize()).toList());
  }

  /// Текущий выбранный адрес доставки.
  AddressStructStruct _selectedAddress = AddressStructStruct();
  AddressStructStruct get selectedAddress => _selectedAddress;
  set selectedAddress(AddressStructStruct value) {
    _selectedAddress = value;
    secureStorage.setString('ff_selectedAddress', value.serialize());
  }

  void deleteSelectedAddress() {
    secureStorage.delete(key: 'ff_selectedAddress');
  }

  void updateSelectedAddressStruct(Function(AddressStructStruct) updateFn) {
    updateFn(_selectedAddress);
    secureStorage.setString('ff_selectedAddress', _selectedAddress.serialize());
  }

  /// Временный заказ, который мы сейчас собираем (до добавления в корзину).
  BookingDraftStruct _activeBookingDraft =
      BookingDraftStruct.fromSerializableMap(jsonDecode(
          '{\"selectedAddons\":\"[]\",\"visit\":\"{\\\"arrivalType\\\":\\\"standard\\\"}\"}'));
  BookingDraftStruct get activeBookingDraft => _activeBookingDraft;
  set activeBookingDraft(BookingDraftStruct value) {
    _activeBookingDraft = value;
    secureStorage.setString('ff_activeBookingDraft', value.serialize());
  }

  void deleteActiveBookingDraft() {
    secureStorage.delete(key: 'ff_activeBookingDraft');
  }

  void updateActiveBookingDraftStruct(Function(BookingDraftStruct) updateFn) {
    updateFn(_activeBookingDraft);
    secureStorage.setString(
        'ff_activeBookingDraft', _activeBookingDraft.serialize());
  }

  /// Текст поиска на главной.
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String value) {
    _searchQuery = value;
  }

  /// Для показа спиннеров загрузки.
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
  }

  ServicePackageStruct _activeService = ServicePackageStruct();
  ServicePackageStruct get activeService => _activeService;
  set activeService(ServicePackageStruct value) {
    _activeService = value;
  }

  void updateActiveServiceStruct(Function(ServicePackageStruct) updateFn) {
    updateFn(_activeService);
  }

  List<BookingDraftStruct> _GeneralCarts = [];
  List<BookingDraftStruct> get GeneralCarts => _GeneralCarts;
  set GeneralCarts(List<BookingDraftStruct> value) {
    _GeneralCarts = value;
    secureStorage.setStringList(
        'ff_GeneralCarts', value.map((x) => x.serialize()).toList());
  }

  void deleteGeneralCarts() {
    secureStorage.delete(key: 'ff_GeneralCarts');
  }

  void addToGeneralCarts(BookingDraftStruct value) {
    GeneralCarts.add(value);
    secureStorage.setStringList(
        'ff_GeneralCarts', _GeneralCarts.map((x) => x.serialize()).toList());
  }

  void removeFromGeneralCarts(BookingDraftStruct value) {
    GeneralCarts.remove(value);
    secureStorage.setStringList(
        'ff_GeneralCarts', _GeneralCarts.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromGeneralCarts(int index) {
    GeneralCarts.removeAt(index);
    secureStorage.setStringList(
        'ff_GeneralCarts', _GeneralCarts.map((x) => x.serialize()).toList());
  }

  void updateGeneralCartsAtIndex(
    int index,
    BookingDraftStruct Function(BookingDraftStruct) updateFn,
  ) {
    GeneralCarts[index] = updateFn(_GeneralCarts[index]);
    secureStorage.setStringList(
        'ff_GeneralCarts', _GeneralCarts.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInGeneralCarts(int index, BookingDraftStruct value) {
    GeneralCarts.insert(index, value);
    secureStorage.setStringList(
        'ff_GeneralCarts', _GeneralCarts.map((x) => x.serialize()).toList());
  }

  double _currentSurgeMultiplier = 1.0;
  double get currentSurgeMultiplier => _currentSurgeMultiplier;
  set currentSurgeMultiplier(double value) {
    _currentSurgeMultiplier = value;
    secureStorage.setDouble('ff_currentSurgeMultiplier', value);
  }

  void deleteCurrentSurgeMultiplier() {
    secureStorage.delete(key: 'ff_currentSurgeMultiplier');
  }

  StripeStruct _stripe = StripeStruct.fromSerializableMap(jsonDecode(
      '{\"stripeTestKey\":\"pk_test_51T6HrC1DL2rupsEklwq3CwaqeI5PsL0M3SK4sOtBp86ED21m0zh1yXDIktpjPTmV98HMrbqNoC54a5yba8ZbUd7H00Hi9aUJJe\"}'));
  StripeStruct get stripe => _stripe;
  set stripe(StripeStruct value) {
    _stripe = value;
    secureStorage.setString('ff_stripe', value.serialize());
  }

  void deleteStripe() {
    secureStorage.delete(key: 'ff_stripe');
  }

  void updateStripeStruct(Function(StripeStruct) updateFn) {
    updateFn(_stripe);
    secureStorage.setString('ff_stripe', _stripe.serialize());
  }

  ActiveOrderStateStruct _currentActiveOrder = ActiveOrderStateStruct();
  ActiveOrderStateStruct get currentActiveOrder => _currentActiveOrder;
  set currentActiveOrder(ActiveOrderStateStruct value) {
    _currentActiveOrder = value;
    secureStorage.setString('ff_currentActiveOrder', value.serialize());
  }

  void deleteCurrentActiveOrder() {
    secureStorage.delete(key: 'ff_currentActiveOrder');
  }

  void updateCurrentActiveOrderStruct(
      Function(ActiveOrderStateStruct) updateFn) {
    updateFn(_currentActiveOrder);
    secureStorage.setString(
        'ff_currentActiveOrder', _currentActiveOrder.serialize());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
