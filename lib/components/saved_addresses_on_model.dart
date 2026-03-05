import '/components/address_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'saved_addresses_on_widget.dart' show SavedAddressesOnWidget;
import 'package:flutter/material.dart';

class SavedAddressesOnModel extends FlutterFlowModel<SavedAddressesOnWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for Address component.
  late AddressModel addressModel1;
  // Model for Address component.
  late AddressModel addressModel2;
  // Model for Address component.
  late AddressModel addressModel3;

  @override
  void initState(BuildContext context) {
    addressModel1 = createModel(context, () => AddressModel());
    addressModel2 = createModel(context, () => AddressModel());
    addressModel3 = createModel(context, () => AddressModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    addressModel1.dispose();
    addressModel2.dispose();
    addressModel3.dispose();
  }
}
