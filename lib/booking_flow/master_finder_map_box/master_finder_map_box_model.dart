import '/backend/supabase/supabase.dart';
import '/components/master_assigned_widget.dart';
import '/components/master_searching_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'master_finder_map_box_widget.dart' show MasterFinderMapBoxWidget;
import 'package:flutter/material.dart';

class MasterFinderMapBoxModel
    extends FlutterFlowModel<MasterFinderMapBoxWidget> {
  ///  Local state fields for this page.

  double targetZoom = 16.0;

  bool refresher = false;

  ///  State fields for stateful widgets in this page.

  Stream<List<OrdersRow>>? masterFinderMapBoxSupabaseStream;
  // Model for master_searching component.
  late MasterSearchingModel masterSearchingModel;
  // Model for master_assigned component.
  late MasterAssignedModel masterAssignedModel;

  @override
  void initState(BuildContext context) {
    masterSearchingModel = createModel(context, () => MasterSearchingModel());
    masterAssignedModel = createModel(context, () => MasterAssignedModel());
  }

  @override
  void dispose() {
    masterSearchingModel.dispose();
    masterAssignedModel.dispose();
  }
}
