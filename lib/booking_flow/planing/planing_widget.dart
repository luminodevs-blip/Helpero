import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/booking_flow/arrival_card/arrival_card_widget.dart';
import '/booking_flow/new/arrival_card_loader/arrival_card_loader_widget.dart';
import '/booking_flow/price_summary/price_summary_widget.dart';
import '/booking_flow/service_access_options_bottom/service_access_options_bottom_widget.dart';
import '/booking_flow/visit_time_component/visit_time_component_widget.dart';
import '/components/select_address_booking_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'planing_model.dart';
export 'planing_model.dart';

class PlaningWidget extends StatefulWidget {
  const PlaningWidget({super.key});

  static String routeName = 'Planing';
  static String routePath = '/Planing';

  @override
  State<PlaningWidget> createState() => _PlaningWidgetState();
}

class _PlaningWidgetState extends State<PlaningWidget>
    with TickerProviderStateMixin {
  late PlaningModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlaningModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      while (getCurrentTimestamp == getCurrentTimestamp) {
        _model.checkAvailability = await CheckAvailabilityCall.call(
          houseId: FFAppState().activeBookingDraft.address.id,
          serviceId: FFAppState().activeBookingDraft.serviceId,
          durationMinutes: FFAppState().activeBookingDraft.totalDuration,
          targetDate: getCurrentTimestamp.toString(),
        );

        if ((_model.checkAvailability?.succeeded ?? true)) {
          _model.currentSlots = CheckAvailabilityCall.slotslist(
            (_model.checkAvailability?.jsonBody ?? ''),
          )!
              .toList()
              .cast<ArrivalOptionStructStruct>();
          _model.isLoadingSlots = false;
          _model.mapIMG = functions.getStaticMapUrl(
              FFAppState().activeBookingDraft.address.lat,
              FFAppState().activeBookingDraft.address.lng);
          safeSetState(() {});
          if (!(FFAppState().activeBookingDraft.visit.mode != '')) {
            FFAppState().updateActiveBookingDraftStruct(
              (e) => e
                ..visit = VisitDetailsStruct(
                  mode: functions
                      .findStandardSlot(CheckAvailabilityCall.slotslist(
                        (_model.checkAvailability?.jsonBody ?? ''),
                      )!
                          .toList())
                      ?.mode,
                  arrivalTimeSlot: functions
                      .findStandardSlot(CheckAvailabilityCall.slotslist(
                        (_model.checkAvailability?.jsonBody ?? ''),
                      )!
                          .toList())
                      ?.timeStart,
                  arrivalDateDisplay: functions
                      .findStandardSlot(CheckAvailabilityCall.slotslist(
                        (_model.checkAvailability?.jsonBody ?? ''),
                      )!
                          .toList())
                      ?.displayDate,
                  id: getJsonField(
                    (_model.checkAvailability?.jsonBody ?? ''),
                    r'''$.id''',
                  ).toString(),
                ),
            );
            safeSetState(() {});
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error fetching availability',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
              ),
              duration: Duration(milliseconds: 4000),
              backgroundColor: FlutterFlowTheme.of(context).error,
            ),
          );
        }

        await Future.delayed(
          Duration(
            milliseconds: 60000,
          ),
        );
      }
    });

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 1500.0.ms,
            begin: Offset(-80.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 1500.0.ms,
            duration: 400.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
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
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Align(
          alignment: AlignmentDirectional(0.0, -1.0),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 500.0,
              maxHeight: 1000.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: Container(
                    width: double.infinity,
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, -1.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          height: MediaQuery.sizeOf(context).height * 1.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 0.0, 16.0, 20.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 12.0, 0.0),
                                      child: FlutterFlowIconButton(
                                        borderRadius: 25.0,
                                        borderWidth: 2.0,
                                        buttonSize: 40.0,
                                        icon: Icon(
                                          Icons.arrow_back_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 24.0,
                                        ),
                                        onPressed: () async {
                                          await actions.releaseBookingSlot();
                                          FFAppState()
                                              .updateActiveBookingDraftStruct(
                                            (e) => e
                                              ..visit = null
                                              ..serverCheckout = null
                                              ..totalPrice = FFAppState()
                                                  .activeBookingDraft
                                                  .basePrice,
                                          );
                                          safeSetState(() {});

                                          context.pushNamed(
                                            AddOnsWidget.routeName,
                                            extra: <String, dynamic>{
                                              '__transition_info__':
                                                  TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType.fade,
                                                duration:
                                                    Duration(milliseconds: 0),
                                              ),
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Text(
                                      'Service details',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.outfit(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 20.0,
                                            letterSpacing: 0.2,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    Opacity(
                                      opacity: 0.0,
                                      child: FlutterFlowIconButton(
                                        borderColor: Color(0x6DE0E3E7),
                                        borderRadius: 25.0,
                                        borderWidth: 2.0,
                                        buttonSize: 40.0,
                                        icon: Icon(
                                          Icons.arrow_back_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 24.0,
                                        ),
                                        onPressed: () async {
                                          context.pushNamed(
                                            GeneralWidget.routeName,
                                            extra: <String, dynamic>{
                                              '__transition_info__':
                                                  TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType.fade,
                                                duration:
                                                    Duration(milliseconds: 0),
                                              ),
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 20.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 1.0,
                                  decoration: BoxDecoration(
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Arrival time',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .outfit(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 17.0,
                                                          letterSpacing: 0.2,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ].divide(SizedBox(width: 16.0)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 12.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (_model.isLoadingSlots == false)
                                            Container(
                                              width: 450.0,
                                              height: 144.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                              child: Builder(
                                                builder: (context) {
                                                  final slotItem = _model
                                                      .currentSlots
                                                      .toList()
                                                      .take(3)
                                                      .toList();

                                                  return GridView.builder(
                                                    padding: EdgeInsets.zero,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      crossAxisSpacing: 8.0,
                                                      mainAxisSpacing: 8.0,
                                                      childAspectRatio: 1.08,
                                                    ),
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: slotItem.length,
                                                    itemBuilder: (context,
                                                        slotItemIndex) {
                                                      final slotItemItem =
                                                          slotItem[
                                                              slotItemIndex];
                                                      return ArrivalCardWidget(
                                                        key: Key(
                                                            'Keyk18_${slotItemIndex}_of_${slotItem.length}'),
                                                        type: valueOrDefault<
                                                            String>(
                                                          slotItemItem.mode,
                                                          'Standard',
                                                        ),
                                                        time: valueOrDefault<
                                                            String>(
                                                          slotItemItem
                                                              .displayTime,
                                                          '00:00',
                                                        ),
                                                        price: valueOrDefault<
                                                            String>(
                                                          slotItemItem.fee
                                                              .toString(),
                                                          '\$25',
                                                        ),
                                                        currentSelectedValue:
                                                            FFAppState()
                                                                .activeBookingDraft
                                                                .visit
                                                                .mode,
                                                        date: slotItemItem
                                                            .displayDate,
                                                        onTap: () async {
                                                          if (slotItemItem
                                                                  .mode ==
                                                              'scheduled') {
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                    FocusManager
                                                                        .instance
                                                                        .primaryFocus
                                                                        ?.unfocus();
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        VisitTimeComponentWidget(
                                                                      dateSelected:
                                                                          false,
                                                                      initialDate: FFAppState()
                                                                          .activeBookingDraft
                                                                          .visit
                                                                          .arrivalDate!,
                                                                      initialTimeDisplay: FFAppState()
                                                                          .activeBookingDraft
                                                                          .visit
                                                                          .arrivalTimeDisplay,
                                                                      durationText:
                                                                          valueOrDefault<
                                                                              String>(
                                                                        functions.formatDuration(FFAppState()
                                                                            .activeBookingDraft
                                                                            .totalDuration
                                                                            .toDouble()),
                                                                        '5 hr 28 min',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                safeSetState(
                                                                    () {}));

                                                            FFAppState()
                                                                .updateActiveBookingDraftStruct(
                                                              (e) => e
                                                                ..visit =
                                                                    VisitDetailsStruct(
                                                                  mode: functions
                                                                      .findStandardSlot(CheckAvailabilityCall.slotslist(
                                                                        (_model.checkAvailability?.jsonBody ??
                                                                            ''),
                                                                      )!
                                                                          .toList())
                                                                      ?.mode,
                                                                  arrivalTimeSlot: functions
                                                                      .findStandardSlot(CheckAvailabilityCall.slotslist(
                                                                        (_model.checkAvailability?.jsonBody ??
                                                                            ''),
                                                                      )!
                                                                          .toList())
                                                                      ?.timeStart,
                                                                  arrivalDateDisplay: functions
                                                                      .findStandardSlot(CheckAvailabilityCall.slotslist(
                                                                        (_model.checkAvailability?.jsonBody ??
                                                                            ''),
                                                                      )!
                                                                          .toList())
                                                                      ?.displayDate,
                                                                  id: slotItemItem
                                                                      .id,
                                                                  arrivalTimeDisplay:
                                                                      slotItemItem
                                                                          .displayTime,
                                                                ),
                                                            );
                                                            safeSetState(() {});
                                                          } else {
                                                            _model.updatedDraftResult =
                                                                await actions
                                                                    .updateBookingSlot(
                                                              FFAppState()
                                                                  .activeBookingDraft,
                                                              slotItemItem,
                                                            );
                                                            await actions
                                                                .secureBookingSlot(
                                                              slotItemItem.id,
                                                              slotItemItem
                                                                  .timeStart,
                                                            );
                                                            FFAppState()
                                                                    .activeBookingDraft =
                                                                _model
                                                                    .updatedDraftResult!;
                                                            safeSetState(() {});
                                                          }

                                                          safeSetState(() {});
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          if (_model.isLoadingSlots == true)
                                            wrapWithModel(
                                              model:
                                                  _model.arrivalCardLoaderModel,
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: ArrivalCardLoaderWidget(),
                                            ),
                                        ]
                                            .addToStart(SizedBox(width: 16.0))
                                            .addToEnd(SizedBox(width: 16.0)),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 12.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: RichText(
                                              textScaler: MediaQuery.of(context)
                                                  .textScaler,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        valueOrDefault<String>(
                                                      FFAppState()
                                                          .activeBookingDraft
                                                          .categoryId
                                                          .name,
                                                      'Cleaning',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .outfit(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 14.5,
                                                          letterSpacing: 0.2,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text: ' duration:',
                                                    style: TextStyle(),
                                                  )
                                                ],
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.outfit(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      fontSize: 14.5,
                                                      letterSpacing: 0.2,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Text(
                                              valueOrDefault<String>(
                                                functions.formatDuration(
                                                    FFAppState()
                                                        .activeBookingDraft
                                                        .totalDuration
                                                        .toDouble()),
                                                '5 hr 28 min',
                                              ),
                                              textAlign: TextAlign.start,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.outfit(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 14.5,
                                                    letterSpacing: 0.2,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 8.0)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 20.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 1.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 20.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(-1.0, 0.0),
                                            child: Text(
                                              'Service location',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.outfit(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    fontSize: 17.0,
                                                    letterSpacing: 0.2,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              offset: Offset(
                                                0.0,
                                                2.0,
                                              ),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: Colors.transparent,
                                            width: 0.0,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  topRight:
                                                      Radius.circular(10.0),
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 127.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10.0),
                                                      topRight:
                                                          Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                Image.network(
                                                              valueOrDefault<
                                                                  String>(
                                                                _model.mapIMG,
                                                                'https://hwgmjlsoeebgounmthmr.supabase.co/storage/v1/object/public/icons/a5c2bf72-0612-431f-9e17-8bc3f575c75c.png',
                                                              ),
                                                            ).image,
                                                          ),
                                                        ),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Icon(
                                                            Icons
                                                                .location_on_rounded,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 34.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 14.0),
                                              child: Container(
                                                width: double.infinity,
                                                height: 1.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 20.0),
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        await showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          enableDrag: false,
                                                          context: context,
                                                          builder: (context) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                              },
                                                              child: Padding(
                                                                padding: MediaQuery
                                                                    .viewInsetsOf(
                                                                        context),
                                                                child:
                                                                    Container(
                                                                  height: MediaQuery.sizeOf(
                                                                              context)
                                                                          .height *
                                                                      0.95,
                                                                  child:
                                                                      SelectAddressBookingWidget(
                                                                    callback:
                                                                        () async {},
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            safeSetState(
                                                                () {}));

                                                        _model.checkAvailabilityAddress =
                                                            await CheckAvailabilityCall
                                                                .call(
                                                          houseId: FFAppState()
                                                              .activeBookingDraft
                                                              .address
                                                              .id,
                                                          serviceId: FFAppState()
                                                              .activeBookingDraft
                                                              .serviceId,
                                                          durationMinutes:
                                                              FFAppState()
                                                                  .activeBookingDraft
                                                                  .totalDuration,
                                                          targetDate:
                                                              getCurrentTimestamp
                                                                  .toString(),
                                                        );

                                                        if ((_model
                                                                .checkAvailability
                                                                ?.succeeded ??
                                                            true)) {
                                                          _model.currentSlots =
                                                              CheckAvailabilityCall
                                                                      .slotslist(
                                                            (_model.checkAvailability
                                                                    ?.jsonBody ??
                                                                ''),
                                                          )!
                                                                  .toList()
                                                                  .cast<
                                                                      ArrivalOptionStructStruct>();
                                                          _model.isLoadingSlots =
                                                              false;
                                                          safeSetState(() {});
                                                          if (!(FFAppState()
                                                                      .activeBookingDraft
                                                                      .visit
                                                                      .mode !=
                                                                  '')) {
                                                            FFAppState()
                                                                .updateActiveBookingDraftStruct(
                                                              (e) => e
                                                                ..visit =
                                                                    VisitDetailsStruct(
                                                                  mode: functions
                                                                      .findStandardSlot(CheckAvailabilityCall.slotslist(
                                                                        (_model.checkAvailability?.jsonBody ??
                                                                            ''),
                                                                      )!
                                                                          .toList())
                                                                      ?.mode,
                                                                  arrivalTimeSlot: functions
                                                                      .findStandardSlot(CheckAvailabilityCall.slotslist(
                                                                        (_model.checkAvailability?.jsonBody ??
                                                                            ''),
                                                                      )!
                                                                          .toList())
                                                                      ?.timeStart,
                                                                  arrivalDateDisplay: functions
                                                                      .findStandardSlot(CheckAvailabilityCall.slotslist(
                                                                        (_model.checkAvailability?.jsonBody ??
                                                                            ''),
                                                                      )!
                                                                          .toList())
                                                                      ?.displayDate,
                                                                  id: getJsonField(
                                                                    (_model.checkAvailability
                                                                            ?.jsonBody ??
                                                                        ''),
                                                                    r'''$.id''',
                                                                  ).toString(),
                                                                ),
                                                            );
                                                            safeSetState(() {});
                                                          }
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'Error fetching availability',
                                                                style:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                ),
                                                              ),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      4000),
                                                              backgroundColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                            ),
                                                          );
                                                        }

                                                        safeSetState(() {});
                                                      },
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        12.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons
                                                                  .home_rounded,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              size: 24.0,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          16.0,
                                                                          1.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      FFAppState()
                                                                          .activeBookingDraft
                                                                          .address
                                                                          .nameLabel,
                                                                      'My Home',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.outfit(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          fontSize:
                                                                              15.0,
                                                                          letterSpacing:
                                                                              0.2,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      FFAppState()
                                                                          .activeBookingDraft
                                                                          .address
                                                                          .fullAddress,
                                                                      '101 College Street, Suite 200 Toronto, ON M5G 1L7',
                                                                    ),
                                                                    maxLines: 1,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.outfit(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.2,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                          lineHeight:
                                                                              1.4,
                                                                        ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        2.0)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        2.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              size: 15.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 14.0),
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 1.0,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 20.0),
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        await showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          enableDrag: false,
                                                          context: context,
                                                          builder: (context) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                FocusManager
                                                                    .instance
                                                                    .primaryFocus
                                                                    ?.unfocus();
                                                              },
                                                              child: Padding(
                                                                padding: MediaQuery
                                                                    .viewInsetsOf(
                                                                        context),
                                                                child:
                                                                    ServiceAccessOptionsBottomWidget(),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            safeSetState(
                                                                () {}));
                                                      },
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        12.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons
                                                                  .person_rounded,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              size: 24.0,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          14.0,
                                                                          1.0),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      functions.getEntryMethodLabel(
                                                                          valueOrDefault<
                                                                              String>(
                                                                        FFAppState()
                                                                            .activeBookingDraft
                                                                            .visit
                                                                            .entryMethod,
                                                                        'meet_at_door',
                                                                      )),
                                                                      'll be home (Meet at door)',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.outfit(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          fontSize:
                                                                              15.0,
                                                                          letterSpacing:
                                                                              0.2,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    valueOrDefault<
                                                                        String>(
                                                                      FFAppState()
                                                                          .activeBookingDraft
                                                                          .visit
                                                                          .entryNotes,
                                                                      'Tap to add entry instructions',
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          font:
                                                                              GoogleFonts.outfit(
                                                                            fontWeight:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                          ),
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          fontSize:
                                                                              14.0,
                                                                          letterSpacing:
                                                                              0.2,
                                                                          fontWeight: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontWeight,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                          lineHeight:
                                                                              1.4,
                                                                        ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ].divide(SizedBox(
                                                                    height:
                                                                        2.0)),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        2.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              size: 15.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ].addToEnd(SizedBox(height: 120.0)),
                                ),
                              ),
                            ]
                                .addToStart(SizedBox(height: 24.0))
                                .addToEnd(SizedBox(height: 60.0)),
                          ),
                        ),
                      ].addToStart(SizedBox(
                          height: valueOrDefault<double>(
                        isWeb ? 4.0 : 44.0,
                        44.0,
                      ))),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              1.0, 0.0, 1.0, 0.0),
                          child: ClipRRect(
                            child: Container(
                              width: double.infinity,
                              height: 5.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(-1.0, 0.0),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.8,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                    ),
                                  ),
                                ).animateOnPageLoad(animationsMap[
                                    'containerOnPageLoadAnimation']!),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 40.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 16.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) {
                                          return GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            child: Padding(
                                              padding: MediaQuery.viewInsetsOf(
                                                  context),
                                              child: PriceSummaryWidget(
                                                navigate: () async {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 4.0),
                                            child: Text(
                                              'Total',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.outfit(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.2,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              RichText(
                                                textScaler:
                                                    MediaQuery.of(context)
                                                        .textScaler,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: valueOrDefault<
                                                          String>(
                                                        FFAppState()
                                                            .currentCountry
                                                            .currencySymbol,
                                                        '\$',
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .outfit(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.2,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                    TextSpan(
                                                      text: valueOrDefault<
                                                          String>(
                                                        formatNumber(
                                                          FFAppState()
                                                              .activeBookingDraft
                                                              .totalPrice,
                                                          formatType:
                                                              FormatType.custom,
                                                          format: '#,##0.00',
                                                          locale: '',
                                                        ),
                                                        '0.00',
                                                      ),
                                                      style: TextStyle(),
                                                    )
                                                  ],
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 18.0,
                                                        letterSpacing: 0.2,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.keyboard_arrow_up_rounded,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 24.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  _model.checkoutResult =
                                      await CalculateCheckoutCall.call(
                                    authToken: currentJwtToken,
                                    cartId: FFAppState()
                                        .activeBookingDraft
                                        .currentCartId,
                                    houseId: FFAppState()
                                        .activeBookingDraft
                                        .address
                                        .id,
                                    arrivalModeId: FFAppState()
                                        .activeBookingDraft
                                        .visit
                                        .mode,
                                    slotStart: FFAppState()
                                        .activeBookingDraft
                                        .visit
                                        .arrivalTimeSlot,
                                    useBalance: false,
                                    entryMethod: FFAppState()
                                        .activeBookingDraft
                                        .visit
                                        .entryMethod,
                                    entryNotes: FFAppState()
                                        .activeBookingDraft
                                        .visit
                                        .entryNotes,
                                  );

                                  if ((_model.checkoutResult?.succeeded ??
                                      true)) {
                                    FFAppState().updateActiveBookingDraftStruct(
                                      (e) => e
                                        ..serverCheckout = ServerCheckoutStruct(
                                          subtotal: functions
                                              .convertToDouble(getJsonField(
                                            (_model.checkoutResult?.jsonBody ??
                                                ''),
                                            r'''$.subtotal''',
                                          )),
                                          visitFee: functions
                                              .convertToDouble(getJsonField(
                                            (_model.checkoutResult?.jsonBody ??
                                                ''),
                                            r'''$.visit_fee''',
                                          )),
                                          totalToPay: functions
                                              .convertToDouble(getJsonField(
                                            (_model.checkoutResult?.jsonBody ??
                                                ''),
                                            r'''$.total_to_pay''',
                                          )),
                                          bookingFee: functions
                                              .convertToDouble(getJsonField(
                                            (_model.checkoutResult?.jsonBody ??
                                                ''),
                                            r'''$.booking_fee''',
                                          )),
                                          priorityFee: functions
                                              .convertToDouble(getJsonField(
                                            (_model.checkoutResult?.jsonBody ??
                                                ''),
                                            r'''$.priority_fee''',
                                          )),
                                          taxAmount: functions
                                              .convertToDouble(getJsonField(
                                            (_model.checkoutResult?.jsonBody ??
                                                ''),
                                            r'''$.tax_amount''',
                                          )),
                                          taxName: getJsonField(
                                            (_model.checkoutResult?.jsonBody ??
                                                ''),
                                            r'''$.tax_name''',
                                          ).toString(),
                                          voucherDiscount: functions
                                              .convertToDouble(getJsonField(
                                            (_model.checkoutResult?.jsonBody ??
                                                ''),
                                            r'''$.voucher_discount''',
                                          )),
                                          highDemandFee: functions
                                              .convertToDouble(getJsonField(
                                            (_model.checkoutResult?.jsonBody ??
                                                ''),
                                            r'''$.high_demand_fee''',
                                          )),
                                          creditsUsed: functions
                                              .convertToDouble(getJsonField(
                                            (_model.checkoutResult?.jsonBody ??
                                                ''),
                                            r'''$.credits_used''',
                                          )),
                                          appliedVoucherTitle: getJsonField(
                                            (_model.checkoutResult?.jsonBody ??
                                                ''),
                                            r'''$.applied_voucher.title''',
                                          ).toString(),
                                        ),
                                    );
                                    safeSetState(() {});

                                    context.pushNamed(
                                      CheckoutWidget.routeName,
                                      extra: <String, dynamic>{
                                        '__transition_info__': TransitionInfo(
                                          hasTransition: true,
                                          transitionType:
                                              PageTransitionType.fade,
                                          duration: Duration(milliseconds: 0),
                                        ),
                                      },
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          (_model.checkoutResult?.bodyText ??
                                              ''),
                                          style: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                          ),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context).error,
                                      ),
                                    );
                                  }

                                  safeSetState(() {});
                                },
                                text: 'Checkout',
                                options: FFButtonOptions(
                                  width: 200.0,
                                  height: 50.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        letterSpacing: 0.2,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ].divide(SizedBox(width: 16.0)),
                          ),
                        ),
                      ],
                    ),
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
