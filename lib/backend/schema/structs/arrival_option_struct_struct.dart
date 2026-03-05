// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ArrivalOptionStructStruct extends BaseStruct {
  ArrivalOptionStructStruct({
    String? mode,
    String? timeStart,

    /// Время окончания окна (может быть null для 'scheduled').
    String? timeEnd,
    double? fee,
    bool? isGolden,

    /// Краткий текст, например: "Fastest arrival".
    String? reason,
    String? displayDate,
    String? displayTime,
    String? id,
  })  : _mode = mode,
        _timeStart = timeStart,
        _timeEnd = timeEnd,
        _fee = fee,
        _isGolden = isGolden,
        _reason = reason,
        _displayDate = displayDate,
        _displayTime = displayTime,
        _id = id;

  // "mode" field.
  String? _mode;
  String get mode => _mode ?? 'standard';
  set mode(String? val) => _mode = val;

  bool hasMode() => _mode != null;

  // "timeStart" field.
  String? _timeStart;
  String get timeStart => _timeStart ?? '';
  set timeStart(String? val) => _timeStart = val;

  bool hasTimeStart() => _timeStart != null;

  // "timeEnd" field.
  String? _timeEnd;
  String get timeEnd => _timeEnd ?? '';
  set timeEnd(String? val) => _timeEnd = val;

  bool hasTimeEnd() => _timeEnd != null;

  // "fee" field.
  double? _fee;
  double get fee => _fee ?? 0.0;
  set fee(double? val) => _fee = val;

  void incrementFee(double amount) => fee = fee + amount;

  bool hasFee() => _fee != null;

  // "isGolden" field.
  bool? _isGolden;
  bool get isGolden => _isGolden ?? false;
  set isGolden(bool? val) => _isGolden = val;

  bool hasIsGolden() => _isGolden != null;

  // "reason" field.
  String? _reason;
  String get reason => _reason ?? '';
  set reason(String? val) => _reason = val;

  bool hasReason() => _reason != null;

  // "displayDate" field.
  String? _displayDate;
  String get displayDate => _displayDate ?? '';
  set displayDate(String? val) => _displayDate = val;

  bool hasDisplayDate() => _displayDate != null;

  // "displayTime" field.
  String? _displayTime;
  String get displayTime => _displayTime ?? '';
  set displayTime(String? val) => _displayTime = val;

  bool hasDisplayTime() => _displayTime != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  static ArrivalOptionStructStruct fromMap(Map<String, dynamic> data) =>
      ArrivalOptionStructStruct(
        mode: data['mode'] as String?,
        timeStart: data['timeStart'] as String?,
        timeEnd: data['timeEnd'] as String?,
        fee: castToType<double>(data['fee']),
        isGolden: data['isGolden'] as bool?,
        reason: data['reason'] as String?,
        displayDate: data['displayDate'] as String?,
        displayTime: data['displayTime'] as String?,
        id: data['id'] as String?,
      );

  static ArrivalOptionStructStruct? maybeFromMap(dynamic data) => data is Map
      ? ArrivalOptionStructStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'mode': _mode,
        'timeStart': _timeStart,
        'timeEnd': _timeEnd,
        'fee': _fee,
        'isGolden': _isGolden,
        'reason': _reason,
        'displayDate': _displayDate,
        'displayTime': _displayTime,
        'id': _id,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'mode': serializeParam(
          _mode,
          ParamType.String,
        ),
        'timeStart': serializeParam(
          _timeStart,
          ParamType.String,
        ),
        'timeEnd': serializeParam(
          _timeEnd,
          ParamType.String,
        ),
        'fee': serializeParam(
          _fee,
          ParamType.double,
        ),
        'isGolden': serializeParam(
          _isGolden,
          ParamType.bool,
        ),
        'reason': serializeParam(
          _reason,
          ParamType.String,
        ),
        'displayDate': serializeParam(
          _displayDate,
          ParamType.String,
        ),
        'displayTime': serializeParam(
          _displayTime,
          ParamType.String,
        ),
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
      }.withoutNulls;

  static ArrivalOptionStructStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ArrivalOptionStructStruct(
        mode: deserializeParam(
          data['mode'],
          ParamType.String,
          false,
        ),
        timeStart: deserializeParam(
          data['timeStart'],
          ParamType.String,
          false,
        ),
        timeEnd: deserializeParam(
          data['timeEnd'],
          ParamType.String,
          false,
        ),
        fee: deserializeParam(
          data['fee'],
          ParamType.double,
          false,
        ),
        isGolden: deserializeParam(
          data['isGolden'],
          ParamType.bool,
          false,
        ),
        reason: deserializeParam(
          data['reason'],
          ParamType.String,
          false,
        ),
        displayDate: deserializeParam(
          data['displayDate'],
          ParamType.String,
          false,
        ),
        displayTime: deserializeParam(
          data['displayTime'],
          ParamType.String,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ArrivalOptionStructStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ArrivalOptionStructStruct &&
        mode == other.mode &&
        timeStart == other.timeStart &&
        timeEnd == other.timeEnd &&
        fee == other.fee &&
        isGolden == other.isGolden &&
        reason == other.reason &&
        displayDate == other.displayDate &&
        displayTime == other.displayTime &&
        id == other.id;
  }

  @override
  int get hashCode => const ListEquality().hash([
        mode,
        timeStart,
        timeEnd,
        fee,
        isGolden,
        reason,
        displayDate,
        displayTime,
        id
      ]);
}

ArrivalOptionStructStruct createArrivalOptionStructStruct({
  String? mode,
  String? timeStart,
  String? timeEnd,
  double? fee,
  bool? isGolden,
  String? reason,
  String? displayDate,
  String? displayTime,
  String? id,
}) =>
    ArrivalOptionStructStruct(
      mode: mode,
      timeStart: timeStart,
      timeEnd: timeEnd,
      fee: fee,
      isGolden: isGolden,
      reason: reason,
      displayDate: displayDate,
      displayTime: displayTime,
      id: id,
    );
