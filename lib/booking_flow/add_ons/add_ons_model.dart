import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'add_ons_widget.dart' show AddOnsWidget;
import 'package:flutter/material.dart';

class AddOnsModel extends FlutterFlowModel<AddOnsWidget> {
  ///  Local state fields for this page.

  int addon1 = 0;

  int addon2 = 0;

  int addon3 = 0;

  int addon4 = 0;

  int addon5 = 0;

  int addon6 = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - updateBookingAddon] action in Container widget.
  BookingDraftStruct? updatedDraftMinus1;
  // Stores action output result for [Custom Action - updateBookingAddon] action in Container widget.
  BookingDraftStruct? updatedDraftPlus1;
  // Stores action output result for [Backend Call - API (SyncCart)] action in Button widget.
  ApiCallResponse? syncCart;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
