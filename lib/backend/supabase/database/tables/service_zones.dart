import '../database.dart';

class ServiceZonesTable extends SupabaseTable<ServiceZonesRow> {
  @override
  String get tableName => 'service_zones';

  @override
  ServiceZonesRow createRow(Map<String, dynamic> data) => ServiceZonesRow(data);
}

class ServiceZonesRow extends SupabaseDataRow {
  ServiceZonesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServiceZonesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get cityId => getField<int>('city_id');
  set cityId(int? value) => setField<int>('city_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  double? get surgeMultiplier => getField<double>('surge_multiplier');
  set surgeMultiplier(double? value) =>
      setField<double>('surge_multiplier', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  double? get minLat => getField<double>('min_lat');
  set minLat(double? value) => setField<double>('min_lat', value);

  double? get maxLat => getField<double>('max_lat');
  set maxLat(double? value) => setField<double>('max_lat', value);

  double? get minLng => getField<double>('min_lng');
  set minLng(double? value) => setField<double>('min_lng', value);

  double? get maxLng => getField<double>('max_lng');
  set maxLng(double? value) => setField<double>('max_lng', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  String? get level => getField<String>('level');
  set level(String? value) => setField<String>('level', value);

  int? get activationThreshold => getField<int>('activation_threshold');
  set activationThreshold(int? value) =>
      setField<int>('activation_threshold', value);

  PostgresTime? get workingHoursStart =>
      getField<PostgresTime>('working_hours_start');
  set workingHoursStart(PostgresTime? value) =>
      setField<PostgresTime>('working_hours_start', value);

  PostgresTime? get workingHoursEnd =>
      getField<PostgresTime>('working_hours_end');
  set workingHoursEnd(PostgresTime? value) =>
      setField<PostgresTime>('working_hours_end', value);

  int? get minBufferMinutes => getField<int>('min_buffer_minutes');
  set minBufferMinutes(int? value) =>
      setField<int>('min_buffer_minutes', value);

  int? get maxStandardTravelMinutes =>
      getField<int>('max_standard_travel_minutes');
  set maxStandardTravelMinutes(int? value) =>
      setField<int>('max_standard_travel_minutes', value);

  String? get timezone => getField<String>('timezone');
  set timezone(String? value) => setField<String>('timezone', value);
}
