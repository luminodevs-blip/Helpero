import '../database.dart';

class VSmartCatalogTable extends SupabaseTable<VSmartCatalogRow> {
  @override
  String get tableName => 'v_smart_catalog';

  @override
  VSmartCatalogRow createRow(Map<String, dynamic> data) =>
      VSmartCatalogRow(data);
}

class VSmartCatalogRow extends SupabaseDataRow {
  VSmartCatalogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VSmartCatalogTable();

  String? get objectType => getField<String>('object_type');
  set objectType(String? value) => setField<String>('object_type', value);

  String? get objectId => getField<String>('object_id');
  set objectId(String? value) => setField<String>('object_id', value);

  int? get parentServiceId => getField<int>('parent_service_id');
  set parentServiceId(int? value) => setField<int>('parent_service_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  int? get categoryId => getField<int>('category_id');
  set categoryId(int? value) => setField<int>('category_id', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  dynamic get cardBullets => getField<dynamic>('card_bullets');
  set cardBullets(dynamic value) => setField<dynamic>('card_bullets', value);

  int? get durationMinutes => getField<int>('duration_minutes');
  set durationMinutes(int? value) => setField<int>('duration_minutes', value);

  double? get priceBase => getField<double>('price_base');
  set priceBase(double? value) => setField<double>('price_base', value);

  double? get priceCurrent => getField<double>('price_current');
  set priceCurrent(double? value) => setField<double>('price_current', value);

  double? get priceCompareAt => getField<double>('price_compare_at');
  set priceCompareAt(double? value) =>
      setField<double>('price_compare_at', value);

  String? get activePromoLabel => getField<String>('active_promo_label');
  set activePromoLabel(String? value) =>
      setField<String>('active_promo_label', value);

  int? get activePromoId => getField<int>('active_promo_id');
  set activePromoId(int? value) => setField<int>('active_promo_id', value);
}
