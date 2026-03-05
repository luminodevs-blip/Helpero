import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/updates_folder/add_property_complete/add_property_complete_widget.dart';
import '/index.dart';
import 'add_property_widget.dart' show AddPropertyWidget;
import 'package:flutter/material.dart';

class AddPropertyModel extends FlutterFlowModel<AddPropertyWidget> {
  ///  Local state fields for this page.

  String buildingType = 'House';

  bool isEditing = false;

  bool completeBanner = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for name_label widget.
  FocusNode? nameLabelFocusNode;
  TextEditingController? nameLabelTextController;
  String? Function(BuildContext, String?)? nameLabelTextControllerValidator;
  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // State field(s) for Address widget.
  FocusNode? addressFocusNode;
  TextEditingController? addressTextController;
  String? Function(BuildContext, String?)? addressTextControllerValidator;
  // State field(s) for floor widget.
  FocusNode? floorFocusNode1;
  TextEditingController? floorTextController1;
  String? Function(BuildContext, String?)? floorTextController1Validator;
  // State field(s) for unitApt widget.
  FocusNode? unitAptFocusNode;
  TextEditingController? unitAptTextController;
  String? Function(BuildContext, String?)? unitAptTextControllerValidator;
  // State field(s) for number widget.
  FocusNode? numberFocusNode;
  TextEditingController? numberTextController;
  String? Function(BuildContext, String?)? numberTextControllerValidator;
  // State field(s) for floor widget.
  FocusNode? floorFocusNode2;
  TextEditingController? floorTextController2;
  String? Function(BuildContext, String?)? floorTextController2Validator;
  // State field(s) for floor widget.
  FocusNode? floorFocusNode3;
  TextEditingController? floorTextController3;
  String? Function(BuildContext, String?)? floorTextController3Validator;
  // State field(s) for gateCode widget.
  FocusNode? gateCodeFocusNode;
  TextEditingController? gateCodeTextController;
  String? Function(BuildContext, String?)? gateCodeTextControllerValidator;
  // State field(s) for instructions widget.
  FocusNode? instructionsFocusNode;
  TextEditingController? instructionsTextController;
  String? Function(BuildContext, String?)? instructionsTextControllerValidator;
  // Model for AddPropertyComplete component.
  late AddPropertyCompleteModel addPropertyCompleteModel;

  @override
  void initState(BuildContext context) {
    addPropertyCompleteModel =
        createModel(context, () => AddPropertyCompleteModel());
  }

  @override
  void dispose() {
    nameLabelFocusNode?.dispose();
    nameLabelTextController?.dispose();

    addressFocusNode?.dispose();
    addressTextController?.dispose();

    floorFocusNode1?.dispose();
    floorTextController1?.dispose();

    unitAptFocusNode?.dispose();
    unitAptTextController?.dispose();

    numberFocusNode?.dispose();
    numberTextController?.dispose();

    floorFocusNode2?.dispose();
    floorTextController2?.dispose();

    floorFocusNode3?.dispose();
    floorTextController3?.dispose();

    gateCodeFocusNode?.dispose();
    gateCodeTextController?.dispose();

    instructionsFocusNode?.dispose();
    instructionsTextController?.dispose();

    addPropertyCompleteModel.dispose();
  }
}
