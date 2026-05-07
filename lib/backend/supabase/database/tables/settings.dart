import '../database.dart';

class SettingsTable extends SupabaseTable<SettingsRow> {
  @override
  String get tableName => 'settings';

  @override
  SettingsRow createRow(Map<String, dynamic> data) => SettingsRow(data);
}

class SettingsRow extends SupabaseDataRow {
  SettingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SettingsTable();

  String get key => getField<String>('key')!;
  set key(String value) => setField<String>('key', value);

  String get value => getField<String>('value')!;
  set value(String value) => setField<String>('value', value);
}
