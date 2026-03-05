import '/flutter_flow/flutter_flow_util.dart';
import '/profile/settings/contact1/contact1_widget.dart';
import '/index.dart';
import 'trusted_contacts_on_widget.dart' show TrustedContactsOnWidget;
import 'package:flutter/material.dart';

class TrustedContactsOnModel extends FlutterFlowModel<TrustedContactsOnWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Contact1 component.
  late Contact1Model contact1Model1;
  // Model for Contact1 component.
  late Contact1Model contact1Model2;

  @override
  void initState(BuildContext context) {
    contact1Model1 = createModel(context, () => Contact1Model());
    contact1Model2 = createModel(context, () => Contact1Model());
  }

  @override
  void dispose() {
    contact1Model1.dispose();
    contact1Model2.dispose();
  }
}
