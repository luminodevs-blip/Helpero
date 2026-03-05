import '../database.dart';

class SpecialistsTable extends SupabaseTable<SpecialistsRow> {
  @override
  String get tableName => 'specialists';

  @override
  SpecialistsRow createRow(Map<String, dynamic> data) => SpecialistsRow(data);
}

class SpecialistsRow extends SupabaseDataRow {
  SpecialistsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SpecialistsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  double? get rating => getField<double>('rating');
  set rating(double? value) => setField<double>('rating', value);

  int? get completedOrdersCount => getField<int>('completed_orders_count');
  set completedOrdersCount(int? value) =>
      setField<int>('completed_orders_count', value);

  String? get bio => getField<String>('bio');
  set bio(String? value) => setField<String>('bio', value);

  int? get baseRegionId => getField<int>('base_region_id');
  set baseRegionId(int? value) => setField<int>('base_region_id', value);

  bool? get verified => getField<bool>('verified');
  set verified(bool? value) => setField<bool>('verified', value);

  double? get lastLocationLat => getField<double>('last_location_lat');
  set lastLocationLat(double? value) =>
      setField<double>('last_location_lat', value);

  double? get lastLocationLng => getField<double>('last_location_lng');
  set lastLocationLng(double? value) =>
      setField<double>('last_location_lng', value);

  String? get radarStatus => getField<String>('radar_status');
  set radarStatus(String? value) => setField<String>('radar_status', value);
}
