import '../database.dart';

class SupportMessagesTable extends SupabaseTable<SupportMessagesRow> {
  @override
  String get tableName => 'support_messages';

  @override
  SupportMessagesRow createRow(Map<String, dynamic> data) =>
      SupportMessagesRow(data);
}

class SupportMessagesRow extends SupabaseDataRow {
  SupportMessagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SupportMessagesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  bool? get isUser => getField<bool>('is_user');
  set isUser(bool? value) => setField<bool>('is_user', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get message => getField<String>('message');
  set message(String? value) => setField<String>('message', value);

  String? get faq => getField<String>('faq');
  set faq(String? value) => setField<String>('faq', value);

  bool? get seenWelcome => getField<bool>('seen_welcome');
  set seenWelcome(bool? value) => setField<bool>('seen_welcome', value);
}
