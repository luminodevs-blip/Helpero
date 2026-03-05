import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'arrival_card_model.dart';
export 'arrival_card_model.dart';

class ArrivalCardWidget extends StatefulWidget {
  const ArrivalCardWidget({
    super.key,
    required this.type,
    required this.time,
    required this.price,
    required this.onTap,
    required this.currentSelectedValue,
    required this.date,
  });

  /// название (Priority/Standard/Scheduled)
  final String? type;

  /// время или дата
  final String? time;

  /// стоимость (+$24 / Free)
  final String? price;

  final Future Function()? onTap;
  final String? currentSelectedValue;
  final String? date;

  @override
  State<ArrivalCardWidget> createState() => _ArrivalCardWidgetState();
}

class _ArrivalCardWidgetState extends State<ArrivalCardWidget> {
  late ArrivalCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ArrivalCardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          await widget.onTap?.call();
        },
        child: Container(
          width: 146.0,
          height: 128.0,
          decoration: BoxDecoration(
            color: valueOrDefault<Color>(
              widget.currentSelectedValue == widget.type
                  ? FlutterFlowTheme.of(context).primaryBackground
                  : FlutterFlowTheme.of(context).secondaryBackground,
              FlutterFlowTheme.of(context).secondaryBackground,
            ),
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
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: valueOrDefault<Color>(
                widget.currentSelectedValue == widget.type
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).alternate,
                FlutterFlowTheme.of(context).alternate,
              ),
              width: valueOrDefault<double>(
                widget.currentSelectedValue == widget.type ? 1.5 : 1.5,
                1.5,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      () {
                        if (widget.type == 'priority') {
                          return 'Priority';
                        } else if (widget.type == 'standard') {
                          return 'Standard';
                        } else {
                          return 'Scheduled';
                        }
                      }(),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.outfit(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 15.0,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    if (widget.type == 'priority')
                      Icon(
                        Icons.flash_on_outlined,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 14.0,
                      ),
                    if (widget.type == 'scheduled')
                      FaIcon(
                        FontAwesomeIcons.clock,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 14.0,
                      ),
                  ].divide(SizedBox(width: 4.0)),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget.date,
                          'Today',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.outfit(
                                fontWeight: FontWeight.normal,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14.0,
                              letterSpacing: 0.2,
                              fontWeight: FontWeight.normal,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                              lineHeight: 1.4,
                            ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          widget.time,
                          '17:05–17:11',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.outfit(
                                fontWeight: FontWeight.normal,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14.0,
                              letterSpacing: 0.2,
                              fontWeight: FontWeight.normal,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                              lineHeight: 1.4,
                            ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      () {
                        if (widget.type == 'priority') {
                          return '+ ${valueOrDefault<String>(
                            FFAppState().currentCountry.currencySymbol,
                            '\$',
                          )}${widget.price}';
                        } else if (widget.type == 'standard') {
                          return 'free';
                        } else {
                          return '';
                        }
                      }(),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.outfit(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.2,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                ),
              ].divide(SizedBox(height: 4.0)),
            ),
          ),
        ),
      ),
    );
  }
}
