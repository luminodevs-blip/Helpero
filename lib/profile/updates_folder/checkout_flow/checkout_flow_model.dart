import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'checkout_flow_widget.dart' show CheckoutFlowWidget;
import 'package:flutter/material.dart';

class CheckoutFlowModel extends FlutterFlowModel<CheckoutFlowWidget> {
  ///  Local state fields for this page.

  double? selectedItem = 1.0;

  ///  State fields for stateful widgets in this page.

  // State field(s) for GoogleMap widget.
  LatLng? googleMapsCenter;
  final googleMapsController = Completer<GoogleMapController>();
  // State field(s) for Checkbox widget.
  bool? checkboxValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
