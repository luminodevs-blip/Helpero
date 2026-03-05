import '../database.dart';

class PaymentTypeCatalogTable extends SupabaseTable<PaymentTypeCatalogRow> {
  @override
  String get tableName => 'payment_type_catalog';

  @override
  PaymentTypeCatalogRow createRow(Map<String, dynamic> data) =>
      PaymentTypeCatalogRow(data);
}

class PaymentTypeCatalogRow extends SupabaseDataRow {
  PaymentTypeCatalogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PaymentTypeCatalogTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get code => getField<String>('code')!;
  set code(String value) => setField<String>('code', value);

  String? get iconUrl => getField<String>('icon_url');
  set iconUrl(String? value) => setField<String>('icon_url', value);
}
