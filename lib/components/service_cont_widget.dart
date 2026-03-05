import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'service_cont_model.dart';
export 'service_cont_model.dart';

class ServiceContWidget extends StatefulWidget {
  const ServiceContWidget({
    super.key,
    required this.img,
    required this.title,
    required this.navigateTo,
  });

  final String? img;
  final String? title;
  final Future Function()? navigateTo;

  @override
  State<ServiceContWidget> createState() => _ServiceContWidgetState();
}

class _ServiceContWidgetState extends State<ServiceContWidget> {
  late ServiceContModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ServiceContModel());

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
      width: 100.0,
      height: 110.0,
      decoration: BoxDecoration(
        color: Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.img!,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 0.0),
            child: Text(
              valueOrDefault<String>(
                widget.title,
                'Electrical',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]
            .divide(SizedBox(height: 4.0))
            .addToStart(SizedBox(height: 8.0))
            .addToEnd(SizedBox(height: 8.0)),
      ),
    );
  }
}
