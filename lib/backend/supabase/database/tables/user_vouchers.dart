import '../database.dart';

class UserVouchersTable extends SupabaseTable<UserVouchersRow> {
  @override
  String get tableName => 'user_vouchers';

  @override
  UserVouchersRow createRow(Map<String, dynamic> data) => UserVouchersRow(data);
}

class UserVouchersRow extends SupabaseDataRow {
  UserVouchersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserVouchersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get promocodeId => getField<int>('promocode_id');
  set promocodeId(int? value) => setField<int>('promocode_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get assignedAt => getField<DateTime>('assigned_at');
  set assignedAt(DateTime? value) => setField<DateTime>('assigned_at', value);

  DateTime? get usedAt => getField<DateTime>('used_at');
  set usedAt(DateTime? value) => setField<DateTime>('used_at', value);

  int? get orderId => getField<int>('order_id');
  set orderId(int? value) => setField<int>('order_id', value);

  int? get usageCount => getField<int>('usage_count');
  set usageCount(int? value) => setField<int>('usage_count', value);

  int? get voucherId => getField<int>('voucher_id');
  set voucherId(int? value) => setField<int>('voucher_id', value);
}
