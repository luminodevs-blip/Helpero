import '../database.dart';

class CommunicationSessionsTable
    extends SupabaseTable<CommunicationSessionsRow> {
  @override
  String get tableName => 'communication_sessions';

  @override
  CommunicationSessionsRow createRow(Map<String, dynamic> data) =>
      CommunicationSessionsRow(data);
}

class CommunicationSessionsRow extends SupabaseDataRow {
  CommunicationSessionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunicationSessionsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  int get orderId => getField<int>('order_id')!;
  set orderId(int value) => setField<int>('order_id', value);

  String get proxyPhoneId => getField<String>('proxy_phone_id')!;
  set proxyPhoneId(String value) => setField<String>('proxy_phone_id', value);

  String get clientId => getField<String>('client_id')!;
  set clientId(String value) => setField<String>('client_id', value);

  String get specialistId => getField<String>('specialist_id')!;
  set specialistId(String value) => setField<String>('specialist_id', value);

  DateTime get expiresAt => getField<DateTime>('expires_at')!;
  set expiresAt(DateTime value) => setField<DateTime>('expires_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get recordingUrl => getField<String>('recording_url');
  set recordingUrl(String? value) => setField<String>('recording_url', value);

  String? get recordingSid => getField<String>('recording_sid');
  set recordingSid(String? value) => setField<String>('recording_sid', value);
}
