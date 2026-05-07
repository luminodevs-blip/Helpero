// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Кэш профиля в App State.
class UserProfileStruct extends BaseStruct {
  UserProfileStruct({
    /// Auth UUID
    String? id,
    String? role,
    String? email,
    String? gender,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? phoneNumber,
    List<AddressStructStruct>? savedAddresses,
    int? currentHouseId,
    DateTime? dateOfBirth,
    UserVoucherStruct? vouchersList,
  })  : _id = id,
        _role = role,
        _email = email,
        _gender = gender,
        _firstName = firstName,
        _lastName = lastName,
        _avatarUrl = avatarUrl,
        _phoneNumber = phoneNumber,
        _savedAddresses = savedAddresses,
        _currentHouseId = currentHouseId,
        _dateOfBirth = dateOfBirth,
        _vouchersList = vouchersList;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  set role(String? val) => _role = val;

  bool hasRole() => _role != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "gender" field.
  String? _gender;
  String get gender => _gender ?? '';
  set gender(String? val) => _gender = val;

  bool hasGender() => _gender != null;

  // "firstName" field.
  String? _firstName;
  String get firstName => _firstName ?? '';
  set firstName(String? val) => _firstName = val;

  bool hasFirstName() => _firstName != null;

  // "lastName" field.
  String? _lastName;
  String get lastName => _lastName ?? '';
  set lastName(String? val) => _lastName = val;

  bool hasLastName() => _lastName != null;

  // "avatarUrl" field.
  String? _avatarUrl;
  String get avatarUrl => _avatarUrl ?? '';
  set avatarUrl(String? val) => _avatarUrl = val;

  bool hasAvatarUrl() => _avatarUrl != null;

  // "phoneNumber" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  set phoneNumber(String? val) => _phoneNumber = val;

  bool hasPhoneNumber() => _phoneNumber != null;

  // "savedAddresses" field.
  List<AddressStructStruct>? _savedAddresses;
  List<AddressStructStruct> get savedAddresses => _savedAddresses ?? const [];
  set savedAddresses(List<AddressStructStruct>? val) => _savedAddresses = val;

  void updateSavedAddresses(Function(List<AddressStructStruct>) updateFn) {
    updateFn(_savedAddresses ??= []);
  }

  bool hasSavedAddresses() => _savedAddresses != null;

  // "currentHouseId" field.
  int? _currentHouseId;
  int get currentHouseId => _currentHouseId ?? 0;
  set currentHouseId(int? val) => _currentHouseId = val;

  void incrementCurrentHouseId(int amount) =>
      currentHouseId = currentHouseId + amount;

  bool hasCurrentHouseId() => _currentHouseId != null;

  // "DateOfBirth" field.
  DateTime? _dateOfBirth;
  DateTime? get dateOfBirth => _dateOfBirth;
  set dateOfBirth(DateTime? val) => _dateOfBirth = val;

  bool hasDateOfBirth() => _dateOfBirth != null;

  // "VouchersList" field.
  UserVoucherStruct? _vouchersList;
  UserVoucherStruct get vouchersList => _vouchersList ?? UserVoucherStruct();
  set vouchersList(UserVoucherStruct? val) => _vouchersList = val;

  void updateVouchersList(Function(UserVoucherStruct) updateFn) {
    updateFn(_vouchersList ??= UserVoucherStruct());
  }

  bool hasVouchersList() => _vouchersList != null;

  static UserProfileStruct fromMap(Map<String, dynamic> data) =>
      UserProfileStruct(
        id: data['id'] as String?,
        role: data['role'] as String?,
        email: data['email'] as String?,
        gender: data['gender'] as String?,
        firstName: data['firstName'] as String?,
        lastName: data['lastName'] as String?,
        avatarUrl: data['avatarUrl'] as String?,
        phoneNumber: data['phoneNumber'] as String?,
        savedAddresses: getStructList(
          data['savedAddresses'],
          AddressStructStruct.fromMap,
        ),
        currentHouseId: castToType<int>(data['currentHouseId']),
        dateOfBirth: data['DateOfBirth'] as DateTime?,
        vouchersList: data['VouchersList'] is UserVoucherStruct
            ? data['VouchersList']
            : UserVoucherStruct.maybeFromMap(data['VouchersList']),
      );

  static UserProfileStruct? maybeFromMap(dynamic data) => data is Map
      ? UserProfileStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'role': _role,
        'email': _email,
        'gender': _gender,
        'firstName': _firstName,
        'lastName': _lastName,
        'avatarUrl': _avatarUrl,
        'phoneNumber': _phoneNumber,
        'savedAddresses': _savedAddresses?.map((e) => e.toMap()).toList(),
        'currentHouseId': _currentHouseId,
        'DateOfBirth': _dateOfBirth,
        'VouchersList': _vouchersList?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'role': serializeParam(
          _role,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'gender': serializeParam(
          _gender,
          ParamType.String,
        ),
        'firstName': serializeParam(
          _firstName,
          ParamType.String,
        ),
        'lastName': serializeParam(
          _lastName,
          ParamType.String,
        ),
        'avatarUrl': serializeParam(
          _avatarUrl,
          ParamType.String,
        ),
        'phoneNumber': serializeParam(
          _phoneNumber,
          ParamType.String,
        ),
        'savedAddresses': serializeParam(
          _savedAddresses,
          ParamType.DataStruct,
          isList: true,
        ),
        'currentHouseId': serializeParam(
          _currentHouseId,
          ParamType.int,
        ),
        'DateOfBirth': serializeParam(
          _dateOfBirth,
          ParamType.DateTime,
        ),
        'VouchersList': serializeParam(
          _vouchersList,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static UserProfileStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserProfileStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        role: deserializeParam(
          data['role'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        gender: deserializeParam(
          data['gender'],
          ParamType.String,
          false,
        ),
        firstName: deserializeParam(
          data['firstName'],
          ParamType.String,
          false,
        ),
        lastName: deserializeParam(
          data['lastName'],
          ParamType.String,
          false,
        ),
        avatarUrl: deserializeParam(
          data['avatarUrl'],
          ParamType.String,
          false,
        ),
        phoneNumber: deserializeParam(
          data['phoneNumber'],
          ParamType.String,
          false,
        ),
        savedAddresses: deserializeStructParam<AddressStructStruct>(
          data['savedAddresses'],
          ParamType.DataStruct,
          true,
          structBuilder: AddressStructStruct.fromSerializableMap,
        ),
        currentHouseId: deserializeParam(
          data['currentHouseId'],
          ParamType.int,
          false,
        ),
        dateOfBirth: deserializeParam(
          data['DateOfBirth'],
          ParamType.DateTime,
          false,
        ),
        vouchersList: deserializeStructParam(
          data['VouchersList'],
          ParamType.DataStruct,
          false,
          structBuilder: UserVoucherStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'UserProfileStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is UserProfileStruct &&
        id == other.id &&
        role == other.role &&
        email == other.email &&
        gender == other.gender &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        avatarUrl == other.avatarUrl &&
        phoneNumber == other.phoneNumber &&
        listEquality.equals(savedAddresses, other.savedAddresses) &&
        currentHouseId == other.currentHouseId &&
        dateOfBirth == other.dateOfBirth &&
        vouchersList == other.vouchersList;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        role,
        email,
        gender,
        firstName,
        lastName,
        avatarUrl,
        phoneNumber,
        savedAddresses,
        currentHouseId,
        dateOfBirth,
        vouchersList
      ]);
}

UserProfileStruct createUserProfileStruct({
  String? id,
  String? role,
  String? email,
  String? gender,
  String? firstName,
  String? lastName,
  String? avatarUrl,
  String? phoneNumber,
  int? currentHouseId,
  DateTime? dateOfBirth,
  UserVoucherStruct? vouchersList,
}) =>
    UserProfileStruct(
      id: id,
      role: role,
      email: email,
      gender: gender,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
      currentHouseId: currentHouseId,
      dateOfBirth: dateOfBirth,
      vouchersList: vouchersList ?? UserVoucherStruct(),
    );
