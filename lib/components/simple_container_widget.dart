import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'simple_container_model.dart';
export 'simple_container_model.dart';

class SimpleContainerWidget extends StatefulWidget {
  const SimpleContainerWidget({super.key});

  @override
  State<SimpleContainerWidget> createState() => _SimpleContainerWidgetState();
}

class _SimpleContainerWidgetState extends State<SimpleContainerWidget> {
  late SimpleContainerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SimpleContainerModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
    );
  }
}
