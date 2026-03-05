import '../database.dart';

class ServiceEquipmentTable extends SupabaseTable<ServiceEquipmentRow> {
  @override
  String get tableName => 'service_equipment';

  @override
  ServiceEquipmentRow createRow(Map<String, dynamic> data) =>
      ServiceEquipmentRow(data);
}

class ServiceEquipmentRow extends SupabaseDataRow {
  ServiceEquipmentRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServiceEquipmentTable();

  int get serviceId => getField<int>('service_id')!;
  set serviceId(int value) => setField<int>('service_id', value);

  String get equipmentId => getField<String>('equipment_id')!;
  set equipmentId(String value) => setField<String>('equipment_id', value);

  int? get position => getField<int>('position');
  set position(int? value) => setField<int>('position', value);
}
