import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'voucherscopyy_widget.dart' show VoucherscopyyWidget;
import 'package:flutter/material.dart';

class VoucherscopyyModel extends FlutterFlowModel<VoucherscopyyWidget> {
  ///  Local state fields for this page.

  bool isExpanded = false;

  ///  State fields for stateful widgets in this page.

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
