import '../database.dart';

class ServiceArrivalModesTable extends SupabaseTable<ServiceArrivalModesRow> {
  @override
  String get tableName => 'service_arrival_modes';

  @override
  ServiceArrivalModesRow createRow(Map<String, dynamic> data) =>
      ServiceArrivalModesRow(data);
}

class ServiceArrivalModesRow extends SupabaseDataRow {
  ServiceArrivalModesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServiceArrivalModesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get slug => getField<String>('slug')!;
  set slug(String value) => setField<String>('slug', value);

  double? get fee => getField<double>('fee');
  set fee(double? value) => setField<double>('fee', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);
}
