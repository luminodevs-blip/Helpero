import '../database.dart';

class UserBalanceTable extends SupabaseTable<UserBalanceRow> {
  @override
  String get tableName => 'user_balance';

  @override
  UserBalanceRow createRow(Map<String, dynamic> data) => UserBalanceRow(data);
}

class UserBalanceRow extends SupabaseDataRow {
  UserBalanceRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserBalanceTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  double? get amount => getField<double>('amount');
  set amount(double? value) => setField<double>('amount', value);

  String? get currencyCode => getField<String>('currency_code');
  set currencyCode(String? value) => setField<String>('currency_code', value);
}
