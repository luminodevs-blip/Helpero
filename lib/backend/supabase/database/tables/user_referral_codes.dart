import '../database.dart';

class UserReferralCodesTable extends SupabaseTable<UserReferralCodesRow> {
  @override
  String get tableName => 'user_referral_codes';

  @override
  UserReferralCodesRow createRow(Map<String, dynamic> data) =>
      UserReferralCodesRow(data);
}

class UserReferralCodesRow extends SupabaseDataRow {
  UserReferralCodesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserReferralCodesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get code => getField<String>('code')!;
  set code(String value) => setField<String>('code', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
