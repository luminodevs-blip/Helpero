import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'active_order_tracking_model.dart';
export 'active_order_tracking_model.dart';

class ActiveOrderTrackingWidget extends StatefulWidget {
  const ActiveOrderTrackingWidget({
    super.key,
    required this.orderId,
  });

  final int? orderId;

  static String routeName = 'ActiveOrder_Tracking';
  static String routePath = '/activeOrderTracking';

  @override
  State<ActiveOrderTrackingWidget> createState() =>
      _ActiveOrderTrackingWidgetState();
}

class _ActiveOrderTrackingWidgetState extends State<ActiveOrderTrackingWidget> {
  late ActiveOrderTrackingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ActiveOrderTrackingModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [],
          ),
        ),
      ),
    );
  }
}
