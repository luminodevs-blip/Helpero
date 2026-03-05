import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'payment_success_page_model.dart';
export 'payment_success_page_model.dart';

class PaymentSuccessPageWidget extends StatefulWidget {
  const PaymentSuccessPageWidget({super.key});

  static String routeName = 'PaymentSuccessPage';
  static String routePath = '/paymentSuccessPage';

  @override
  State<PaymentSuccessPageWidget> createState() =>
      _PaymentSuccessPageWidgetState();
}

class _PaymentSuccessPageWidgetState extends State<PaymentSuccessPageWidget> {
  late PaymentSuccessPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentSuccessPageModel());

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
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    size: 100.0,
                  ),
                ),
                Text(
                  'Payment Success',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    fontSize: 24.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    shadows: [
                      Shadow(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 2.0,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
