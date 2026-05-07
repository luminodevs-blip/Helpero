import '../database.dart';

class VActiveOrderDetailsTable extends SupabaseTable<VActiveOrderDetailsRow> {
  @override
  String get tableName => 'v_active_order_details';

  @override
  VActiveOrderDetailsRow createRow(Map<String, dynamic> data) =>
      VActiveOrderDetailsRow(data);
}

class VActiveOrderDetailsRow extends SupabaseDataRow {
  VActiveOrderDetailsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VActiveOrderDetailsTable();

  int? get orderId => getField<int>('order_id');
  set orderId(int? value) => setField<int>('order_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get orderStatus => getField<String>('order_status');
  set orderStatus(String? value) => setField<String>('order_status', value);

  DateTime? get scheduledStartAt => getField<DateTime>('scheduled_start_at');
  set scheduledStartAt(DateTime? value) =>
      setField<DateTime>('scheduled_start_at', value);

  String? get securePin => getField<String>('secure_pin');
  set securePin(String? value) => setField<String>('secure_pin', value);

  double? get finalTotalPrice => getField<double>('final_total_price');
  set finalTotalPrice(double? value) =>
      setField<double>('final_total_price', value);

  String? get fullAddress => getField<String>('full_address');
  set fullAddress(String? value) => setField<String>('full_address', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  double? get destinationLat => getField<double>('destination_lat');
  set destinationLat(double? value) =>
      setField<double>('destination_lat', value);

  double? get destinationLng => getField<double>('destination_lng');
  set destinationLng(double? value) =>
      setField<double>('destination_lng', value);

  String? get specialistId => getField<String>('specialist_id');
  set specialistId(String? value) => setField<String>('specialist_id', value);

  String? get specialistFirstName => getField<String>('specialist_first_name');
  set specialistFirstName(String? value) =>
      setField<String>('specialist_first_name', value);

  String? get specialistLastName => getField<String>('specialist_last_name');
  set specialistLastName(String? value) =>
      setField<String>('specialist_last_name', value);

  String? get specialistAvatarUrl => getField<String>('specialist_avatar_url');
  set specialistAvatarUrl(String? value) =>
      setField<String>('specialist_avatar_url', value);

  double? get specialistRating => getField<double>('specialist_rating');
  set specialistRating(double? value) =>
      setField<double>('specialist_rating', value);

  int? get specialistCompletedOrders =>
      getField<int>('specialist_completed_orders');
  set specialistCompletedOrders(int? value) =>
      setField<int>('specialist_completed_orders', value);

  DateTime? get scheduledEndAt => getField<DateTime>('scheduled_end_at');
  set scheduledEndAt(DateTime? value) =>
      setField<DateTime>('scheduled_end_at', value);

  String? get cartId => getField<String>('cart_id');
  set cartId(String? value) => setField<String>('cart_id', value);

  String? get primaryServiceName => getField<String>('primary_service_name');
  set primaryServiceName(String? value) =>
      setField<String>('primary_service_name', value);

  String? get primaryServiceImageUrl =>
      getField<String>('primary_service_image_url');
  set primaryServiceImageUrl(String? value) =>
      setField<String>('primary_service_image_url', value);

  String? get durationFormatted => getField<String>('duration_formatted');
  set durationFormatted(String? value) =>
      setField<String>('duration_formatted', value);

  int? get durationMinutes => getField<int>('duration_minutes');
  set durationMinutes(int? value) => setField<int>('duration_minutes', value);

  String? get tabType => getField<String>('tab_type');
  set tabType(String? value) => setField<String>('tab_type', value);

  int? get statusSequence => getField<int>('status_sequence');
  set statusSequence(int? value) => setField<int>('status_sequence', value);

  String? get accessNotes => getField<String>('access_notes');
  set accessNotes(String? value) => setField<String>('access_notes', value);

  String? get entryMethod => getField<String>('entry_method');
  set entryMethod(String? value) => setField<String>('entry_method', value);

  int? get specialistReviewsCount => getField<int>('specialist_reviews_count');
  set specialistReviewsCount(int? value) =>
      setField<int>('specialist_reviews_count', value);

  String? get specialistTitle => getField<String>('specialist_title');
  set specialistTitle(String? value) =>
      setField<String>('specialist_title', value);

  int? get experienceRating => getField<int>('experience_rating');
  set experienceRating(int? value) => setField<int>('experience_rating', value);

  String? get primaryCategoryName => getField<String>('primary_category_name');
  set primaryCategoryName(String? value) =>
      setField<String>('primary_category_name', value);

  dynamic get serviceAddons => getField<dynamic>('service_addons');
  set serviceAddons(dynamic value) =>
      setField<dynamic>('service_addons', value);
}
