import '/backend/supabase/supabase.dart';
import '/components/master_assigned_widget.dart';
import '/components/master_searching_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'master_finder_map_box_model.dart';
export 'master_finder_map_box_model.dart';

class MasterFinderMapBoxWidget extends StatefulWidget {
  const MasterFinderMapBoxWidget({
    super.key,
    this.orderId,
  });

  final int? orderId;

  static String routeName = 'MasterFinderMapBox';
  static String routePath = '/mf1';

  @override
  State<MasterFinderMapBoxWidget> createState() =>
      _MasterFinderMapBoxWidgetState();
}

class _MasterFinderMapBoxWidgetState extends State<MasterFinderMapBoxWidget>
    with TickerProviderStateMixin {
  late MasterFinderMapBoxModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  LatLng? currentUserLocationValue;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MasterFinderMapBoxModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          await Future.delayed(
            Duration(
              milliseconds: 4500,
            ),
          );
          _model.targetZoom = 15.0;
          safeSetState(() {});
          await Future.delayed(
            Duration(
              milliseconds: 8500,
            ),
          );
          _model.targetZoom = 14.0;
          safeSetState(() {});
        }),
        Future(() async {
          while (getCurrentTimestamp == getCurrentTimestamp) {
            await Future.delayed(
              Duration(
                milliseconds: 5,
              ),
            );
            _model.refresher = !_model.refresher;
            safeSetState(() {});
          }
        }),
      ]);
    });

    getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0), cached: true)
        .then((loc) => safeSetState(() => currentUserLocationValue = loc));
    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        loop: true,
        reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 3000.0.ms,
            begin: Offset(0.6, 0.6),
            end: Offset(1.5, 1.5),
          ),
        ],
      ),
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserLocationValue == null) {
      return Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: Center(
          child: SizedBox(
            width: 10.0,
            height: 10.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.transparent,
              ),
            ),
          ),
        ),
      );
    }

    return StreamBuilder<List<OrdersRow>>(
      stream: _model.masterFinderMapBoxSupabaseStream ??= SupaFlow.client
          .from("orders")
          .stream(primaryKey: ['id'])
          .eqOrNull(
            'id',
            widget.orderId,
          )
          .map((list) => list.map((item) => OrdersRow(item)).toList()),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 10.0,
                height: 10.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.transparent,
                  ),
                ),
              ),
            ),
          );
        }
        List<OrdersRow> masterFinderMapBoxOrdersRowList = snapshot.data!;

        final masterFinderMapBoxOrdersRow =
            masterFinderMapBoxOrdersRowList.isNotEmpty
                ? masterFinderMapBoxOrdersRowList.first
                : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Stack(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: MediaQuery.sizeOf(context).height * 1.0,
                    child: custom_widgets.GoogleMapsAnimatedMap(
                      width: MediaQuery.sizeOf(context).width * 1.0,
                      height: MediaQuery.sizeOf(context).height * 1.0,
                      apiKey: 'AIzaSyC_tcXVeDFmHjvpPz-ZMZXceu5PSppmXPM',
                      androidMapId: '6cb6a40ecec468b75636393f',
                      iOSMapId: '6cb6a40ecec468b75636393f',
                      webMapId: '6cb6a40ecec468b75636393f',
                      zoomLevel: valueOrDefault<double>(
                        _model.targetZoom,
                        14.0,
                      ),
                      allowInteraction: false,
                      language: 'en',
                      initialCenter: currentUserLocationValue,
                      onAddressChanged: (address, city, lat, lng) async {},
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: Color(0x2357636C),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 50.0),
                      child: Text(
                        'Hello World',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.outfit(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 0.0,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                ),
                if (masterFinderMapBoxOrdersRow?.status == 'searching')
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 200.0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        curve: Curves.linear,
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          color: Color(0x347B82F4),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8.0,
                              color: Color(0x5E7B82F4),
                              offset: Offset(
                                0.0,
                                2.0,
                              ),
                            )
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              color: Color(0x347B82F4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ).animateOnPageLoad(
                          animationsMap['containerOnPageLoadAnimation']!),
                    ),
                  ),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 200.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.linear,
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x33000000),
                            offset: Offset(0.0, 0.0),
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Icon(
                          Icons.home_rounded,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (masterFinderMapBoxOrdersRow?.status == 'searching')
                        Align(
                          alignment: AlignmentDirectional(0.0, 1.0),
                          child: wrapWithModel(
                            model: _model.masterSearchingModel,
                            updateCallback: () => safeSetState(() {}),
                            child: MasterSearchingWidget(
                              orderID: widget.orderId,
                            ),
                          ),
                        ),
                      if (masterFinderMapBoxOrdersRow?.status == 'assigned')
                        wrapWithModel(
                          model: _model.masterAssignedModel,
                          updateCallback: () => safeSetState(() {}),
                          child: MasterAssignedWidget(
                            orderID: widget.orderId,
                          ),
                        ),
                    ],
                  ),
                ),
                if (masterFinderMapBoxOrdersRow?.status == 'pending_payment')
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      curve: Curves.linear,
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              28.0, 0.0, 28.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/jsons/loader.json',
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.contain,
                                frameRate: FrameRate(120.0),
                                animate: true,
                              ),
                              Text(
                                'Securing your booking...',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      fontSize: 24.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 8.0, 20.0, 0.0),
                                child: Text(
                                  'Checking payment status with your bank.',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ).animateOnPageLoad(
                              animationsMap['columnOnPageLoadAnimation']!),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
