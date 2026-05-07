import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'visit_time_component_copy2_widget.dart'
    show VisitTimeComponentCopy2Widget;
import 'package:flutter/material.dart';

class VisitTimeComponentCopy2Model
    extends FlutterFlowModel<VisitTimeComponentCopy2Widget> {
  ///  Local state fields for this component.

  DateTime? selectedDate;

  List<ArrivalOptionStructStruct> currentSlots = [];
  void addToCurrentSlots(ArrivalOptionStructStruct item) =>
      currentSlots.add(item);
  void removeFromCurrentSlots(ArrivalOptionStructStruct item) =>
      currentSlots.remove(item);
  void removeAtIndexFromCurrentSlots(int index) => currentSlots.removeAt(index);
  void insertAtIndexInCurrentSlots(int index, ArrivalOptionStructStruct item) =>
      currentSlots.insert(index, item);
  void updateCurrentSlotsAtIndex(
          int index, Function(ArrivalOptionStructStruct) updateFn) =>
      currentSlots[index] = updateFn(currentSlots[index]);

  ArrivalOptionStructStruct? selectedSlot;
  void updateSelectedSlotStruct(Function(ArrivalOptionStructStruct) updateFn) {
    updateFn(selectedSlot ??= ArrivalOptionStructStruct());
  }

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (CheckAvailability)] action in Container widget.
  ApiCallResponse? apiResultlox;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
