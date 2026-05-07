import '../database.dart';

class AppBannersTable extends SupabaseTable<AppBannersRow> {
  @override
  String get tableName => 'app_banners';

  @override
  AppBannersRow createRow(Map<String, dynamic> data) => AppBannersRow(data);
}

class AppBannersRow extends SupabaseDataRow {
  AppBannersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AppBannersTable();

  int? get id => getField<int>('id');
  set id(int? value) => setField<int>('id', value);

  String get sectionId => getField<String>('section_id')!;
  set sectionId(String value) => setField<String>('section_id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String? get bodyText => getField<String>('body_text');
  set bodyText(String? value) => setField<String>('body_text', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  String? get actionType => getField<String>('action_type');
  set actionType(String? value) => setField<String>('action_type', value);

  String? get actionPayload => getField<String>('action_payload');
  set actionPayload(String? value) => setField<String>('action_payload', value);

  String? get ctaText => getField<String>('cta_text');
  set ctaText(String? value) => setField<String>('cta_text', value);

  List<int> get allowedZoneIds => getListField<int>('allowed_zone_ids');
  set allowedZoneIds(List<int>? value) =>
      setListField<int>('allowed_zone_ids', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
