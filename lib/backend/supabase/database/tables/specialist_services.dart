import '../database.dart';

class SpecialistServicesTable extends SupabaseTable<SpecialistServicesRow> {
  @override
  String get tableName => 'specialist_services';

  @override
  SpecialistServicesRow createRow(Map<String, dynamic> data) =>
      SpecialistServicesRow(data);
}

class SpecialistServicesRow extends SupabaseDataRow {
  SpecialistServicesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SpecialistServicesTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String? get specialistId => getField<String>('specialist_id');
  set specialistId(String? value) => setField<String>('specialist_id', value);

  int? get serviceId => getField<int>('service_id');
  set serviceId(int? value) => setField<int>('service_id', value);
}
