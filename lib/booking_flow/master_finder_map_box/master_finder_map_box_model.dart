import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'master_finder_map_box_widget.dart' show MasterFinderMapBoxWidget;
import 'package:flutter/material.dart';

class MasterFinderMapBoxModel
    extends FlutterFlowModel<MasterFinderMapBoxWidget> {
  ///  Local state fields for this page.

  double targetZoom = 16.0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in MasterFinderMapBox widget.
  List<OrdersRow>? polledOrder;
  // Stores action output result for [Backend Call - API (cancelpayment)] action in Button widget.
  ApiCallResponse? cancelpayment;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
