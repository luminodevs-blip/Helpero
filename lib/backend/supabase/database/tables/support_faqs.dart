import '../database.dart';

class SupportFaqsTable extends SupabaseTable<SupportFaqsRow> {
  @override
  String get tableName => 'support_faqs';

  @override
  SupportFaqsRow createRow(Map<String, dynamic> data) => SupportFaqsRow(data);
}

class SupportFaqsRow extends SupabaseDataRow {
  SupportFaqsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SupportFaqsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get categoryId => getField<String>('category_id');
  set categoryId(String? value) => setField<String>('category_id', value);

  String get question => getField<String>('question')!;
  set question(String value) => setField<String>('question', value);

  String get answer => getField<String>('answer')!;
  set answer(String value) => setField<String>('answer', value);

  bool? get isPopular => getField<bool>('is_popular');
  set isPopular(bool? value) => setField<bool>('is_popular', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
