import '/flutter_flow/flutter_flow_util.dart';
import '/profile/settings/contact/contact_widget.dart';
import 'select_contact_widget.dart' show SelectContactWidget;
import 'package:flutter/material.dart';

class SelectContactModel extends FlutterFlowModel<SelectContactWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for Contact component.
  late ContactModel contactModel1;
  // Model for Contact component.
  late ContactModel contactModel2;
  // Model for Contact component.
  late ContactModel contactModel3;

  @override
  void initState(BuildContext context) {
    contactModel1 = createModel(context, () => ContactModel());
    contactModel2 = createModel(context, () => ContactModel());
    contactModel3 = createModel(context, () => ContactModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    contactModel1.dispose();
    contactModel2.dispose();
    contactModel3.dispose();
  }
}
