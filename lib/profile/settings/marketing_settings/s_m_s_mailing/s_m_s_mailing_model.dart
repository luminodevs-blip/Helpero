import '/flutter_flow/flutter_flow_util.dart';
import '/profile/settings/settings1/settings1_widget.dart';
import '/index.dart';
import 's_m_s_mailing_widget.dart' show SMSMailingWidget;
import 'package:flutter/material.dart';

class SMSMailingModel extends FlutterFlowModel<SMSMailingWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Settings1 component.
  late Settings1Model settings1Model1;
  // Model for Settings1 component.
  late Settings1Model settings1Model2;
  // Model for Settings1 component.
  late Settings1Model settings1Model3;
  // Model for Settings1 component.
  late Settings1Model settings1Model4;
  // Model for Settings1 component.
  late Settings1Model settings1Model5;
  // Model for Settings1 component.
  late Settings1Model settings1Model6;

  @override
  void initState(BuildContext context) {
    settings1Model1 = createModel(context, () => Settings1Model());
    settings1Model2 = createModel(context, () => Settings1Model());
    settings1Model3 = createModel(context, () => Settings1Model());
    settings1Model4 = createModel(context, () => Settings1Model());
    settings1Model5 = createModel(context, () => Settings1Model());
    settings1Model6 = createModel(context, () => Settings1Model());
  }

  @override
  void dispose() {
    settings1Model1.dispose();
    settings1Model2.dispose();
    settings1Model3.dispose();
    settings1Model4.dispose();
    settings1Model5.dispose();
    settings1Model6.dispose();
  }
}
