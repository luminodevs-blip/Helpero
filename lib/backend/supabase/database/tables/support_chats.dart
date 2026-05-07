import '../database.dart';

class SupportChatsTable extends SupabaseTable<SupportChatsRow> {
  @override
  String get tableName => 'support_chats';

  @override
  SupportChatsRow createRow(Map<String, dynamic> data) => SupportChatsRow(data);
}

class SupportChatsRow extends SupabaseDataRow {
  SupportChatsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SupportChatsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get categoryId => getField<String>('category_id');
  set categoryId(String? value) => setField<String>('category_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
