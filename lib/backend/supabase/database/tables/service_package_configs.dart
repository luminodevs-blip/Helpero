import '../database.dart';

class ServicePackageConfigsTable
    extends SupabaseTable<ServicePackageConfigsRow> {
  @override
  String get tableName => 'service_package_configs';

  @override
  ServicePackageConfigsRow createRow(Map<String, dynamic> data) =>
      ServicePackageConfigsRow(data);
}

class ServicePackageConfigsRow extends SupabaseDataRow {
  ServicePackageConfigsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServicePackageConfigsTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  int? get serviceId => getField<int>('service_id');
  set serviceId(int? value) => setField<int>('service_id', value);

  int? get taskId => getField<int>('task_id');
  set taskId(int? value) => setField<int>('task_id', value);

  bool? get isIncluded => getField<bool>('is_included');
  set isIncluded(bool? value) => setField<bool>('is_included', value);

  String? get pricingModel => getField<String>('pricing_model');
  set pricingModel(String? value) => setField<String>('pricing_model', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);
}
