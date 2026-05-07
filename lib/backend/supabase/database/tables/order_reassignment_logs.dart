import '../database.dart';

class OrderReassignmentLogsTable
    extends SupabaseTable<OrderReassignmentLogsRow> {
  @override
  String get tableName => 'order_reassignment_logs';

  @override
  OrderReassignmentLogsRow createRow(Map<String, dynamic> data) =>
      OrderReassignmentLogsRow(data);
}

class OrderReassignmentLogsRow extends SupabaseDataRow {
  OrderReassignmentLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrderReassignmentLogsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  int? get orderId => getField<int>('order_id');
  set orderId(int? value) => setField<int>('order_id', value);

  String? get oldSpecialistId => getField<String>('old_specialist_id');
  set oldSpecialistId(String? value) =>
      setField<String>('old_specialist_id', value);

  String? get newSpecialistId => getField<String>('new_specialist_id');
  set newSpecialistId(String? value) =>
      setField<String>('new_specialist_id', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
