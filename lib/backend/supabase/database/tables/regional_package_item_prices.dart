import '../database.dart';

class RegionalPackageItemPricesTable
    extends SupabaseTable<RegionalPackageItemPricesRow> {
  @override
  String get tableName => 'regional_package_item_prices';

  @override
  RegionalPackageItemPricesRow createRow(Map<String, dynamic> data) =>
      RegionalPackageItemPricesRow(data);
}

class RegionalPackageItemPricesRow extends SupabaseDataRow {
  RegionalPackageItemPricesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RegionalPackageItemPricesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get regionId => getField<int>('region_id');
  set regionId(int? value) => setField<int>('region_id', value);

  int? get configId => getField<int>('config_id');
  set configId(int? value) => setField<int>('config_id', value);

  double get pricePerUnit => getField<double>('price_per_unit')!;
  set pricePerUnit(double value) => setField<double>('price_per_unit', value);
}
