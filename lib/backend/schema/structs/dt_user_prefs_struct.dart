// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Личные предпочтения юзера
class DtUserPrefsStruct extends BaseStruct {
  DtUserPrefsStruct({
    /// В чем юзер хочет видеть цены (zł).
    String? prefCurrencySymbol,

    /// Курс (напр.
    ///
    /// 3.0).
    double? exchangeRate,

    /// Если юзер хочет м² даже в США.
    bool? forceMetric,
  })  : _prefCurrencySymbol = prefCurrencySymbol,
        _exchangeRate = exchangeRate,
        _forceMetric = forceMetric;

  // "pref_currency_symbol" field.
  String? _prefCurrencySymbol;
  String get prefCurrencySymbol => _prefCurrencySymbol ?? '';
  set prefCurrencySymbol(String? val) => _prefCurrencySymbol = val;

  bool hasPrefCurrencySymbol() => _prefCurrencySymbol != null;

  // "exchange_rate" field.
  double? _exchangeRate;
  double get exchangeRate => _exchangeRate ?? 0.0;
  set exchangeRate(double? val) => _exchangeRate = val;

  void incrementExchangeRate(double amount) =>
      exchangeRate = exchangeRate + amount;

  bool hasExchangeRate() => _exchangeRate != null;

  // "force_metric" field.
  bool? _forceMetric;
  bool get forceMetric => _forceMetric ?? false;
  set forceMetric(bool? val) => _forceMetric = val;

  bool hasForceMetric() => _forceMetric != null;

  static DtUserPrefsStruct fromMap(Map<String, dynamic> data) =>
      DtUserPrefsStruct(
        prefCurrencySymbol: data['pref_currency_symbol'] as String?,
        exchangeRate: castToType<double>(data['exchange_rate']),
        forceMetric: data['force_metric'] as bool?,
      );

  static DtUserPrefsStruct? maybeFromMap(dynamic data) => data is Map
      ? DtUserPrefsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'pref_currency_symbol': _prefCurrencySymbol,
        'exchange_rate': _exchangeRate,
        'force_metric': _forceMetric,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'pref_currency_symbol': serializeParam(
          _prefCurrencySymbol,
          ParamType.String,
        ),
        'exchange_rate': serializeParam(
          _exchangeRate,
          ParamType.double,
        ),
        'force_metric': serializeParam(
          _forceMetric,
          ParamType.bool,
        ),
      }.withoutNulls;

  static DtUserPrefsStruct fromSerializableMap(Map<String, dynamic> data) =>
      DtUserPrefsStruct(
        prefCurrencySymbol: deserializeParam(
          data['pref_currency_symbol'],
          ParamType.String,
          false,
        ),
        exchangeRate: deserializeParam(
          data['exchange_rate'],
          ParamType.double,
          false,
        ),
        forceMetric: deserializeParam(
          data['force_metric'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'DtUserPrefsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DtUserPrefsStruct &&
        prefCurrencySymbol == other.prefCurrencySymbol &&
        exchangeRate == other.exchangeRate &&
        forceMetric == other.forceMetric;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([prefCurrencySymbol, exchangeRate, forceMetric]);
}

DtUserPrefsStruct createDtUserPrefsStruct({
  String? prefCurrencySymbol,
  double? exchangeRate,
  bool? forceMetric,
}) =>
    DtUserPrefsStruct(
      prefCurrencySymbol: prefCurrencySymbol,
      exchangeRate: exchangeRate,
      forceMetric: forceMetric,
    );
