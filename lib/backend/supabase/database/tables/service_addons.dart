import '../database.dart';

class ServiceAddonsTable extends SupabaseTable<ServiceAddonsRow> {
  @override
  String get tableName => 'service_addons';

  @override
  ServiceAddonsRow createRow(Map<String, dynamic> data) =>
      ServiceAddonsRow(data);
}

class ServiceAddonsRow extends SupabaseDataRow {
  ServiceAddonsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServiceAddonsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  int get serviceId => getField<int>('service_id')!;
  set serviceId(int value) => setField<int>('service_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  double get price => getField<double>('price')!;
  set price(double value) => setField<double>('price', value);

  int? get durationMinutes => getField<int>('duration_minutes');
  set durationMinutes(int? value) => setField<int>('duration_minutes', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  dynamic get translations => getField<dynamic>('translations');
  set translations(dynamic value) => setField<dynamic>('translations', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  dynamic get includedItems => getField<dynamic>('included_items');
  set includedItems(dynamic value) =>
      setField<dynamic>('included_items', value);

  dynamic get excludedItems => getField<dynamic>('excluded_items');
  set excludedItems(dynamic value) =>
      setField<dynamic>('excluded_items', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  double? get compareAtPrice => getField<double>('compare_at_price');
  set compareAtPrice(double? value) =>
      setField<double>('compare_at_price', value);

  String? get addonType => getField<String>('addon_type');
  set addonType(String? value) => setField<String>('addon_type', value);

  String? get displayStage => getField<String>('display_stage');
  set displayStage(String? value) => setField<String>('display_stage', value);

  String? get sectionHeader => getField<String>('section_header');
  set sectionHeader(String? value) => setField<String>('section_header', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  int? get sectionIndex => getField<int>('section_index');
  set sectionIndex(int? value) => setField<int>('section_index', value);
}
