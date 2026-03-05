import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'your_suggestions_widget.dart' show YourSuggestionsWidget;
import 'package:flutter/material.dart';

class YourSuggestionsModel extends FlutterFlowModel<YourSuggestionsWidget> {
  ///  Local state fields for this page.

  String? choosed;

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
