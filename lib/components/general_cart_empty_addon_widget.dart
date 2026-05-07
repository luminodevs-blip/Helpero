import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'general_cart_empty_addon_model.dart';
export 'general_cart_empty_addon_model.dart';

class GeneralCartEmptyAddonWidget extends StatefulWidget {
  const GeneralCartEmptyAddonWidget({super.key});

  @override
  State<GeneralCartEmptyAddonWidget> createState() =>
      _GeneralCartEmptyAddonWidgetState();
}

class _GeneralCartEmptyAddonWidgetState
    extends State<GeneralCartEmptyAddonWidget> {
  late GeneralCartEmptyAddonModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GeneralCartEmptyAddonModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
      child: Text(
        'You haven’t added any extras',
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.outfit(
                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              letterSpacing: 0.0,
              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
      ),
    );
  }
}
