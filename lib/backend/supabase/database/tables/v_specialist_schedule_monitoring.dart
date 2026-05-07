import '../database.dart';

class VSpecialistScheduleMonitoringTable
    extends SupabaseTable<VSpecialistScheduleMonitoringRow> {
  @override
  String get tableName => 'v_specialist_schedule_monitoring';

  @override
  VSpecialistScheduleMonitoringRow createRow(Map<String, dynamic> data) =>
      VSpecialistScheduleMonitoringRow(data);
}

class VSpecialistScheduleMonitoringRow extends SupabaseDataRow {
  VSpecialistScheduleMonitoringRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VSpecialistScheduleMonitoringTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  String? get radarStatus => getField<String>('radar_status');
  set radarStatus(String? value) => setField<String>('radar_status', value);

  String? get shiftStart => getField<String>('shift_start');
  set shiftStart(String? value) => setField<String>('shift_start', value);

  String? get shiftEnd => getField<String>('shift_end');
  set shiftEnd(String? value) => setField<String>('shift_end', value);

  dynamic get ordersToday => getField<dynamic>('orders_today');
  set ordersToday(dynamic value) => setField<dynamic>('orders_today', value);

  String? get currentActivity => getField<String>('current_activity');
  set currentActivity(String? value) =>
      setField<String>('current_activity', value);
}
