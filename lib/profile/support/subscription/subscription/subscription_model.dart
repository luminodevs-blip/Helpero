import '/flutter_flow/flutter_flow_util.dart';
import '/profile/support/support0/support0_widget.dart';
import '/index.dart';
import 'subscription_widget.dart' show SubscriptionWidget;
import 'package:flutter/material.dart';

class SubscriptionModel extends FlutterFlowModel<SubscriptionWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Support0 component.
  late Support0Model support0Model1;
  // Model for Support0 component.
  late Support0Model support0Model2;

  @override
  void initState(BuildContext context) {
    support0Model1 = createModel(context, () => Support0Model());
    support0Model2 = createModel(context, () => Support0Model());
  }

  @override
  void dispose() {
    support0Model1.dispose();
    support0Model2.dispose();
  }
}
