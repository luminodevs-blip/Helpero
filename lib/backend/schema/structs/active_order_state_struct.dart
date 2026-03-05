// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ActiveOrderStateStruct extends BaseStruct {
  ActiveOrderStateStruct({
    int? orderId,
    String? paymentIntentId,
    String? status,
    String? masterId,
  })  : _orderId = orderId,
        _paymentIntentId = paymentIntentId,
        _status = status,
        _masterId = masterId;

  // "orderId" field.
  int? _orderId;
  int get orderId => _orderId ?? 0;
  set orderId(int? val) => _orderId = val;

  void incrementOrderId(int amount) => orderId = orderId + amount;

  bool hasOrderId() => _orderId != null;

  // "paymentIntentId" field.
  String? _paymentIntentId;
  String get paymentIntentId => _paymentIntentId ?? '';
  set paymentIntentId(String? val) => _paymentIntentId = val;

  bool hasPaymentIntentId() => _paymentIntentId != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "masterId" field.
  String? _masterId;
  String get masterId => _masterId ?? '';
  set masterId(String? val) => _masterId = val;

  bool hasMasterId() => _masterId != null;

  static ActiveOrderStateStruct fromMap(Map<String, dynamic> data) =>
      ActiveOrderStateStruct(
        orderId: castToType<int>(data['orderId']),
        paymentIntentId: data['paymentIntentId'] as String?,
        status: data['status'] as String?,
        masterId: data['masterId'] as String?,
      );

  static ActiveOrderStateStruct? maybeFromMap(dynamic data) => data is Map
      ? ActiveOrderStateStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'orderId': _orderId,
        'paymentIntentId': _paymentIntentId,
        'status': _status,
        'masterId': _masterId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'orderId': serializeParam(
          _orderId,
          ParamType.int,
        ),
        'paymentIntentId': serializeParam(
          _paymentIntentId,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'masterId': serializeParam(
          _masterId,
          ParamType.String,
        ),
      }.withoutNulls;

  static ActiveOrderStateStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ActiveOrderStateStruct(
        orderId: deserializeParam(
          data['orderId'],
          ParamType.int,
          false,
        ),
        paymentIntentId: deserializeParam(
          data['paymentIntentId'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        masterId: deserializeParam(
          data['masterId'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ActiveOrderStateStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ActiveOrderStateStruct &&
        orderId == other.orderId &&
        paymentIntentId == other.paymentIntentId &&
        status == other.status &&
        masterId == other.masterId;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([orderId, paymentIntentId, status, masterId]);
}

ActiveOrderStateStruct createActiveOrderStateStruct({
  int? orderId,
  String? paymentIntentId,
  String? status,
  String? masterId,
}) =>
    ActiveOrderStateStruct(
      orderId: orderId,
      paymentIntentId: paymentIntentId,
      status: status,
      masterId: masterId,
    );
