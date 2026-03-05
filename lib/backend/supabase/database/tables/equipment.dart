import '../database.dart';

class EquipmentTable extends SupabaseTable<EquipmentRow> {
  @override
  String get tableName => 'equipment';

  @override
  EquipmentRow createRow(Map<String, dynamic> data) => EquipmentRow(data);
}

class EquipmentRow extends SupabaseDataRow {
  EquipmentRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => EquipmentTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
