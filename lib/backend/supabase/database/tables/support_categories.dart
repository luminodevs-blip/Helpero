import '../database.dart';

class SupportCategoriesTable extends SupabaseTable<SupportCategoriesRow> {
  @override
  String get tableName => 'support_categories';

  @override
  SupportCategoriesRow createRow(Map<String, dynamic> data) =>
      SupportCategoriesRow(data);
}

class SupportCategoriesRow extends SupabaseDataRow {
  SupportCategoriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SupportCategoriesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get icon => getField<String>('icon');
  set icon(String? value) => setField<String>('icon', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
