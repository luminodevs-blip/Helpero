import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings0_model.dart';
export 'settings0_model.dart';

class Settings0Widget extends StatefulWidget {
  const Settings0Widget({
    super.key,
    required this.icon,
    required this.title,
    required this.navigateTo,
  });

  final Widget? icon;
  final String? title;
  final Future Function()? navigateTo;

  @override
  State<Settings0Widget> createState() => _Settings0WidgetState();
}

class _Settings0WidgetState extends State<Settings0Widget> {
  late Settings0Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Settings0Model());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await widget.navigateTo?.call();
      },
      child: Container(
        width: double.infinity,
        height: 44.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.icon!,
                  Container(
                    width: 215.0,
                    decoration: BoxDecoration(),
                    child: Text(
                      valueOrDefault<String>(
                        widget.title,
                        'Add home',
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.outfit(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            fontSize: 15.0,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                            lineHeight: 1.4,
                          ),
                    ),
                  ),
                ].divide(SizedBox(width: 12.0)),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
