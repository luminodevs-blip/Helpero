import '../database.dart';

class ServicesTable extends SupabaseTable<ServicesRow> {
  @override
  String get tableName => 'services';

  @override
  ServicesRow createRow(Map<String, dynamic> data) => ServicesRow(data);
}

class ServicesRow extends SupabaseDataRow {
  ServicesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServicesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get categoryId => getField<int>('category_id');
  set categoryId(int? value) => setField<int>('category_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get pricingModel => getField<String>('pricing_model')!;
  set pricingModel(String value) => setField<String>('pricing_model', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  String? get videoUrl => getField<String>('video_url');
  set videoUrl(String? value) => setField<String>('video_url', value);

  String? get serviceTag => getField<String>('service_tag');
  set serviceTag(String? value) => setField<String>('service_tag', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  dynamic get includedItems => getField<dynamic>('included_items');
  set includedItems(dynamic value) =>
      setField<dynamic>('included_items', value);

  dynamic get excludedItems => getField<dynamic>('excluded_items');
  set excludedItems(dynamic value) =>
      setField<dynamic>('excluded_items', value);

  dynamic get requirements => getField<dynamic>('requirements');
  set requirements(dynamic value) => setField<dynamic>('requirements', value);

  String? get flowType => getField<String>('flow_type');
  set flowType(String? value) => setField<String>('flow_type', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  double? get basePrice => getField<double>('base_price');
  set basePrice(double? value) => setField<double>('base_price', value);

  dynamic get translations => getField<dynamic>('translations');
  set translations(dynamic value) => setField<dynamic>('translations', value);

  String? get groupType => getField<String>('group_type');
  set groupType(String? value) => setField<String>('group_type', value);

  double? get rating => getField<double>('rating');
  set rating(double? value) => setField<double>('rating', value);

  int? get reviewsCount => getField<int>('reviews_count');
  set reviewsCount(int? value) => setField<int>('reviews_count', value);

  String? get shortDescription => getField<String>('short_description');
  set shortDescription(String? value) =>
      setField<String>('short_description', value);

  dynamic get beforeAfterImages => getField<dynamic>('before_after_images');
  set beforeAfterImages(dynamic value) =>
      setField<dynamic>('before_after_images', value);

  List<int> get allowedZoneIds => getListField<int>('allowed_zone_ids');
  set allowedZoneIds(List<int>? value) =>
      setListField<int>('allowed_zone_ids', value);

  List<String> get searchTags => getListField<String>('search_tags');
  set searchTags(List<String>? value) =>
      setListField<String>('search_tags', value);

  dynamic get cardBullets => getField<dynamic>('card_bullets');
  set cardBullets(dynamic value) => setField<dynamic>('card_bullets', value);

  String? get estimatedDuration => getField<String>('estimated_duration');
  set estimatedDuration(String? value) =>
      setField<String>('estimated_duration', value);

  int? get durationMinutes => getField<int>('duration_minutes');
  set durationMinutes(int? value) => setField<int>('duration_minutes', value);

  dynamic get serviceTypes => getField<dynamic>('service_types');
  set serviceTypes(dynamic value) => setField<dynamic>('service_types', value);

  String? get includeNote => getField<String>('include_note');
  set includeNote(String? value) => setField<String>('include_note', value);

  dynamic get cleanerBullets => getField<dynamic>('cleaner_bullets');
  set cleanerBullets(dynamic value) =>
      setField<dynamic>('cleaner_bullets', value);

  dynamic get ratingBreakdown => getField<dynamic>('rating_breakdown');
  set ratingBreakdown(dynamic value) =>
      setField<dynamic>('rating_breakdown', value);

  String? get topMasterImageUrl => getField<String>('top_master_image_url');
  set topMasterImageUrl(String? value) =>
      setField<String>('top_master_image_url', value);

  String? get configBanner => getField<String>('config_banner');
  set configBanner(String? value) => setField<String>('config_banner', value);

  String? get configHeader1 => getField<String>('config_header_1');
  set configHeader1(String? value) =>
      setField<String>('config_header_1', value);

  String? get configHeader2 => getField<String>('config_header_2');
  set configHeader2(String? value) =>
      setField<String>('config_header_2', value);

  int? get kitchenDurationMinutes => getField<int>('kitchen_duration_minutes');
  set kitchenDurationMinutes(int? value) =>
      setField<int>('kitchen_duration_minutes', value);
}
