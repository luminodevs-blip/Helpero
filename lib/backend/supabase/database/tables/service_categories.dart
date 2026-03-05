import '../database.dart';

class ServiceCategoriesTable extends SupabaseTable<ServiceCategoriesRow> {
  @override
  String get tableName => 'service_categories';

  @override
  ServiceCategoriesRow createRow(Map<String, dynamic> data) =>
      ServiceCategoriesRow(data);
}

class ServiceCategoriesRow extends SupabaseDataRow {
  ServiceCategoriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServiceCategoriesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get slug => getField<String>('slug')!;
  set slug(String value) => setField<String>('slug', value);

  double? get rating => getField<double>('rating');
  set rating(double? value) => setField<double>('rating', value);

  String? get bookingsCount => getField<String>('bookings_count');
  set bookingsCount(String? value) => setField<String>('bookings_count', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  String? get videoUrl => getField<String>('video_url');
  set videoUrl(String? value) => setField<String>('video_url', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  String? get packageHeader => getField<String>('package_header');
  set packageHeader(String? value) => setField<String>('package_header', value);

  String? get miniHeader => getField<String>('mini_header');
  set miniHeader(String? value) => setField<String>('mini_header', value);
}
