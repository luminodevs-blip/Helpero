import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_ons_counter_model.dart';
export 'add_ons_counter_model.dart';

class AddOnsCounterWidget extends StatefulWidget {
  const AddOnsCounterWidget({
    super.key,
    required this.plus,
    required this.minus,
    int? maxLimit,
    int? count,
  })  : this.maxLimit = maxLimit ?? 5,
        this.count = count ?? 0;

  final Future Function()? plus;
  final Future Function()? minus;
  final int maxLimit;
  final int count;

  @override
  State<AddOnsCounterWidget> createState() => _AddOnsCounterWidgetState();
}

class _AddOnsCounterWidgetState extends State<AddOnsCounterWidget> {
  late AddOnsCounterModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddOnsCounterModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(1.0, 1.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.count > 0)
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        await widget.minus?.call();
                      },
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: FaIcon(
                            FontAwesomeIcons.minus,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 14.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        valueOrDefault<String>(
                          widget.count.toString(),
                          '0',
                        ),
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                await widget.plus?.call();
              },
              child: Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: valueOrDefault<Color>(
                    widget.count < widget.maxLimit
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).alternate,
                    FlutterFlowTheme.of(context).primary,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Icon(
                    Icons.add_rounded,
                    color: valueOrDefault<Color>(
                      widget.count < widget.maxLimit
                          ? FlutterFlowTheme.of(context).secondaryBackground
                          : FlutterFlowTheme.of(context).primaryText,
                      FlutterFlowTheme.of(context).primary,
                    ),
                    size: 24.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
