import '../database.dart';

class OrderItemAddonsTable extends SupabaseTable<OrderItemAddonsRow> {
  @override
  String get tableName => 'order_item_addons';

  @override
  OrderItemAddonsRow createRow(Map<String, dynamic> data) =>
      OrderItemAddonsRow(data);
}

class OrderItemAddonsRow extends SupabaseDataRow {
  OrderItemAddonsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrderItemAddonsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get orderItemId => getField<int>('order_item_id');
  set orderItemId(int? value) => setField<int>('order_item_id', value);

  String get addonName => getField<String>('addon_name')!;
  set addonName(String value) => setField<String>('addon_name', value);

  double get addonPriceSnap => getField<double>('addon_price_snap')!;
  set addonPriceSnap(double value) =>
      setField<double>('addon_price_snap', value);
}
