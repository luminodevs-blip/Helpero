import '../database.dart';

class OrderChatMessagesTable extends SupabaseTable<OrderChatMessagesRow> {
  @override
  String get tableName => 'order_chat_messages';

  @override
  OrderChatMessagesRow createRow(Map<String, dynamic> data) =>
      OrderChatMessagesRow(data);
}

class OrderChatMessagesRow extends SupabaseDataRow {
  OrderChatMessagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrderChatMessagesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  int get orderId => getField<int>('order_id')!;
  set orderId(int value) => setField<int>('order_id', value);

  String get senderId => getField<String>('sender_id')!;
  set senderId(String value) => setField<String>('sender_id', value);

  String? get text => getField<String>('text');
  set text(String? value) => setField<String>('text', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  bool? get isRead => getField<bool>('is_read');
  set isRead(bool? value) => setField<bool>('is_read', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
