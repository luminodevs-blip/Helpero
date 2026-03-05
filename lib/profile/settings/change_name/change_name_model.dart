import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'change_name_widget.dart' show ChangeNameWidget;
import 'package:flutter/material.dart';

class ChangeNameModel extends FlutterFlowModel<ChangeNameWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Firstname widget.
  FocusNode? firstnameFocusNode;
  TextEditingController? firstnameTextController;
  String? Function(BuildContext, String?)? firstnameTextControllerValidator;
  // State field(s) for Lastname widget.
  FocusNode? lastnameFocusNode;
  TextEditingController? lastnameTextController;
  String? Function(BuildContext, String?)? lastnameTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    firstnameFocusNode?.dispose();
    firstnameTextController?.dispose();

    lastnameFocusNode?.dispose();
    lastnameTextController?.dispose();
  }
}
