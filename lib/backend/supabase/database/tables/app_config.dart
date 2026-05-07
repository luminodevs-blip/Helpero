import '../database.dart';

class AppConfigTable extends SupabaseTable<AppConfigRow> {
  @override
  String get tableName => 'app_config';

  @override
  AppConfigRow createRow(Map<String, dynamic> data) => AppConfigRow(data);
}

class AppConfigRow extends SupabaseDataRow {
  AppConfigRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AppConfigTable();

  String get key => getField<String>('key')!;
  set key(String value) => setField<String>('key', value);

  dynamic get value => getField<dynamic>('value')!;
  set value(dynamic value) => setField<dynamic>('value', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
