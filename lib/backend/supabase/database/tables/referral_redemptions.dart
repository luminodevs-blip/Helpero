import '../database.dart';

class ReferralRedemptionsTable extends SupabaseTable<ReferralRedemptionsRow> {
  @override
  String get tableName => 'referral_redemptions';

  @override
  ReferralRedemptionsRow createRow(Map<String, dynamic> data) =>
      ReferralRedemptionsRow(data);
}

class ReferralRedemptionsRow extends SupabaseDataRow {
  ReferralRedemptionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReferralRedemptionsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get referrerId => getField<String>('referrer_id')!;
  set referrerId(String value) => setField<String>('referrer_id', value);

  String get refereeId => getField<String>('referee_id')!;
  set refereeId(String value) => setField<String>('referee_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  double? get rewardAmount => getField<double>('reward_amount');
  set rewardAmount(double? value) => setField<double>('reward_amount', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  int? get orderId => getField<int>('order_id');
  set orderId(int? value) => setField<int>('order_id', value);
}
