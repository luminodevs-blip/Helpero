import '../database.dart';

class CountryPaymentMethodsTable
    extends SupabaseTable<CountryPaymentMethodsRow> {
  @override
  String get tableName => 'country_payment_methods';

  @override
  CountryPaymentMethodsRow createRow(Map<String, dynamic> data) =>
      CountryPaymentMethodsRow(data);
}

class CountryPaymentMethodsRow extends SupabaseDataRow {
  CountryPaymentMethodsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CountryPaymentMethodsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get countryId => getField<int>('country_id');
  set countryId(int? value) => setField<int>('country_id', value);

  int? get paymentTypeId => getField<int>('payment_type_id');
  set paymentTypeId(int? value) => setField<int>('payment_type_id', value);
}
