import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/booking_flow/arrival_card_loader/arrival_card_loader_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'planing_widget.dart' show PlaningWidget;
import 'package:flutter/material.dart';

class PlaningModel extends FlutterFlowModel<PlaningWidget> {
  ///  Local state fields for this page.

  bool dateSelected = false;

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

  bool isBookingLocked = false;

  bool isLoadingSlots = true;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (CheckAvailability)] action in Planing widget.
  ApiCallResponse? checkAvailability;
  // Model for ArrivalCard_Loader component.
  late ArrivalCardLoaderModel arrivalCardLoaderModel;
  // Stores action output result for [Backend Call - API (CalculateCheckout)] action in Button widget.
  ApiCallResponse? checkoutResult;

  @override
  void initState(BuildContext context) {
    arrivalCardLoaderModel =
        createModel(context, () => ArrivalCardLoaderModel());
  }

  @override
  void dispose() {
    arrivalCardLoaderModel.dispose();
  }
}
