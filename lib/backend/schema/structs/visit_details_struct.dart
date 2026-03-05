// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// тип данных для времени, адреса и способа входа в дом клиента.
class VisitDetailsStruct extends BaseStruct {
  VisitDetailsStruct({
    String? id,

    /// хранит 'priority', 'standard' или 'scheduled'
    String? mode,

    /// день визита
    DateTime? arrivalDate,
    String? arrivalDateDisplay,
    String? arrivalTimeDisplay,

    /// текст интервала, например "17:05-17:11"
    String? arrivalTimeSlot,

    /// сам объект адреса
    AddressStructStruct? address,

    /// способ входа (например, 'meet_at_door')
    String? entryMethod,

    /// комментарий для специалиста
    String? entryNotes,
  })  : _id = id,
        _mode = mode,
        _arrivalDate = arrivalDate,
        _arrivalDateDisplay = arrivalDateDisplay,
        _arrivalTimeDisplay = arrivalTimeDisplay,
        _arrivalTimeSlot = arrivalTimeSlot,
        _address = address,
        _entryMethod = entryMethod,
        _entryNotes = entryNotes;

  // "Id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "mode" field.
  String? _mode;
  String get mode => _mode ?? '';
  set mode(String? val) => _mode = val;

  bool hasMode() => _mode != null;

  // "arrivalDate" field.
  DateTime? _arrivalDate;
  DateTime? get arrivalDate => _arrivalDate;
  set arrivalDate(DateTime? val) => _arrivalDate = val;

  bool hasArrivalDate() => _arrivalDate != null;

  // "arrivalDateDisplay" field.
  String? _arrivalDateDisplay;
  String get arrivalDateDisplay => _arrivalDateDisplay ?? '';
  set arrivalDateDisplay(String? val) => _arrivalDateDisplay = val;

  bool hasArrivalDateDisplay() => _arrivalDateDisplay != null;

  // "arrivalTimeDisplay" field.
  String? _arrivalTimeDisplay;
  String get arrivalTimeDisplay => _arrivalTimeDisplay ?? '';
  set arrivalTimeDisplay(String? val) => _arrivalTimeDisplay = val;

  bool hasArrivalTimeDisplay() => _arrivalTimeDisplay != null;

  // "arrivalTimeSlot" field.
  String? _arrivalTimeSlot;
  String get arrivalTimeSlot => _arrivalTimeSlot ?? '';
  set arrivalTimeSlot(String? val) => _arrivalTimeSlot = val;

  bool hasArrivalTimeSlot() => _arrivalTimeSlot != null;

  // "address" field.
  AddressStructStruct? _address;
  AddressStructStruct get address => _address ?? AddressStructStruct();
  set address(AddressStructStruct? val) => _address = val;

  void updateAddress(Function(AddressStructStruct) updateFn) {
    updateFn(_address ??= AddressStructStruct());
  }

  bool hasAddress() => _address != null;

  // "entryMethod" field.
  String? _entryMethod;
  String get entryMethod => _entryMethod ?? '';
  set entryMethod(String? val) => _entryMethod = val;

  bool hasEntryMethod() => _entryMethod != null;

  // "entryNotes" field.
  String? _entryNotes;
  String get entryNotes => _entryNotes ?? '';
  set entryNotes(String? val) => _entryNotes = val;

  bool hasEntryNotes() => _entryNotes != null;

  static VisitDetailsStruct fromMap(Map<String, dynamic> data) =>
      VisitDetailsStruct(
        id: data['Id'] as String?,
        mode: data['mode'] as String?,
        arrivalDate: data['arrivalDate'] as DateTime?,
        arrivalDateDisplay: data['arrivalDateDisplay'] as String?,
        arrivalTimeDisplay: data['arrivalTimeDisplay'] as String?,
        arrivalTimeSlot: data['arrivalTimeSlot'] as String?,
        address: data['address'] is AddressStructStruct
            ? data['address']
            : AddressStructStruct.maybeFromMap(data['address']),
        entryMethod: data['entryMethod'] as String?,
        entryNotes: data['entryNotes'] as String?,
      );

  static VisitDetailsStruct? maybeFromMap(dynamic data) => data is Map
      ? VisitDetailsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'Id': _id,
        'mode': _mode,
        'arrivalDate': _arrivalDate,
        'arrivalDateDisplay': _arrivalDateDisplay,
        'arrivalTimeDisplay': _arrivalTimeDisplay,
        'arrivalTimeSlot': _arrivalTimeSlot,
        'address': _address?.toMap(),
        'entryMethod': _entryMethod,
        'entryNotes': _entryNotes,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Id': serializeParam(
          _id,
          ParamType.String,
        ),
        'mode': serializeParam(
          _mode,
          ParamType.String,
        ),
        'arrivalDate': serializeParam(
          _arrivalDate,
          ParamType.DateTime,
        ),
        'arrivalDateDisplay': serializeParam(
          _arrivalDateDisplay,
          ParamType.String,
        ),
        'arrivalTimeDisplay': serializeParam(
          _arrivalTimeDisplay,
          ParamType.String,
        ),
        'arrivalTimeSlot': serializeParam(
          _arrivalTimeSlot,
          ParamType.String,
        ),
        'address': serializeParam(
          _address,
          ParamType.DataStruct,
        ),
        'entryMethod': serializeParam(
          _entryMethod,
          ParamType.String,
        ),
        'entryNotes': serializeParam(
          _entryNotes,
          ParamType.String,
        ),
      }.withoutNulls;

  static VisitDetailsStruct fromSerializableMap(Map<String, dynamic> data) =>
      VisitDetailsStruct(
        id: deserializeParam(
          data['Id'],
          ParamType.String,
          false,
        ),
        mode: deserializeParam(
          data['mode'],
          ParamType.String,
          false,
        ),
        arrivalDate: deserializeParam(
          data['arrivalDate'],
          ParamType.DateTime,
          false,
        ),
        arrivalDateDisplay: deserializeParam(
          data['arrivalDateDisplay'],
          ParamType.String,
          false,
        ),
        arrivalTimeDisplay: deserializeParam(
          data['arrivalTimeDisplay'],
          ParamType.String,
          false,
        ),
        arrivalTimeSlot: deserializeParam(
          data['arrivalTimeSlot'],
          ParamType.String,
          false,
        ),
        address: deserializeStructParam(
          data['address'],
          ParamType.DataStruct,
          false,
          structBuilder: AddressStructStruct.fromSerializableMap,
        ),
        entryMethod: deserializeParam(
          data['entryMethod'],
          ParamType.String,
          false,
        ),
        entryNotes: deserializeParam(
          data['entryNotes'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'VisitDetailsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is VisitDetailsStruct &&
        id == other.id &&
        mode == other.mode &&
        arrivalDate == other.arrivalDate &&
        arrivalDateDisplay == other.arrivalDateDisplay &&
        arrivalTimeDisplay == other.arrivalTimeDisplay &&
        arrivalTimeSlot == other.arrivalTimeSlot &&
        address == other.address &&
        entryMethod == other.entryMethod &&
        entryNotes == other.entryNotes;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        mode,
        arrivalDate,
        arrivalDateDisplay,
        arrivalTimeDisplay,
        arrivalTimeSlot,
        address,
        entryMethod,
        entryNotes
      ]);
}

VisitDetailsStruct createVisitDetailsStruct({
  String? id,
  String? mode,
  DateTime? arrivalDate,
  String? arrivalDateDisplay,
  String? arrivalTimeDisplay,
  String? arrivalTimeSlot,
  AddressStructStruct? address,
  String? entryMethod,
  String? entryNotes,
}) =>
    VisitDetailsStruct(
      id: id,
      mode: mode,
      arrivalDate: arrivalDate,
      arrivalDateDisplay: arrivalDateDisplay,
      arrivalTimeDisplay: arrivalTimeDisplay,
      arrivalTimeSlot: arrivalTimeSlot,
      address: address ?? AddressStructStruct(),
      entryMethod: entryMethod,
      entryNotes: entryNotes,
    );
