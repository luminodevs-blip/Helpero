// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SupportMessageStruct extends BaseStruct {
  SupportMessageStruct({
    String? text,
    bool? isUser,
    String? type,
    String? faqList,
    List<String>? options,
  })  : _text = text,
        _isUser = isUser,
        _type = type,
        _faqList = faqList,
        _options = options;

  // "Text" field.
  String? _text;
  String get text => _text ?? '';
  set text(String? val) => _text = val;

  bool hasText() => _text != null;

  // "isUser" field.
  bool? _isUser;
  bool get isUser => _isUser ?? false;
  set isUser(bool? val) => _isUser = val;

  bool hasIsUser() => _isUser != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "faq_list" field.
  String? _faqList;
  String get faqList => _faqList ?? '';
  set faqList(String? val) => _faqList = val;

  bool hasFaqList() => _faqList != null;

  // "options" field.
  List<String>? _options;
  List<String> get options => _options ?? const [];
  set options(List<String>? val) => _options = val;

  void updateOptions(Function(List<String>) updateFn) {
    updateFn(_options ??= []);
  }

  bool hasOptions() => _options != null;

  static SupportMessageStruct fromMap(Map<String, dynamic> data) =>
      SupportMessageStruct(
        text: data['Text'] as String?,
        isUser: data['isUser'] as bool?,
        type: data['type'] as String?,
        faqList: data['faq_list'] as String?,
        options: getDataList(data['options']),
      );

  static SupportMessageStruct? maybeFromMap(dynamic data) => data is Map
      ? SupportMessageStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'Text': _text,
        'isUser': _isUser,
        'type': _type,
        'faq_list': _faqList,
        'options': _options,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Text': serializeParam(
          _text,
          ParamType.String,
        ),
        'isUser': serializeParam(
          _isUser,
          ParamType.bool,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'faq_list': serializeParam(
          _faqList,
          ParamType.String,
        ),
        'options': serializeParam(
          _options,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static SupportMessageStruct fromSerializableMap(Map<String, dynamic> data) =>
      SupportMessageStruct(
        text: deserializeParam(
          data['Text'],
          ParamType.String,
          false,
        ),
        isUser: deserializeParam(
          data['isUser'],
          ParamType.bool,
          false,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        faqList: deserializeParam(
          data['faq_list'],
          ParamType.String,
          false,
        ),
        options: deserializeParam<String>(
          data['options'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'SupportMessageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SupportMessageStruct &&
        text == other.text &&
        isUser == other.isUser &&
        type == other.type &&
        faqList == other.faqList &&
        listEquality.equals(options, other.options);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([text, isUser, type, faqList, options]);
}

SupportMessageStruct createSupportMessageStruct({
  String? text,
  bool? isUser,
  String? type,
  String? faqList,
}) =>
    SupportMessageStruct(
      text: text,
      isUser: isUser,
      type: type,
      faqList: faqList,
    );
