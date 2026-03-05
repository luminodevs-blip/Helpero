import '../database.dart';

class CountriesTable extends SupabaseTable<CountriesRow> {
  @override
  String get tableName => 'countries';

  @override
  CountriesRow createRow(Map<String, dynamic> data) => CountriesRow(data);
}

class CountriesRow extends SupabaseDataRow {
  CountriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CountriesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get countryCode => getField<String>('country_code')!;
  set countryCode(String value) => setField<String>('country_code', value);

  String get phonePrefix => getField<String>('phone_prefix')!;
  set phonePrefix(String value) => setField<String>('phone_prefix', value);

  String? get taxName => getField<String>('tax_name');
  set taxName(String? value) => setField<String>('tax_name', value);

  bool? get taxIsInclusive => getField<bool>('tax_is_inclusive');
  set taxIsInclusive(bool? value) => setField<bool>('tax_is_inclusive', value);

  bool? get isMetric => getField<bool>('is_metric');
  set isMetric(bool? value) => setField<bool>('is_metric', value);

  String? get currencyCode => getField<String>('currency_code');
  set currencyCode(String? value) => setField<String>('currency_code', value);

  String? get currencySymbol => getField<String>('currency_symbol');
  set currencySymbol(String? value) =>
      setField<String>('currency_symbol', value);

  String? get areaUnit => getField<String>('area_unit');
  set areaUnit(String? value) => setField<String>('area_unit', value);

  double? get taxRate => getField<double>('tax_rate');
  set taxRate(double? value) => setField<double>('tax_rate', value);

  String? get countryFlag => getField<String>('country_flag');
  set countryFlag(String? value) => setField<String>('country_flag', value);

  List<int> get availablePaymentMethods =>
      getListField<int>('available_payment_methods');
  set availablePaymentMethods(List<int>? value) =>
      setListField<int>('available_payment_methods', value);

  double? get bookingFee => getField<double>('booking_fee');
  set bookingFee(double? value) => setField<double>('booking_fee', value);

  double? get minOrderAmount => getField<double>('min_order_amount');
  set minOrderAmount(double? value) =>
      setField<double>('min_order_amount', value);
}
