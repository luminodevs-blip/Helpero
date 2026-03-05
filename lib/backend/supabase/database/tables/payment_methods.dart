import '../database.dart';

class PaymentMethodsTable extends SupabaseTable<PaymentMethodsRow> {
  @override
  String get tableName => 'payment_methods';

  @override
  PaymentMethodsRow createRow(Map<String, dynamic> data) =>
      PaymentMethodsRow(data);
}

class PaymentMethodsRow extends SupabaseDataRow {
  PaymentMethodsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PaymentMethodsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get cardType => getField<String>('card_type');
  set cardType(String? value) => setField<String>('card_type', value);

  String? get last4 => getField<String>('last4');
  set last4(String? value) => setField<String>('last4', value);

  String? get expiryDate => getField<String>('expiry_date');
  set expiryDate(String? value) => setField<String>('expiry_date', value);

  bool? get isDefault => getField<bool>('is_default');
  set isDefault(bool? value) => setField<bool>('is_default', value);

  String? get gatewayId => getField<String>('gateway_id');
  set gatewayId(String? value) => setField<String>('gateway_id', value);
}
