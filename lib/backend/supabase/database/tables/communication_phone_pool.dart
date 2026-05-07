import '../database.dart';

class CommunicationPhonePoolTable
    extends SupabaseTable<CommunicationPhonePoolRow> {
  @override
  String get tableName => 'communication_phone_pool';

  @override
  CommunicationPhonePoolRow createRow(Map<String, dynamic> data) =>
      CommunicationPhonePoolRow(data);
}

class CommunicationPhonePoolRow extends SupabaseDataRow {
  CommunicationPhonePoolRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CommunicationPhonePoolTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get proxyPhone => getField<String>('proxy_phone')!;
  set proxyPhone(String value) => setField<String>('proxy_phone', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
