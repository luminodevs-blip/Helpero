import '../database.dart';

class OrderItemsTable extends SupabaseTable<OrderItemsRow> {
  @override
  String get tableName => 'order_items';

  @override
  OrderItemsRow createRow(Map<String, dynamic> data) => OrderItemsRow(data);
}

class OrderItemsRow extends SupabaseDataRow {
  OrderItemsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrderItemsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get orderId => getField<int>('order_id');
  set orderId(int? value) => setField<int>('order_id', value);

  int? get serviceId => getField<int>('service_id');
  set serviceId(int? value) => setField<int>('service_id', value);

  int? get tierId => getField<int>('tier_id');
  set tierId(int? value) => setField<int>('tier_id', value);

  String get serviceName => getField<String>('service_name')!;
  set serviceName(String value) => setField<String>('service_name', value);

  String get categoryName => getField<String>('category_name')!;
  set categoryName(String value) => setField<String>('category_name', value);

  double get quantity => getField<double>('quantity')!;
  set quantity(double value) => setField<double>('quantity', value);

  String? get unitLabel => getField<String>('unit_label');
  set unitLabel(String? value) => setField<String>('unit_label', value);

  double get basePriceSnap => getField<double>('base_price_snap')!;
  set basePriceSnap(double value) => setField<double>('base_price_snap', value);

  double? get surgeMultiplierSnap => getField<double>('surge_multiplier_snap');
  set surgeMultiplierSnap(double? value) =>
      setField<double>('surge_multiplier_snap', value);

  double get itemTotalPrice => getField<double>('item_total_price')!;
  set itemTotalPrice(double value) =>
      setField<double>('item_total_price', value);
}
