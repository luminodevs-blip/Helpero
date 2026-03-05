// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CountryStructStruct extends BaseStruct {
  CountryStructStruct({
    /// ID из Supabase.
    int? id,

    /// United Kingdom, USA.
    String? name,

    /// US, PL
    String? countryCode,
    String? countryFlag,
    String? currencySymbol,

    /// Sales Tax, VAT
    String? taxName,

    /// True (включен в цену), False (сверху)
    bool? taxIsInclusive,
    double? bookingFee,
    double? taxRate,
    double? minOrderAmount,

    /// +44, +1.
    String? phonePrefix,

    /// True (метры) / False (футы).
    bool? isMetric,
    List<int>? availablePaymentMethods,
  })  : _id = id,
        _name = name,
        _countryCode = countryCode,
        _countryFlag = countryFlag,
        _currencySymbol = currencySymbol,
        _taxName = taxName,
        _taxIsInclusive = taxIsInclusive,
        _bookingFee = bookingFee,
        _taxRate = taxRate,
        _minOrderAmount = minOrderAmount,
        _phonePrefix = phonePrefix,
        _isMetric = isMetric,
        _availablePaymentMethods = availablePaymentMethods;

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

  // "country_code" field.
  String? _countryCode;
  String get countryCode => _countryCode ?? '';
  set countryCode(String? val) => _countryCode = val;

  bool hasCountryCode() => _countryCode != null;

  // "country_flag" field.
  String? _countryFlag;
  String get countryFlag => _countryFlag ?? '';
  set countryFlag(String? val) => _countryFlag = val;

  bool hasCountryFlag() => _countryFlag != null;

  // "currency_symbol" field.
  String? _currencySymbol;
  String get currencySymbol => _currencySymbol ?? '';
  set currencySymbol(String? val) => _currencySymbol = val;

  bool hasCurrencySymbol() => _currencySymbol != null;

  // "tax_name" field.
  String? _taxName;
  String get taxName => _taxName ?? '';
  set taxName(String? val) => _taxName = val;

  bool hasTaxName() => _taxName != null;

  // "tax_is_inclusive" field.
  bool? _taxIsInclusive;
  bool get taxIsInclusive => _taxIsInclusive ?? false;
  set taxIsInclusive(bool? val) => _taxIsInclusive = val;

  bool hasTaxIsInclusive() => _taxIsInclusive != null;

  // "booking_fee" field.
  double? _bookingFee;
  double get bookingFee => _bookingFee ?? 0.0;
  set bookingFee(double? val) => _bookingFee = val;

  void incrementBookingFee(double amount) => bookingFee = bookingFee + amount;

  bool hasBookingFee() => _bookingFee != null;

  // "tax_rate" field.
  double? _taxRate;
  double get taxRate => _taxRate ?? 0.0;
  set taxRate(double? val) => _taxRate = val;

  void incrementTaxRate(double amount) => taxRate = taxRate + amount;

  bool hasTaxRate() => _taxRate != null;

  // "min_order_amount" field.
  double? _minOrderAmount;
  double get minOrderAmount => _minOrderAmount ?? 0.0;
  set minOrderAmount(double? val) => _minOrderAmount = val;

  void incrementMinOrderAmount(double amount) =>
      minOrderAmount = minOrderAmount + amount;

  bool hasMinOrderAmount() => _minOrderAmount != null;

  // "phone_prefix" field.
  String? _phonePrefix;
  String get phonePrefix => _phonePrefix ?? '';
  set phonePrefix(String? val) => _phonePrefix = val;

  bool hasPhonePrefix() => _phonePrefix != null;

  // "is_metric" field.
  bool? _isMetric;
  bool get isMetric => _isMetric ?? false;
  set isMetric(bool? val) => _isMetric = val;

  bool hasIsMetric() => _isMetric != null;

  // "available_payment_methods" field.
  List<int>? _availablePaymentMethods;
  List<int> get availablePaymentMethods => _availablePaymentMethods ?? const [];
  set availablePaymentMethods(List<int>? val) => _availablePaymentMethods = val;

  void updateAvailablePaymentMethods(Function(List<int>) updateFn) {
    updateFn(_availablePaymentMethods ??= []);
  }

  bool hasAvailablePaymentMethods() => _availablePaymentMethods != null;

  static CountryStructStruct fromMap(Map<String, dynamic> data) =>
      CountryStructStruct(
        id: castToType<int>(data['id']),
        name: data['name'] as String?,
        countryCode: data['country_code'] as String?,
        countryFlag: data['country_flag'] as String?,
        currencySymbol: data['currency_symbol'] as String?,
        taxName: data['tax_name'] as String?,
        taxIsInclusive: data['tax_is_inclusive'] as bool?,
        bookingFee: castToType<double>(data['booking_fee']),
        taxRate: castToType<double>(data['tax_rate']),
        minOrderAmount: castToType<double>(data['min_order_amount']),
        phonePrefix: data['phone_prefix'] as String?,
        isMetric: data['is_metric'] as bool?,
        availablePaymentMethods: getDataList(data['available_payment_methods']),
      );

  static CountryStructStruct? maybeFromMap(dynamic data) => data is Map
      ? CountryStructStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'country_code': _countryCode,
        'country_flag': _countryFlag,
        'currency_symbol': _currencySymbol,
        'tax_name': _taxName,
        'tax_is_inclusive': _taxIsInclusive,
        'booking_fee': _bookingFee,
        'tax_rate': _taxRate,
        'min_order_amount': _minOrderAmount,
        'phone_prefix': _phonePrefix,
        'is_metric': _isMetric,
        'available_payment_methods': _availablePaymentMethods,
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
        'country_code': serializeParam(
          _countryCode,
          ParamType.String,
        ),
        'country_flag': serializeParam(
          _countryFlag,
          ParamType.String,
        ),
        'currency_symbol': serializeParam(
          _currencySymbol,
          ParamType.String,
        ),
        'tax_name': serializeParam(
          _taxName,
          ParamType.String,
        ),
        'tax_is_inclusive': serializeParam(
          _taxIsInclusive,
          ParamType.bool,
        ),
        'booking_fee': serializeParam(
          _bookingFee,
          ParamType.double,
        ),
        'tax_rate': serializeParam(
          _taxRate,
          ParamType.double,
        ),
        'min_order_amount': serializeParam(
          _minOrderAmount,
          ParamType.double,
        ),
        'phone_prefix': serializeParam(
          _phonePrefix,
          ParamType.String,
        ),
        'is_metric': serializeParam(
          _isMetric,
          ParamType.bool,
        ),
        'available_payment_methods': serializeParam(
          _availablePaymentMethods,
          ParamType.int,
          isList: true,
        ),
      }.withoutNulls;

  static CountryStructStruct fromSerializableMap(Map<String, dynamic> data) =>
      CountryStructStruct(
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
        countryCode: deserializeParam(
          data['country_code'],
          ParamType.String,
          false,
        ),
        countryFlag: deserializeParam(
          data['country_flag'],
          ParamType.String,
          false,
        ),
        currencySymbol: deserializeParam(
          data['currency_symbol'],
          ParamType.String,
          false,
        ),
        taxName: deserializeParam(
          data['tax_name'],
          ParamType.String,
          false,
        ),
        taxIsInclusive: deserializeParam(
          data['tax_is_inclusive'],
          ParamType.bool,
          false,
        ),
        bookingFee: deserializeParam(
          data['booking_fee'],
          ParamType.double,
          false,
        ),
        taxRate: deserializeParam(
          data['tax_rate'],
          ParamType.double,
          false,
        ),
        minOrderAmount: deserializeParam(
          data['min_order_amount'],
          ParamType.double,
          false,
        ),
        phonePrefix: deserializeParam(
          data['phone_prefix'],
          ParamType.String,
          false,
        ),
        isMetric: deserializeParam(
          data['is_metric'],
          ParamType.bool,
          false,
        ),
        availablePaymentMethods: deserializeParam<int>(
          data['available_payment_methods'],
          ParamType.int,
          true,
        ),
      );

  @override
  String toString() => 'CountryStructStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CountryStructStruct &&
        id == other.id &&
        name == other.name &&
        countryCode == other.countryCode &&
        countryFlag == other.countryFlag &&
        currencySymbol == other.currencySymbol &&
        taxName == other.taxName &&
        taxIsInclusive == other.taxIsInclusive &&
        bookingFee == other.bookingFee &&
        taxRate == other.taxRate &&
        minOrderAmount == other.minOrderAmount &&
        phonePrefix == other.phonePrefix &&
        isMetric == other.isMetric &&
        listEquality.equals(
            availablePaymentMethods, other.availablePaymentMethods);
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        countryCode,
        countryFlag,
        currencySymbol,
        taxName,
        taxIsInclusive,
        bookingFee,
        taxRate,
        minOrderAmount,
        phonePrefix,
        isMetric,
        availablePaymentMethods
      ]);
}

CountryStructStruct createCountryStructStruct({
  int? id,
  String? name,
  String? countryCode,
  String? countryFlag,
  String? currencySymbol,
  String? taxName,
  bool? taxIsInclusive,
  double? bookingFee,
  double? taxRate,
  double? minOrderAmount,
  String? phonePrefix,
  bool? isMetric,
}) =>
    CountryStructStruct(
      id: id,
      name: name,
      countryCode: countryCode,
      countryFlag: countryFlag,
      currencySymbol: currencySymbol,
      taxName: taxName,
      taxIsInclusive: taxIsInclusive,
      bookingFee: bookingFee,
      taxRate: taxRate,
      minOrderAmount: minOrderAmount,
      phonePrefix: phonePrefix,
      isMetric: isMetric,
    );
