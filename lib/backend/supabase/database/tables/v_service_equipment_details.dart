import '../database.dart';

class VServiceEquipmentDetailsTable
    extends SupabaseTable<VServiceEquipmentDetailsRow> {
  @override
  String get tableName => 'v_service_equipment_details';

  @override
  VServiceEquipmentDetailsRow createRow(Map<String, dynamic> data) =>
      VServiceEquipmentDetailsRow(data);
}

class VServiceEquipmentDetailsRow extends SupabaseDataRow {
  VServiceEquipmentDetailsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VServiceEquipmentDetailsTable();

  int? get serviceId => getField<int>('service_id');
  set serviceId(int? value) => setField<int>('service_id', value);

  int? get position => getField<int>('position');
  set position(int? value) => setField<int>('position', value);

  String? get equipmentId => getField<String>('equipment_id');
  set equipmentId(String? value) => setField<String>('equipment_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get imageUrl => getField<String>('image_url');
  set imageUrl(String? value) => setField<String>('image_url', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);
}
