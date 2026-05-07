import '../database.dart';

class BookingIntentsTable extends SupabaseTable<BookingIntentsRow> {
  @override
  String get tableName => 'booking_intents';

  @override
  BookingIntentsRow createRow(Map<String, dynamic> data) =>
      BookingIntentsRow(data);
}

class BookingIntentsRow extends SupabaseDataRow {
  BookingIntentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BookingIntentsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String get slotId => getField<String>('slot_id')!;
  set slotId(String value) => setField<String>('slot_id', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get specialistId => getField<String>('specialist_id');
  set specialistId(String? value) => setField<String>('specialist_id', value);

  DateTime? get scheduledStartAt => getField<DateTime>('scheduled_start_at');
  set scheduledStartAt(DateTime? value) =>
      setField<DateTime>('scheduled_start_at', value);

  String? get arrivalModeId => getField<String>('arrival_mode_id');
  set arrivalModeId(String? value) =>
      setField<String>('arrival_mode_id', value);

  DateTime? get scheduledEndAt => getField<DateTime>('scheduled_end_at');
  set scheduledEndAt(DateTime? value) =>
      setField<DateTime>('scheduled_end_at', value);
}
