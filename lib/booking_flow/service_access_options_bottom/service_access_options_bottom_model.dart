import '/flutter_flow/flutter_flow_util.dart';
import 'service_access_options_bottom_widget.dart'
    show ServiceAccessOptionsBottomWidget;
import 'package:flutter/material.dart';

class ServiceAccessOptionsBottomModel
    extends FlutterFlowModel<ServiceAccessOptionsBottomWidget> {
  ///  Local state fields for this component.

  int activeChoise = 1;

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
