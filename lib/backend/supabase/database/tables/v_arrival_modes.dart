import '../database.dart';

class VArrivalModesTable extends SupabaseTable<VArrivalModesRow> {
  @override
  String get tableName => 'v_arrival_modes';

  @override
  VArrivalModesRow createRow(Map<String, dynamic> data) =>
      VArrivalModesRow(data);
}

class VArrivalModesRow extends SupabaseDataRow {
  VArrivalModesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VArrivalModesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get slug => getField<String>('slug');
  set slug(String? value) => setField<String>('slug', value);

  double? get fee => getField<double>('fee');
  set fee(double? value) => setField<double>('fee', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);
}
