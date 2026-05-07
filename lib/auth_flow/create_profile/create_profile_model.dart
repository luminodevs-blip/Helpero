import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'create_profile_widget.dart' show CreateProfileWidget;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CreateProfileModel extends FlutterFlowModel<CreateProfileWidget> {
  ///  Local state fields for this page.

  String? name;

  String? lastname;

  bool verify = false;

  bool isPhoneVerified = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - Query Rows] action in createProfile widget.
  List<ProfilesRow>? userRow;
  // State field(s) for NameField widget.
  FocusNode? nameFieldFocusNode;
  TextEditingController? nameFieldTextController;
  String? Function(BuildContext, String?)? nameFieldTextControllerValidator;
  String? _nameFieldTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Name is required';
    }

    return null;
  }

  // State field(s) for LastNameField widget.
  FocusNode? lastNameFieldFocusNode;
  TextEditingController? lastNameFieldTextController;
  String? Function(BuildContext, String?)? lastNameFieldTextControllerValidator;
  String? _lastNameFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Lastname is required';
    }

    return null;
  }

  // State field(s) for emailField widget.
  FocusNode? emailFieldFocusNode;
  TextEditingController? emailFieldTextController;
  String? Function(BuildContext, String?)? emailFieldTextControllerValidator;
  String? _emailFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for PhoneField widget.
  FocusNode? phoneFieldFocusNode;
  TextEditingController? phoneFieldTextController;
  late MaskTextInputFormatter phoneFieldMask;
  String? Function(BuildContext, String?)? phoneFieldTextControllerValidator;
  String? _phoneFieldTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Phone number is required';
    }

    return null;
  }

  // Stores action output result for [Backend Call - API (UpdateUserPhone)] action in Button widget.
  ApiCallResponse? apiResult63y;
  // State field(s) for PhoneOtpField widget.
  FocusNode? phoneOtpFieldFocusNode;
  TextEditingController? phoneOtpFieldTextController;
  String? Function(BuildContext, String?)? phoneOtpFieldTextControllerValidator;
  // Stores action output result for [Backend Call - API (VerifyPhoneOTP)] action in PhoneOtpField widget.
  ApiCallResponse? apiResult5gx;
  // State field(s) for Timer widget.
  final timerInitialTimeMs = 60000;
  int timerMilliseconds = 60000;
  String timerValue = StopWatchTimer.getDisplayTime(
    60000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  // Stores action output result for [Backend Call - Update Row(s)] action in Button widget.
  List<ProfilesRow>? profile;

  @override
  void initState(BuildContext context) {
    nameFieldTextControllerValidator = _nameFieldTextControllerValidator;
    lastNameFieldTextControllerValidator =
        _lastNameFieldTextControllerValidator;
    emailFieldTextControllerValidator = _emailFieldTextControllerValidator;
    phoneFieldTextControllerValidator = _phoneFieldTextControllerValidator;
  }

  @override
  void dispose() {
    nameFieldFocusNode?.dispose();
    nameFieldTextController?.dispose();

    lastNameFieldFocusNode?.dispose();
    lastNameFieldTextController?.dispose();

    emailFieldFocusNode?.dispose();
    emailFieldTextController?.dispose();

    phoneFieldFocusNode?.dispose();
    phoneFieldTextController?.dispose();

    phoneOtpFieldFocusNode?.dispose();
    phoneOtpFieldTextController?.dispose();

    timerController.dispose();
  }
}
