import '../database.dart';

class AdminLogsTable extends SupabaseTable<AdminLogsRow> {
  @override
  String get tableName => 'admin_logs';

  @override
  AdminLogsRow createRow(Map<String, dynamic> data) => AdminLogsRow(data);
}

class AdminLogsRow extends SupabaseDataRow {
  AdminLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AdminLogsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get adminId => getField<String>('admin_id');
  set adminId(String? value) => setField<String>('admin_id', value);

  String get action => getField<String>('action')!;
  set action(String value) => setField<String>('action', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
