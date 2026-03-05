import '../database.dart';

class ProfilesTable extends SupabaseTable<ProfilesRow> {
  @override
  String get tableName => 'profiles';

  @override
  ProfilesRow createRow(Map<String, dynamic> data) => ProfilesRow(data);
}

class ProfilesRow extends SupabaseDataRow {
  ProfilesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProfilesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get firstName => getField<String>('first_name');
  set firstName(String? value) => setField<String>('first_name', value);

  String? get lastName => getField<String>('last_name');
  set lastName(String? value) => setField<String>('last_name', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get avatarUrl => getField<String>('avatar_url');
  set avatarUrl(String? value) => setField<String>('avatar_url', value);

  String? get phoneNumber => getField<String>('phone_number');
  set phoneNumber(String? value) => setField<String>('phone_number', value);

  DateTime? get birthdate => getField<DateTime>('birthdate');
  set birthdate(DateTime? value) => setField<DateTime>('birthdate', value);

  bool? get isPro => getField<bool>('is_pro');
  set isPro(bool? value) => setField<bool>('is_pro', value);

  bool? get darkTheme => getField<bool>('dark_theme');
  set darkTheme(bool? value) => setField<bool>('dark_theme', value);

  bool? get notificationsEnabled => getField<bool>('notifications_enabled');
  set notificationsEnabled(bool? value) =>
      setField<bool>('notifications_enabled', value);

  int? get currentHouseId => getField<int>('current_house_id');
  set currentHouseId(int? value) => setField<int>('current_house_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get role => getField<String>('role');
  set role(String? value) => setField<String>('role', value);

  String? get gender => getField<String>('gender');
  set gender(String? value) => setField<String>('gender', value);
}
