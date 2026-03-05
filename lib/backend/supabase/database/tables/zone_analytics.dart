import '../database.dart';

class ZoneAnalyticsTable extends SupabaseTable<ZoneAnalyticsRow> {
  @override
  String get tableName => 'zone_analytics';

  @override
  ZoneAnalyticsRow createRow(Map<String, dynamic> data) =>
      ZoneAnalyticsRow(data);
}

class ZoneAnalyticsRow extends SupabaseDataRow {
  ZoneAnalyticsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ZoneAnalyticsTable();

  int? get zoneId => getField<int>('zone_id');
  set zoneId(int? value) => setField<int>('zone_id', value);

  String? get zoneName => getField<String>('zone_name');
  set zoneName(String? value) => setField<String>('zone_name', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  int? get activationThreshold => getField<int>('activation_threshold');
  set activationThreshold(int? value) =>
      setField<int>('activation_threshold', value);

  int? get currentLeads => getField<int>('current_leads');
  set currentLeads(int? value) => setField<int>('current_leads', value);

  double? get readinessPercent => getField<double>('readiness_percent');
  set readinessPercent(double? value) =>
      setField<double>('readiness_percent', value);
}
