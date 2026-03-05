import '/flutter_flow/flutter_flow_util.dart';
import 'address_autocomplete_copy_widget.dart'
    show AddressAutocompleteCopyWidget;
import 'package:flutter/material.dart';

class AddressAutocompleteCopyModel
    extends FlutterFlowModel<AddressAutocompleteCopyWidget> {
  ///  Local state fields for this component.

  bool typeText = false;

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
