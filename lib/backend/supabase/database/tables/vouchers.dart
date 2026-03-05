import '../database.dart';

class VouchersTable extends SupabaseTable<VouchersRow> {
  @override
  String get tableName => 'vouchers';

  @override
  VouchersRow createRow(Map<String, dynamic> data) => VouchersRow(data);
}

class VouchersRow extends SupabaseDataRow {
  VouchersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VouchersTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get code => getField<String>('code');
  set code(String? value) => setField<String>('code', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String get discountType => getField<String>('discount_type')!;
  set discountType(String value) => setField<String>('discount_type', value);

  double get discountValue => getField<double>('discount_value')!;
  set discountValue(double value) => setField<double>('discount_value', value);

  double? get maxDiscountLimit => getField<double>('max_discount_limit');
  set maxDiscountLimit(double? value) =>
      setField<double>('max_discount_limit', value);

  double? get minOrderSubtotal => getField<double>('min_order_subtotal');
  set minOrderSubtotal(double? value) =>
      setField<double>('min_order_subtotal', value);

  List<int> get allowedCategories => getListField<int>('allowed_categories');
  set allowedCategories(List<int>? value) =>
      setListField<int>('allowed_categories', value);

  String? get targetAudience => getField<String>('target_audience');
  set targetAudience(String? value) =>
      setField<String>('target_audience', value);

  String? get targetUserId => getField<String>('target_user_id');
  set targetUserId(String? value) => setField<String>('target_user_id', value);

  List<int> get allowedCountryIds => getListField<int>('allowed_country_ids');
  set allowedCountryIds(List<int>? value) =>
      setListField<int>('allowed_country_ids', value);

  List<int> get allowedCityIds => getListField<int>('allowed_city_ids');
  set allowedCityIds(List<int>? value) =>
      setListField<int>('allowed_city_ids', value);

  List<int> get allowedZoneIds => getListField<int>('allowed_zone_ids');
  set allowedZoneIds(List<int>? value) =>
      setListField<int>('allowed_zone_ids', value);

  bool? get isUserClaimable => getField<bool>('is_user_claimable');
  set isUserClaimable(bool? value) =>
      setField<bool>('is_user_claimable', value);

  int? get perUserLimit => getField<int>('per_user_limit');
  set perUserLimit(int? value) => setField<int>('per_user_limit', value);

  int? get totalRedemptionLimit => getField<int>('total_redemption_limit');
  set totalRedemptionLimit(int? value) =>
      setField<int>('total_redemption_limit', value);

  int? get currentRedemptions => getField<int>('current_redemptions');
  set currentRedemptions(int? value) =>
      setField<int>('current_redemptions', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);

  String? get issuedBy => getField<String>('issued_by');
  set issuedBy(String? value) => setField<String>('issued_by', value);

  String? get issuedByType => getField<String>('issued_by_type');
  set issuedByType(String? value) => setField<String>('issued_by_type', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
