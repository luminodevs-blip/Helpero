import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'rating_bar_model.dart';
export 'rating_bar_model.dart';

class RatingBarWidget extends StatefulWidget {
  const RatingBarWidget({super.key});

  @override
  State<RatingBarWidget> createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  late RatingBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RatingBarModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Align(
            alignment: AlignmentDirectional(-1.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                _model.state = 1;
                safeSetState(() {});
              },
              child: FaIcon(
                FontAwesomeIcons.solidMehRollingEyes,
                color: valueOrDefault<Color>(
                  _model.state! > 0
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).accent1,
                  FlutterFlowTheme.of(context).accent1,
                ),
                size: 24.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional(-1.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                _model.state = 2;
                safeSetState(() {});
              },
              child: FaIcon(
                FontAwesomeIcons.solidMeh,
                color: valueOrDefault<Color>(
                  _model.state! > 1
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).accent1,
                  FlutterFlowTheme.of(context).accent1,
                ),
                size: 24.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional(-1.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                _model.state = 3;
                safeSetState(() {});
              },
              child: FaIcon(
                FontAwesomeIcons.solidSmile,
                color: valueOrDefault<Color>(
                  _model.state! > 2
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).accent1,
                  FlutterFlowTheme.of(context).accent1,
                ),
                size: 24.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional(-1.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                _model.state = 4;
                safeSetState(() {});
              },
              child: FaIcon(
                FontAwesomeIcons.solidSmileBeam,
                color: valueOrDefault<Color>(
                  _model.state! > 3
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).accent1,
                  FlutterFlowTheme.of(context).accent1,
                ),
                size: 24.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: AlignmentDirectional(-1.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                _model.state = 5;
                safeSetState(() {});
              },
              child: FaIcon(
                FontAwesomeIcons.solidSmileWink,
                color: valueOrDefault<Color>(
                  _model.state! > 4
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).accent1,
                  FlutterFlowTheme.of(context).accent1,
                ),
                size: 24.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
