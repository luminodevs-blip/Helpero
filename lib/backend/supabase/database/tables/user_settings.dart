import '../database.dart';

class UserSettingsTable extends SupabaseTable<UserSettingsRow> {
  @override
  String get tableName => 'user_settings';

  @override
  UserSettingsRow createRow(Map<String, dynamic> data) => UserSettingsRow(data);
}

class UserSettingsRow extends SupabaseDataRow {
  UserSettingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserSettingsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get settingKey => getField<String>('setting_key')!;
  set settingKey(String value) => setField<String>('setting_key', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  bool? get isEnabled => getField<bool>('is_enabled');
  set isEnabled(bool? value) => setField<bool>('is_enabled', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
