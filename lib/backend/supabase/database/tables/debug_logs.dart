import '../database.dart';

class DebugLogsTable extends SupabaseTable<DebugLogsRow> {
  @override
  String get tableName => 'debug_logs';

  @override
  DebugLogsRow createRow(Map<String, dynamic> data) => DebugLogsRow(data);
}

class DebugLogsRow extends SupabaseDataRow {
  DebugLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DebugLogsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get functionName => getField<String>('function_name');
  set functionName(String? value) => setField<String>('function_name', value);

  String? get step => getField<String>('step');
  set step(String? value) => setField<String>('step', value);

  String? get errorMessage => getField<String>('error_message');
  set errorMessage(String? value) => setField<String>('error_message', value);

  dynamic get payload => getField<dynamic>('payload');
  set payload(dynamic value) => setField<dynamic>('payload', value);
}
