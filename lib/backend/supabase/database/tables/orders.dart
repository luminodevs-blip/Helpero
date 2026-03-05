import '../database.dart';

class OrdersTable extends SupabaseTable<OrdersRow> {
  @override
  String get tableName => 'orders';

  @override
  OrdersRow createRow(Map<String, dynamic> data) => OrdersRow(data);
}

class OrdersRow extends SupabaseDataRow {
  OrdersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrdersTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  int? get houseId => getField<int>('house_id');
  set houseId(int? value) => setField<int>('house_id', value);

  int? get regionId => getField<int>('region_id');
  set regionId(int? value) => setField<int>('region_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  double get totalItemsPrice => getField<double>('total_items_price')!;
  set totalItemsPrice(double value) =>
      setField<double>('total_items_price', value);

  double? get totalTaxAmount => getField<double>('total_tax_amount');
  set totalTaxAmount(double? value) =>
      setField<double>('total_tax_amount', value);

  double? get totalTransportFee => getField<double>('total_transport_fee');
  set totalTransportFee(double? value) =>
      setField<double>('total_transport_fee', value);

  double get finalTotalPrice => getField<double>('final_total_price')!;
  set finalTotalPrice(double value) =>
      setField<double>('final_total_price', value);

  String? get currencyCode => getField<String>('currency_code');
  set currencyCode(String? value) => setField<String>('currency_code', value);

  bool? get isProOrder => getField<bool>('is_pro_order');
  set isProOrder(bool? value) => setField<bool>('is_pro_order', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get entryMethod => getField<String>('entry_method');
  set entryMethod(String? value) => setField<String>('entry_method', value);

  String? get accessNotes => getField<String>('access_notes');
  set accessNotes(String? value) => setField<String>('access_notes', value);

  double? get visitFee => getField<double>('visit_fee');
  set visitFee(double? value) => setField<double>('visit_fee', value);

  double? get tripFee => getField<double>('trip_fee');
  set tripFee(double? value) => setField<double>('trip_fee', value);

  double? get highDemandFee => getField<double>('high_demand_fee');
  set highDemandFee(double? value) =>
      setField<double>('high_demand_fee', value);

  String? get specialistId => getField<String>('specialist_id');
  set specialistId(String? value) => setField<String>('specialist_id', value);

  DateTime? get scheduledStartAt => getField<DateTime>('scheduled_start_at');
  set scheduledStartAt(DateTime? value) =>
      setField<DateTime>('scheduled_start_at', value);

  DateTime? get scheduledEndAt => getField<DateTime>('scheduled_end_at');
  set scheduledEndAt(DateTime? value) =>
      setField<DateTime>('scheduled_end_at', value);

  String? get arrivalModeId => getField<String>('arrival_mode_id');
  set arrivalModeId(String? value) =>
      setField<String>('arrival_mode_id', value);

  String? get paymentId => getField<String>('payment_id');
  set paymentId(String? value) => setField<String>('payment_id', value);

  String? get cartId => getField<String>('cart_id');
  set cartId(String? value) => setField<String>('cart_id', value);
}
