import '/flutter_flow/flutter_flow_util.dart';
import 'select_country_widget.dart' show SelectCountryWidget;
import 'package:flutter/material.dart';

class SelectCountryModel extends FlutterFlowModel<SelectCountryWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for searchField widget.
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;
  String? Function(BuildContext, String?)? searchFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFieldFocusNode?.dispose();
    searchFieldTextController?.dispose();
  }
}
