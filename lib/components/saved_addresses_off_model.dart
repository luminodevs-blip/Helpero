import '/flutter_flow/flutter_flow_util.dart';
import 'saved_addresses_off_widget.dart' show SavedAddressesOffWidget;
import 'package:flutter/material.dart';

class SavedAddressesOffModel extends FlutterFlowModel<SavedAddressesOffWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
