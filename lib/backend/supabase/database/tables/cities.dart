import '../database.dart';

class CitiesTable extends SupabaseTable<CitiesRow> {
  @override
  String get tableName => 'cities';

  @override
  CitiesRow createRow(Map<String, dynamic> data) => CitiesRow(data);
}

class CitiesRow extends SupabaseDataRow {
  CitiesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CitiesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get countryId => getField<int>('country_id');
  set countryId(int? value) => setField<int>('country_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get slug => getField<String>('slug')!;
  set slug(String value) => setField<String>('slug', value);

  String? get timezone => getField<String>('timezone');
  set timezone(String? value) => setField<String>('timezone', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  int? get regionId => getField<int>('region_id');
  set regionId(int? value) => setField<int>('region_id', value);
}
