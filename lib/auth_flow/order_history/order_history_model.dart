import '/components/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'order_history_widget.dart' show OrderHistoryWidget;
import 'package:flutter/material.dart';

class OrderHistoryModel extends FlutterFlowModel<OrderHistoryWidget> {
  ///  Local state fields for this page.

  double testProgress = 1.0;

  String activeTab = 'active';

  ///  State fields for stateful widgets in this page.

  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    navbarModel.dispose();
  }
}
