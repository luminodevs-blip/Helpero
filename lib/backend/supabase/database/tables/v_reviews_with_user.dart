import '../database.dart';

class VReviewsWithUserTable extends SupabaseTable<VReviewsWithUserRow> {
  @override
  String get tableName => 'v_reviews_with_user';

  @override
  VReviewsWithUserRow createRow(Map<String, dynamic> data) =>
      VReviewsWithUserRow(data);
}

class VReviewsWithUserRow extends SupabaseDataRow {
  VReviewsWithUserRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VReviewsWithUserTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  int? get serviceId => getField<int>('service_id');
  set serviceId(int? value) => setField<int>('service_id', value);

  int? get orderId => getField<int>('order_id');
  set orderId(int? value) => setField<int>('order_id', value);

  int? get rating => getField<int>('rating');
  set rating(int? value) => setField<int>('rating', value);

  String? get comment => getField<String>('comment');
  set comment(String? value) => setField<String>('comment', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  dynamic get photos => getField<dynamic>('photos');
  set photos(dynamic value) => setField<dynamic>('photos', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);

  String? get avatarUrl => getField<String>('avatar_url');
  set avatarUrl(String? value) => setField<String>('avatar_url', value);

  int? get durationMinutes => getField<int>('duration_minutes');
  set durationMinutes(int? value) => setField<int>('duration_minutes', value);
}
