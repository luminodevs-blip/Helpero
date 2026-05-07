import '../database.dart';

class PartnerApplicationsTable extends SupabaseTable<PartnerApplicationsRow> {
  @override
  String get tableName => 'partner_applications';

  @override
  PartnerApplicationsRow createRow(Map<String, dynamic> data) =>
      PartnerApplicationsRow(data);
}

class PartnerApplicationsRow extends SupabaseDataRow {
  PartnerApplicationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PartnerApplicationsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get fullName => getField<String>('full_name')!;
  set fullName(String value) => setField<String>('full_name', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get phoneNumber => getField<String>('phone_number');
  set phoneNumber(String? value) => setField<String>('phone_number', value);

  String? get skill => getField<String>('skill');
  set skill(String? value) => setField<String>('skill', value);

  String? get experience => getField<String>('experience');
  set experience(String? value) => setField<String>('experience', value);

  String? get transport => getField<String>('transport');
  set transport(String? value) => setField<String>('transport', value);

  List<String> get languages => getListField<String>('languages');
  set languages(List<String>? value) =>
      setListField<String>('languages', value);

  bool? get torontoResident => getField<bool>('toronto_resident');
  set torontoResident(bool? value) => setField<bool>('toronto_resident', value);

  int? get zoneId => getField<int>('zone_id');
  set zoneId(int? value) => setField<int>('zone_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get availability => getField<String>('availability');
  set availability(String? value) => setField<String>('availability', value);

  String? get tools => getField<String>('tools');
  set tools(String? value) => setField<String>('tools', value);

  String? get experiences => getField<String>('experiences');
  set experiences(String? value) => setField<String>('experiences', value);

  bool? get agreedToTerms => getField<bool>('agreed_to_terms');
  set agreedToTerms(bool? value) => setField<bool>('agreed_to_terms', value);

  String? get resumeUrl => getField<String>('resume_url');
  set resumeUrl(String? value) => setField<String>('resume_url', value);

  String? get licenseUrl => getField<String>('license_url');
  set licenseUrl(String? value) => setField<String>('license_url', value);
}
