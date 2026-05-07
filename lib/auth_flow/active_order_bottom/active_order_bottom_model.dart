import '/components/rating_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'active_order_bottom_widget.dart' show ActiveOrderBottomWidget;
import 'package:flutter/material.dart';

class ActiveOrderBottomModel extends FlutterFlowModel<ActiveOrderBottomWidget> {
  ///  Local state fields for this component.

  String status = 'download';

  ///  State fields for stateful widgets in this component.

  // Model for RatingBar component.
  late RatingBarModel ratingBarModel;

  @override
  void initState(BuildContext context) {
    ratingBarModel = createModel(context, () => RatingBarModel());
  }

  @override
  void dispose() {
    ratingBarModel.dispose();
  }
}
