// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ServerCheckoutStruct extends BaseStruct {
  ServerCheckoutStruct({
    double? subtotal,
    double? visitFee,
    double? bookingFee,
    double? priorityFee,
    double? highDemandFee,
    double? voucherDiscount,
    double? creditsUsed,
    double? taxAmount,
    String? taxName,
    double? totalToPay,
    String? appliedVoucherTitle,
  })  : _subtotal = subtotal,
        _visitFee = visitFee,
        _bookingFee = bookingFee,
        _priorityFee = priorityFee,
        _highDemandFee = highDemandFee,
        _voucherDiscount = voucherDiscount,
        _creditsUsed = creditsUsed,
        _taxAmount = taxAmount,
        _taxName = taxName,
        _totalToPay = totalToPay,
        _appliedVoucherTitle = appliedVoucherTitle;

  // "subtotal" field.
  double? _subtotal;
  double get subtotal => _subtotal ?? 0.0;
  set subtotal(double? val) => _subtotal = val;

  void incrementSubtotal(double amount) => subtotal = subtotal + amount;

  bool hasSubtotal() => _subtotal != null;

  // "visitFee" field.
  double? _visitFee;
  double get visitFee => _visitFee ?? 0.0;
  set visitFee(double? val) => _visitFee = val;

  void incrementVisitFee(double amount) => visitFee = visitFee + amount;

  bool hasVisitFee() => _visitFee != null;

  // "bookingFee" field.
  double? _bookingFee;
  double get bookingFee => _bookingFee ?? 0.0;
  set bookingFee(double? val) => _bookingFee = val;

  void incrementBookingFee(double amount) => bookingFee = bookingFee + amount;

  bool hasBookingFee() => _bookingFee != null;

  // "priorityFee" field.
  double? _priorityFee;
  double get priorityFee => _priorityFee ?? 0.0;
  set priorityFee(double? val) => _priorityFee = val;

  void incrementPriorityFee(double amount) =>
      priorityFee = priorityFee + amount;

  bool hasPriorityFee() => _priorityFee != null;

  // "highDemandFee" field.
  double? _highDemandFee;
  double get highDemandFee => _highDemandFee ?? 0.0;
  set highDemandFee(double? val) => _highDemandFee = val;

  void incrementHighDemandFee(double amount) =>
      highDemandFee = highDemandFee + amount;

  bool hasHighDemandFee() => _highDemandFee != null;

  // "voucherDiscount" field.
  double? _voucherDiscount;
  double get voucherDiscount => _voucherDiscount ?? 0.0;
  set voucherDiscount(double? val) => _voucherDiscount = val;

  void incrementVoucherDiscount(double amount) =>
      voucherDiscount = voucherDiscount + amount;

  bool hasVoucherDiscount() => _voucherDiscount != null;

  // "creditsUsed" field.
  double? _creditsUsed;
  double get creditsUsed => _creditsUsed ?? 0.0;
  set creditsUsed(double? val) => _creditsUsed = val;

  void incrementCreditsUsed(double amount) =>
      creditsUsed = creditsUsed + amount;

  bool hasCreditsUsed() => _creditsUsed != null;

  // "taxAmount" field.
  double? _taxAmount;
  double get taxAmount => _taxAmount ?? 0.0;
  set taxAmount(double? val) => _taxAmount = val;

  void incrementTaxAmount(double amount) => taxAmount = taxAmount + amount;

  bool hasTaxAmount() => _taxAmount != null;

  // "taxName" field.
  String? _taxName;
  String get taxName => _taxName ?? '';
  set taxName(String? val) => _taxName = val;

  bool hasTaxName() => _taxName != null;

  // "totalToPay" field.
  double? _totalToPay;
  double get totalToPay => _totalToPay ?? 0.0;
  set totalToPay(double? val) => _totalToPay = val;

  void incrementTotalToPay(double amount) => totalToPay = totalToPay + amount;

  bool hasTotalToPay() => _totalToPay != null;

  // "appliedVoucherTitle" field.
  String? _appliedVoucherTitle;
  String get appliedVoucherTitle => _appliedVoucherTitle ?? '';
  set appliedVoucherTitle(String? val) => _appliedVoucherTitle = val;

  bool hasAppliedVoucherTitle() => _appliedVoucherTitle != null;

  static ServerCheckoutStruct fromMap(Map<String, dynamic> data) =>
      ServerCheckoutStruct(
        subtotal: castToType<double>(data['subtotal']),
        visitFee: castToType<double>(data['visitFee']),
        bookingFee: castToType<double>(data['bookingFee']),
        priorityFee: castToType<double>(data['priorityFee']),
        highDemandFee: castToType<double>(data['highDemandFee']),
        voucherDiscount: castToType<double>(data['voucherDiscount']),
        creditsUsed: castToType<double>(data['creditsUsed']),
        taxAmount: castToType<double>(data['taxAmount']),
        taxName: data['taxName'] as String?,
        totalToPay: castToType<double>(data['totalToPay']),
        appliedVoucherTitle: data['appliedVoucherTitle'] as String?,
      );

  static ServerCheckoutStruct? maybeFromMap(dynamic data) => data is Map
      ? ServerCheckoutStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'subtotal': _subtotal,
        'visitFee': _visitFee,
        'bookingFee': _bookingFee,
        'priorityFee': _priorityFee,
        'highDemandFee': _highDemandFee,
        'voucherDiscount': _voucherDiscount,
        'creditsUsed': _creditsUsed,
        'taxAmount': _taxAmount,
        'taxName': _taxName,
        'totalToPay': _totalToPay,
        'appliedVoucherTitle': _appliedVoucherTitle,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'subtotal': serializeParam(
          _subtotal,
          ParamType.double,
        ),
        'visitFee': serializeParam(
          _visitFee,
          ParamType.double,
        ),
        'bookingFee': serializeParam(
          _bookingFee,
          ParamType.double,
        ),
        'priorityFee': serializeParam(
          _priorityFee,
          ParamType.double,
        ),
        'highDemandFee': serializeParam(
          _highDemandFee,
          ParamType.double,
        ),
        'voucherDiscount': serializeParam(
          _voucherDiscount,
          ParamType.double,
        ),
        'creditsUsed': serializeParam(
          _creditsUsed,
          ParamType.double,
        ),
        'taxAmount': serializeParam(
          _taxAmount,
          ParamType.double,
        ),
        'taxName': serializeParam(
          _taxName,
          ParamType.String,
        ),
        'totalToPay': serializeParam(
          _totalToPay,
          ParamType.double,
        ),
        'appliedVoucherTitle': serializeParam(
          _appliedVoucherTitle,
          ParamType.String,
        ),
      }.withoutNulls;

  static ServerCheckoutStruct fromSerializableMap(Map<String, dynamic> data) =>
      ServerCheckoutStruct(
        subtotal: deserializeParam(
          data['subtotal'],
          ParamType.double,
          false,
        ),
        visitFee: deserializeParam(
          data['visitFee'],
          ParamType.double,
          false,
        ),
        bookingFee: deserializeParam(
          data['bookingFee'],
          ParamType.double,
          false,
        ),
        priorityFee: deserializeParam(
          data['priorityFee'],
          ParamType.double,
          false,
        ),
        highDemandFee: deserializeParam(
          data['highDemandFee'],
          ParamType.double,
          false,
        ),
        voucherDiscount: deserializeParam(
          data['voucherDiscount'],
          ParamType.double,
          false,
        ),
        creditsUsed: deserializeParam(
          data['creditsUsed'],
          ParamType.double,
          false,
        ),
        taxAmount: deserializeParam(
          data['taxAmount'],
          ParamType.double,
          false,
        ),
        taxName: deserializeParam(
          data['taxName'],
          ParamType.String,
          false,
        ),
        totalToPay: deserializeParam(
          data['totalToPay'],
          ParamType.double,
          false,
        ),
        appliedVoucherTitle: deserializeParam(
          data['appliedVoucherTitle'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ServerCheckoutStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ServerCheckoutStruct &&
        subtotal == other.subtotal &&
        visitFee == other.visitFee &&
        bookingFee == other.bookingFee &&
        priorityFee == other.priorityFee &&
        highDemandFee == other.highDemandFee &&
        voucherDiscount == other.voucherDiscount &&
        creditsUsed == other.creditsUsed &&
        taxAmount == other.taxAmount &&
        taxName == other.taxName &&
        totalToPay == other.totalToPay &&
        appliedVoucherTitle == other.appliedVoucherTitle;
  }

  @override
  int get hashCode => const ListEquality().hash([
        subtotal,
        visitFee,
        bookingFee,
        priorityFee,
        highDemandFee,
        voucherDiscount,
        creditsUsed,
        taxAmount,
        taxName,
        totalToPay,
        appliedVoucherTitle
      ]);
}

ServerCheckoutStruct createServerCheckoutStruct({
  double? subtotal,
  double? visitFee,
  double? bookingFee,
  double? priorityFee,
  double? highDemandFee,
  double? voucherDiscount,
  double? creditsUsed,
  double? taxAmount,
  String? taxName,
  double? totalToPay,
  String? appliedVoucherTitle,
}) =>
    ServerCheckoutStruct(
      subtotal: subtotal,
      visitFee: visitFee,
      bookingFee: bookingFee,
      priorityFee: priorityFee,
      highDemandFee: highDemandFee,
      voucherDiscount: voucherDiscount,
      creditsUsed: creditsUsed,
      taxAmount: taxAmount,
      taxName: taxName,
      totalToPay: totalToPay,
      appliedVoucherTitle: appliedVoucherTitle,
    );
