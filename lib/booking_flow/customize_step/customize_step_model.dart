import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'customize_step_widget.dart' show CustomizeStepWidget;
import 'package:flutter/material.dart';

class CustomizeStepModel extends FlutterFlowModel<CustomizeStepWidget> {
  ///  Local state fields for this page.

  String selectedItem = '1';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - updateBookingAddon] action in Container widget.
  BookingDraftStruct? updatedDraftMinus1;
  // Stores action output result for [Custom Action - updateBookingAddon] action in Container widget.
  BookingDraftStruct? updatedDraftPlus1;
  // Stores action output result for [Custom Action - updateBookingAddon] action in Container widget.
  BookingDraftStruct? updatedDraftMinus2;
  // Stores action output result for [Custom Action - updateBookingAddon] action in Container widget.
  BookingDraftStruct? updatedDraftPlus2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
