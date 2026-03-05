import '../database.dart';

class RegionsTable extends SupabaseTable<RegionsRow> {
  @override
  String get tableName => 'regions';

  @override
  RegionsRow createRow(Map<String, dynamic> data) => RegionsRow(data);
}

class RegionsRow extends SupabaseDataRow {
  RegionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RegionsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get countryId => getField<int>('country_id');
  set countryId(int? value) => setField<int>('country_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get currencySymbol => getField<String>('currency_symbol')!;
  set currencySymbol(String value) =>
      setField<String>('currency_symbol', value);

  String get currencyCode => getField<String>('currency_code')!;
  set currencyCode(String value) => setField<String>('currency_code', value);

  bool? get currencyAtFront => getField<bool>('currency_at_front');
  set currencyAtFront(bool? value) =>
      setField<bool>('currency_at_front', value);

  double? get taxRate => getField<double>('tax_rate');
  set taxRate(double? value) => setField<double>('tax_rate', value);

  double? get surgeMultiplier => getField<double>('surge_multiplier');
  set surgeMultiplier(double? value) =>
      setField<double>('surge_multiplier', value);

  double? get centerLat => getField<double>('center_lat');
  set centerLat(double? value) => setField<double>('center_lat', value);

  double? get centerLng => getField<double>('center_lng');
  set centerLng(double? value) => setField<double>('center_lng', value);

  double? get pricePerKm => getField<double>('price_per_km');
  set pricePerKm(double? value) => setField<double>('price_per_km', value);

  double? get baseRadius => getField<double>('base_radius');
  set baseRadius(double? value) => setField<double>('base_radius', value);
}
