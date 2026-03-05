import '../database.dart';

class MarketingCampaignsTable extends SupabaseTable<MarketingCampaignsRow> {
  @override
  String get tableName => 'marketing_campaigns';

  @override
  MarketingCampaignsRow createRow(Map<String, dynamic> data) =>
      MarketingCampaignsRow(data);
}

class MarketingCampaignsRow extends SupabaseDataRow {
  MarketingCampaignsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MarketingCampaignsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  bool? get isEnabled => getField<bool>('is_enabled');
  set isEnabled(bool? value) => setField<bool>('is_enabled', value);

  String get campaignType => getField<String>('campaign_type')!;
  set campaignType(String value) => setField<String>('campaign_type', value);

  dynamic get config => getField<dynamic>('config');
  set config(dynamic value) => setField<dynamic>('config', value);

  int? get priority => getField<int>('priority');
  set priority(int? value) => setField<int>('priority', value);

  DateTime? get startsAt => getField<DateTime>('starts_at');
  set startsAt(DateTime? value) => setField<DateTime>('starts_at', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
