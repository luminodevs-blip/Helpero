import '../database.dart';

class HousesTable extends SupabaseTable<HousesRow> {
  @override
  String get tableName => 'houses';

  @override
  HousesRow createRow(Map<String, dynamic> data) => HousesRow(data);
}

class HousesRow extends SupabaseDataRow {
  HousesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => HousesTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String get fullAddress => getField<String>('full_address')!;
  set fullAddress(String value) => setField<String>('full_address', value);

  double? get areaSize => getField<double>('area_size');
  set areaSize(double? value) => setField<double>('area_size', value);

  double? get lat => getField<double>('lat');
  set lat(double? value) => setField<double>('lat', value);

  double? get lng => getField<double>('lng');
  set lng(double? value) => setField<double>('lng', value);

  bool? get isDefault => getField<bool>('is_default');
  set isDefault(bool? value) => setField<bool>('is_default', value);

  int? get kitchensCount => getField<int>('kitchens_count');
  set kitchensCount(int? value) => setField<int>('kitchens_count', value);

  String? get propertyType => getField<String>('property_type');
  set propertyType(String? value) => setField<String>('property_type', value);

  String? get nameLabel => getField<String>('name_label');
  set nameLabel(String? value) => setField<String>('name_label', value);

  String? get zipCode => getField<String>('zip_code');
  set zipCode(String? value) => setField<String>('zip_code', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  int? get numBedrooms => getField<int>('num_bedrooms');
  set numBedrooms(int? value) => setField<int>('num_bedrooms', value);

  int? get numBathrooms => getField<int>('num_bathrooms');
  set numBathrooms(int? value) => setField<int>('num_bathrooms', value);

  String? get unitNumber => getField<String>('unit_number');
  set unitNumber(String? value) => setField<String>('unit_number', value);

  String? get floor => getField<String>('floor');
  set floor(String? value) => setField<String>('floor', value);

  String? get intercomCode => getField<String>('intercom_code');
  set intercomCode(String? value) => setField<String>('intercom_code', value);

  String? get gateCode => getField<String>('gate_code');
  set gateCode(String? value) => setField<String>('gate_code', value);

  String? get companyName => getField<String>('company_name');
  set companyName(String? value) => setField<String>('company_name', value);

  String? get instructions => getField<String>('instructions');
  set instructions(String? value) => setField<String>('instructions', value);
}
