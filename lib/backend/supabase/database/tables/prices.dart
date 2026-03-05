import '../database.dart';

class PricesTable extends SupabaseTable<PricesRow> {
  @override
  String get tableName => 'prices';

  @override
  PricesRow createRow(Map<String, dynamic> data) => PricesRow(data);
}

class PricesRow extends SupabaseDataRow {
  PricesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PricesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get regionId => getField<int>('region_id');
  set regionId(int? value) => setField<int>('region_id', value);

  int? get serviceId => getField<int>('service_id');
  set serviceId(int? value) => setField<int>('service_id', value);

  int? get tierId => getField<int>('tier_id');
  set tierId(int? value) => setField<int>('tier_id', value);

  double get pricePerUnit => getField<double>('price_per_unit')!;
  set pricePerUnit(double value) => setField<double>('price_per_unit', value);
}
