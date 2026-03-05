import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'include_card_model.dart';
export 'include_card_model.dart';

class IncludeCardWidget extends StatefulWidget {
  const IncludeCardWidget({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  final String? name;
  final String? imageUrl;

  @override
  State<IncludeCardWidget> createState() => _IncludeCardWidgetState();
}

class _IncludeCardWidgetState extends State<IncludeCardWidget> {
  late IncludeCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IncludeCardModel());

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
      width: 110.0,
      height: 125.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: FlutterFlowTheme.of(context).primaryBackground,
            offset: Offset(
              0.0,
              2.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Align(
              alignment: AlignmentDirectional(-1.0, -1.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 8.0),
                child: Text(
                  valueOrDefault<String>(
                    widget.name,
                    'Floor Vacuuming',
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.outfit(
                          fontWeight: FontWeight.normal,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 14.5,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.normal,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
            ),
            child: Image.network(
              valueOrDefault<String>(
                widget.imageUrl,
                'https://hwgmjlsoeebgounmthmr.supabase.co/storage/v1/object/public/icons/Standart%20Cleaning2.png',
              ),
              width: double.infinity,
              height: 75.0,
              fit: BoxFit.cover,
              alignment: Alignment(0.0, 1.0),
            ),
          ),
        ],
      ),
    );
  }
}
