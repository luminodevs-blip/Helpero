import '/flutter_flow/flutter_flow_util.dart';
import '/profile/support/support0/support0_widget.dart';
import '/index.dart';
import 'booking_widget.dart' show BookingWidget;
import 'package:flutter/material.dart';

class BookingModel extends FlutterFlowModel<BookingWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Support0 component.
  late Support0Model support0Model1;
  // Model for Support0 component.
  late Support0Model support0Model2;
  // Model for Support0 component.
  late Support0Model support0Model3;
  // Model for Support0 component.
  late Support0Model support0Model4;
  // Model for Support0 component.
  late Support0Model support0Model5;

  @override
  void initState(BuildContext context) {
    support0Model1 = createModel(context, () => Support0Model());
    support0Model2 = createModel(context, () => Support0Model());
    support0Model3 = createModel(context, () => Support0Model());
    support0Model4 = createModel(context, () => Support0Model());
    support0Model5 = createModel(context, () => Support0Model());
  }

  @override
  void dispose() {
    support0Model1.dispose();
    support0Model2.dispose();
    support0Model3.dispose();
    support0Model4.dispose();
    support0Model5.dispose();
  }
}
