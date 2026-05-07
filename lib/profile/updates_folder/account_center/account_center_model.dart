import '/flutter_flow/flutter_flow_util.dart';
import '/profile/settings/settings0/settings0_widget.dart';
import '/index.dart';
import 'account_center_widget.dart' show AccountCenterWidget;
import 'package:flutter/material.dart';

class AccountCenterModel extends FlutterFlowModel<AccountCenterWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Settings0 component.
  late Settings0Model settings0Model;

  @override
  void initState(BuildContext context) {
    settings0Model = createModel(context, () => Settings0Model());
  }

  @override
  void dispose() {
    settings0Model.dispose();
  }
}
