import '../database.dart';

class SpecialistScheduleConfigTable
    extends SupabaseTable<SpecialistScheduleConfigRow> {
  @override
  String get tableName => 'specialist_schedule_config';

  @override
  SpecialistScheduleConfigRow createRow(Map<String, dynamic> data) =>
      SpecialistScheduleConfigRow(data);
}

class SpecialistScheduleConfigRow extends SupabaseDataRow {
  SpecialistScheduleConfigRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SpecialistScheduleConfigTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get specialistId => getField<String>('specialist_id');
  set specialistId(String? value) => setField<String>('specialist_id', value);

  int get dayOfWeek => getField<int>('day_of_week')!;
  set dayOfWeek(int value) => setField<int>('day_of_week', value);

  PostgresTime? get startTime => getField<PostgresTime>('start_time');
  set startTime(PostgresTime? value) =>
      setField<PostgresTime>('start_time', value);

  PostgresTime? get endTime => getField<PostgresTime>('end_time');
  set endTime(PostgresTime? value) => setField<PostgresTime>('end_time', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
