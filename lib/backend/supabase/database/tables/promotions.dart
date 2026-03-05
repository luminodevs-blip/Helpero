import '../database.dart';

class PromotionsTable extends SupabaseTable<PromotionsRow> {
  @override
  String get tableName => 'promotions';

  @override
  PromotionsRow createRow(Map<String, dynamic> data) => PromotionsRow(data);
}

class PromotionsRow extends SupabaseDataRow {
  PromotionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PromotionsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String? get subtitle => getField<String>('subtitle');
  set subtitle(String? value) => setField<String>('subtitle', value);

  String? get bannerImageUrl => getField<String>('banner_image_url');
  set bannerImageUrl(String? value) =>
      setField<String>('banner_image_url', value);

  String? get color => getField<String>('color');
  set color(String? value) => setField<String>('color', value);

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

  List<int> get allowedCountryIds => getListField<int>('allowed_country_ids');
  set allowedCountryIds(List<int>? value) =>
      setListField<int>('allowed_country_ids', value);

  List<int> get allowedCityIds => getListField<int>('allowed_city_ids');
  set allowedCityIds(List<int>? value) =>
      setListField<int>('allowed_city_ids', value);

  List<int> get allowedZoneIds => getListField<int>('allowed_zone_ids');
  set allowedZoneIds(List<int>? value) =>
      setListField<int>('allowed_zone_ids', value);

  int? get priority => getField<int>('priority');
  set priority(int? value) => setField<int>('priority', value);

  bool? get isStackable => getField<bool>('is_stackable');
  set isStackable(bool? value) => setField<bool>('is_stackable', value);

  DateTime? get startsAt => getField<DateTime>('starts_at');
  set startsAt(DateTime? value) => setField<DateTime>('starts_at', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
