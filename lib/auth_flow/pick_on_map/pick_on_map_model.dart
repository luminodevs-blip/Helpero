import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'pick_on_map_widget.dart' show PickOnMapWidget;
import 'package:flutter/material.dart';

class PickOnMapModel extends FlutterFlowModel<PickOnMapWidget> {
  ///  Local state fields for this page.

  LatLng? latLng;

  String address = 'Toronto, Ontario';

  String city = 'Toronto';

  double lat = 43.6708;

  double lng = -79.3933;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  HousesRow? newHouse;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
