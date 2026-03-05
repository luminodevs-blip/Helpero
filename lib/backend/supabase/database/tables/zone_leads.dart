import '../database.dart';

class ZoneLeadsTable extends SupabaseTable<ZoneLeadsRow> {
  @override
  String get tableName => 'zone_leads';

  @override
  ZoneLeadsRow createRow(Map<String, dynamic> data) => ZoneLeadsRow(data);
}

class ZoneLeadsRow extends SupabaseDataRow {
  ZoneLeadsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ZoneLeadsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get phoneNumber => getField<String>('phone_number');
  set phoneNumber(String? value) => setField<String>('phone_number', value);

  int? get zoneId => getField<int>('zone_id');
  set zoneId(int? value) => setField<int>('zone_id', value);

  String? get referralCode => getField<String>('referral_code');
  set referralCode(String? value) => setField<String>('referral_code', value);

  String? get referrerId => getField<String>('referrer_id');
  set referrerId(String? value) => setField<String>('referrer_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  int? get points => getField<int>('points');
  set points(int? value) => setField<int>('points', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
