import '../database.dart';

class ServiceTasksTable extends SupabaseTable<ServiceTasksRow> {
  @override
  String get tableName => 'service_tasks';

  @override
  ServiceTasksRow createRow(Map<String, dynamic> data) => ServiceTasksRow(data);
}

class ServiceTasksRow extends SupabaseDataRow {
  ServiceTasksRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServiceTasksTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get iconUrl => getField<String>('icon_url');
  set iconUrl(String? value) => setField<String>('icon_url', value);
}
