import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'visit_time_component_widget.dart' show VisitTimeComponentWidget;
import 'package:flutter/material.dart';

class VisitTimeComponentModel
    extends FlutterFlowModel<VisitTimeComponentWidget> {
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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
