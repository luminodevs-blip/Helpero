import '/flutter_flow/flutter_flow_util.dart';
import '/profile/settings/settings0/settings0_widget.dart';
import '/index.dart';
import 'communication_widget.dart' show CommunicationWidget;
import 'package:flutter/material.dart';

class CommunicationModel extends FlutterFlowModel<CommunicationWidget> {
  ///  Local state fields for this page.

  String choosed = 'Call & chat';

  ///  State fields for stateful widgets in this page.

  // Model for Settings0 component.
  late Settings0Model settings0Model1;
  // Model for Settings0 component.
  late Settings0Model settings0Model2;
  // Model for Settings0 component.
  late Settings0Model settings0Model3;

  @override
  void initState(BuildContext context) {
    settings0Model1 = createModel(context, () => Settings0Model());
    settings0Model2 = createModel(context, () => Settings0Model());
    settings0Model3 = createModel(context, () => Settings0Model());
  }

  @override
  void dispose() {
    settings0Model1.dispose();
    settings0Model2.dispose();
    settings0Model3.dispose();
  }
}
