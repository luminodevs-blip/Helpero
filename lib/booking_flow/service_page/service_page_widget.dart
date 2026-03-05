import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/booking_flow/new/category_promo_card/category_promo_card_widget.dart';
import '/booking_flow/whats_include_bottom/whats_include_bottom_widget.dart';
import '/components/service_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/updates_folder/subscription_bottom/subscription_bottom_widget.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'service_page_model.dart';
export 'service_page_model.dart';

class ServicePageWidget extends StatefulWidget {
  const ServicePageWidget({
    super.key,
    this.category,
  });

  final ServiceCategoryStruct? category;

  static String routeName = 'ServicePage';
  static String routePath = '/servicepage';

  @override
  State<ServicePageWidget> createState() => _ServicePageWidgetState();
}

class _ServicePageWidgetState extends State<ServicePageWidget> {
  late ServicePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ServicePageModel());

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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Align(
          alignment: AlignmentDirectional(0.0, -1.0),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 450.0,
              maxHeight: 1000.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 450.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          FlutterFlowVideoPlayer(
                            path: valueOrDefault<String>(
                              widget.category?.videoUrl,
                              'https://assets.mixkit.co/videos/21380/21380-720.mp4',
                            ),
                            videoType: VideoType.network,
                            autoPlay: true,
                            looping: true,
                            showControls: false,
                            allowFullScreen: false,
                            allowPlaybackSpeedMenu: false,
                          ),
                          Container(
                            width: double.infinity,
                            height: 300.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0x0F14181B), Color(0x0014181B)],
                                stops: [0.4, 1.0],
                                begin: AlignmentDirectional(0.0, -1.0),
                                end: AlignmentDirectional(0, 1.0),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 210.0,
                                decoration: BoxDecoration(
                                  color: Color(0x1F000000),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          FlutterFlowIconButton(
                                            borderColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            borderRadius: 25.0,
                                            borderWidth: 1.0,
                                            buttonSize: 40.0,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            icon: Icon(
                                              Icons.arrow_back_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              context.goNamed(
                                                GeneralWidget.routeName,
                                                extra: <String, dynamic>{
                                                  '__transition_info__':
                                                      TransitionInfo(
                                                    hasTransition: true,
                                                    transitionType:
                                                        PageTransitionType.fade,
                                                    duration: Duration(
                                                        milliseconds: 0),
                                                  ),
                                                },
                                              );
                                            },
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: 100.0,
                                              height: 1.0,
                                              decoration: BoxDecoration(),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Builder(
                                              builder: (context) =>
                                                  FlutterFlowIconButton(
                                                borderColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                borderRadius: 25.0,
                                                borderWidth: 1.0,
                                                buttonSize: 40.0,
                                                fillColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                icon: Icon(
                                                  Icons.share_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 20.0,
                                                ),
                                                onPressed: () async {
                                                  await Share.share(
                                                    'helpero://helpero.com${GoRouterState.of(context).uri.toString()}',
                                                    sharePositionOrigin:
                                                        getWidgetBoundingBox(
                                                            context),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]
                                        .divide(SizedBox(height: 10.0))
                                        .addToStart(SizedBox(height: 12.0)),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0.0),
                                    bottomRight: Radius.circular(0.0),
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 0.0, 6.0),
                                        child: RichText(
                                          textScaler:
                                              MediaQuery.of(context).textScaler,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: valueOrDefault<String>(
                                                  widget.category?.name,
                                                  'Cleaning',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.outfit(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      fontSize: 24.0,
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
                                                text: ' Services',
                                                style: TextStyle(),
                                              )
                                            ],
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.outfit(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  fontSize: 24.0,
                                                  letterSpacing: 0.2,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 16.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 4.0, 4.0, 0.0),
                                            child: Icon(
                                              Icons.star_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 18.0,
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 1.0),
                                                child: RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: valueOrDefault<
                                                            String>(
                                                          widget
                                                              .category?.rating
                                                              .toString(),
                                                          '4.92',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .outfit(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.2,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                      TextSpan(
                                                        text: ' ( ',
                                                        style: TextStyle(),
                                                      ),
                                                      TextSpan(
                                                        text: valueOrDefault<
                                                            String>(
                                                          widget.category
                                                              ?.bookingsCount,
                                                          '182',
                                                        ),
                                                        style: TextStyle(),
                                                      ),
                                                      TextSpan(
                                                        text: ' bookings)',
                                                        style: TextStyle(),
                                                      )
                                                    ],
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
                                                          fontSize: 14.0,
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
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 4.0,
                                                    height: 1.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xA514181B),
                                                    ),
                                                  ),
                                                ].divide(SizedBox(width: 2.0)),
                                              ),
                                            ].divide(SizedBox(height: 1.0)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 14.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 70.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 6.0),
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
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
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
                                                                SubscriptionBottomWidget(),
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  child: Container(
                                                    height: 60.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      border: Border.all(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  6.0,
                                                                  14.0,
                                                                  6.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            4.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .discount,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  size: 14.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Get Subscription Helpero Plus',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .outfit(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      fontSize:
                                                                          14.0,
                                                                      letterSpacing:
                                                                          0.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                            ].divide(SizedBox(
                                                                width: 8.0)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        22.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              'Use service without fee',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .outfit(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                    fontSize:
                                                                        14.0,
                                                                    letterSpacing:
                                                                        0.2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 2.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              FutureBuilder<ApiCallResponse>(
                                                future: GetPromotionsCall.call(
                                                  categoryId:
                                                      widget.category?.id,
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 10.0,
                                                        height: 10.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            Colors.transparent,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  final listViewGetPromotionsResponse =
                                                      snapshot.data!;

                                                  return Builder(
                                                    builder: (context) {
                                                      final promotions =
                                                          getJsonField(
                                                        listViewGetPromotionsResponse
                                                            .jsonBody,
                                                        r'''$.promotions''',
                                                      ).toList();

                                                      return ListView.separated(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        primary: false,
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            promotions.length,
                                                        separatorBuilder:
                                                            (_, __) => SizedBox(
                                                                width: 14.0),
                                                        itemBuilder: (context,
                                                            promotionsIndex) {
                                                          final promotionsItem =
                                                              promotions[
                                                                  promotionsIndex];
                                                          return CategoryPromoCardWidget(
                                                            key: Key(
                                                                'Key8hk_${promotionsIndex}_of_${promotions.length}'),
                                                            title: getJsonField(
                                                              promotionsItem,
                                                              r'''$.title''',
                                                            ).toString(),
                                                            subtitle:
                                                                getJsonField(
                                                              promotionsItem,
                                                              r'''$.subtitle''',
                                                            ).toString(),
                                                            color: '#7B82F4',
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ]
                                                .divide(SizedBox(width: 14.0))
                                                .addToStart(
                                                    SizedBox(width: 16.0))
                                                .addToEnd(
                                                    SizedBox(width: 16.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 22.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                        ),
                                      ),
                                    ),
                                    if (widget.category?.packageHeader !=
                                            null &&
                                        widget.category?.packageHeader != '')
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 0.0, 16.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    widget.category
                                                        ?.packageHeader,
                                                    'Packages',
                                                  ),
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
                                                        fontSize: 20.0,
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    Container(
                                      width: double.infinity,
                                      height: 1.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                    ),
                                    FutureBuilder<List<ServicesRow>>(
                                      future: ServicesTable().queryRows(
                                        queryFn: (q) => q
                                            .eqOrNull(
                                              'category_id',
                                              widget.category?.id,
                                            )
                                            .eqOrNull(
                                              'group_type',
                                              'package',
                                            )
                                            .order('sort_order',
                                                ascending: true),
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 10.0,
                                              height: 10.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<ServicesRow>
                                            listViewServicesRowList =
                                            snapshot.data!;

                                        return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              listViewServicesRowList.length,
                                          itemBuilder:
                                              (context, listViewIndex) {
                                            final listViewServicesRow =
                                                listViewServicesRowList[
                                                    listViewIndex];
                                            return wrapWithModel(
                                              model: _model.serviceCardModels1
                                                  .getModel(
                                                listViewServicesRow.id
                                                    .toString(),
                                                listViewIndex,
                                              ),
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: ServiceCardWidget(
                                                key: Key(
                                                  'Keyuwq_${listViewServicesRow.id.toString()}',
                                                ),
                                                service: ServicePackageStruct(
                                                  id: listViewServicesRow.id,
                                                  name:
                                                      listViewServicesRow.name,
                                                  imageUrl: listViewServicesRow
                                                      .imageUrl,
                                                  shortDescription:
                                                      listViewServicesRow
                                                          .description,
                                                  groupType: listViewServicesRow
                                                      .groupType,
                                                  basePrice: listViewServicesRow
                                                      .basePrice,
                                                  flowType: listViewServicesRow
                                                      .flowType,
                                                  rating: listViewServicesRow
                                                      .rating,
                                                  reviewsCount:
                                                      listViewServicesRow
                                                          .reviewsCount,
                                                  categoryId:
                                                      listViewServicesRow
                                                          .categoryId,
                                                  allowedZoneIds:
                                                      listViewServicesRow
                                                          .allowedZoneIds,
                                                  cardBullets:
                                                      (listViewServicesRow
                                                                  .cardBullets
                                                              as List?)
                                                          ?.map<String>((e) =>
                                                              e.toString())
                                                          .toList()
                                                          .cast<String>(),
                                                  durationMinutes:
                                                      listViewServicesRow
                                                          .durationMinutes,
                                                ),
                                                navigate: () async {
                                                  FFAppState()
                                                      .deleteActiveBookingDraft();
                                                  FFAppState()
                                                          .activeBookingDraft =
                                                      BookingDraftStruct
                                                          .fromSerializableMap(
                                                              jsonDecode(
                                                                  '{\"selectedAddons\":\"[]\",\"visit\":\"{\\\"arrivalType\\\":\\\"standard\\\"}\"}'));

                                                  FFAppState().activeService =
                                                      ServicePackageStruct();
                                                  safeSetState(() {});
                                                  FFAppState()
                                                      .updateActiveServiceStruct(
                                                    (e) => e
                                                      ..id =
                                                          listViewServicesRow.id
                                                      ..name =
                                                          listViewServicesRow
                                                              .name
                                                      ..basePrice =
                                                          listViewServicesRow
                                                              .basePrice
                                                      ..configBanner =
                                                          listViewServicesRow
                                                              .configBanner
                                                      ..configHeader1 =
                                                          listViewServicesRow
                                                              .configHeader1
                                                      ..configHeader2 =
                                                          listViewServicesRow
                                                              .configHeader2,
                                                  );
                                                  FFAppState()
                                                      .updateActiveBookingDraftStruct(
                                                    (e) => e
                                                      ..serviceId =
                                                          listViewServicesRow.id
                                                      ..serviceName =
                                                          listViewServicesRow
                                                              .name
                                                      ..basePrice =
                                                          listViewServicesRow
                                                              .basePrice
                                                      ..configBanner =
                                                          listViewServicesRow
                                                              .configBanner
                                                      ..durationMinutes =
                                                          listViewServicesRow
                                                              .durationMinutes
                                                      ..address =
                                                          AddressStructStruct(
                                                        id: 33,
                                                        nameLabel: 'My House',
                                                        fullAddress:
                                                            '100 Bloor St W, Toronto, ON M5S 1M4',
                                                        lat: 43.6708,
                                                        lng: -79.3933,
                                                        zipCode: 'M5S 1M4',
                                                        city: 'Toronto',
                                                        isDefault: true,
                                                      )
                                                      ..imageURL =
                                                          listViewServicesRow
                                                              .imageUrl
                                                      ..categoryId =
                                                          ServiceCategoryStruct(
                                                        id: widget
                                                            .category?.id,
                                                        name: widget
                                                            .category?.name,
                                                        slug: widget
                                                            .category?.slug,
                                                        imageUrl: widget
                                                            .category?.imageUrl,
                                                        rating: widget
                                                            .category?.rating,
                                                        packageHeader: widget
                                                            .category
                                                            ?.packageHeader,
                                                        bookingsCount: widget
                                                            .category
                                                            ?.bookingsCount,
                                                        miniHeader: widget
                                                            .category
                                                            ?.miniHeader,
                                                      )
                                                      ..kitchenDurationMinutes =
                                                          listViewServicesRow
                                                              .kitchenDurationMinutes,
                                                  );
                                                  safeSetState(() {});

                                                  context.pushNamed(
                                                    AddToCartAnimationWidget
                                                        .routeName,
                                                    extra: <String, dynamic>{
                                                      '__transition_info__':
                                                          TransitionInfo(
                                                        hasTransition: true,
                                                        transitionType:
                                                            PageTransitionType
                                                                .fade,
                                                      ),
                                                    },
                                                  );
                                                },
                                                bottom: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              WhatsIncludeBottomWidget(
                                                            service:
                                                                listViewServicesRow,
                                                            navigate: () async {
                                                              FFAppState()
                                                                  .deleteActiveBookingDraft();
                                                              FFAppState()
                                                                      .activeBookingDraft =
                                                                  BookingDraftStruct
                                                                      .fromSerializableMap(
                                                                          jsonDecode(
                                                                              '{\"selectedAddons\":\"[]\",\"visit\":\"{\\\"arrivalType\\\":\\\"standard\\\"}\"}'));

                                                              FFAppState()
                                                                      .activeService =
                                                                  ServicePackageStruct();
                                                              safeSetState(
                                                                  () {});
                                                              FFAppState()
                                                                  .updateActiveServiceStruct(
                                                                (e) => e
                                                                  ..id =
                                                                      listViewServicesRow
                                                                          .id
                                                                  ..name =
                                                                      listViewServicesRow
                                                                          .name
                                                                  ..basePrice =
                                                                      listViewServicesRow
                                                                          .basePrice
                                                                  ..configBanner =
                                                                      listViewServicesRow
                                                                          .configBanner
                                                                  ..configHeader1 =
                                                                      listViewServicesRow
                                                                          .configHeader1
                                                                  ..configHeader2 =
                                                                      listViewServicesRow
                                                                          .configHeader2,
                                                              );
                                                              FFAppState()
                                                                  .updateActiveBookingDraftStruct(
                                                                (e) => e
                                                                  ..serviceId =
                                                                      listViewServicesRow
                                                                          .id
                                                                  ..serviceName =
                                                                      listViewServicesRow
                                                                          .name
                                                                  ..basePrice =
                                                                      listViewServicesRow
                                                                          .basePrice
                                                                  ..configBanner =
                                                                      listViewServicesRow
                                                                          .configBanner
                                                                  ..durationMinutes =
                                                                      listViewServicesRow
                                                                          .durationMinutes
                                                                  ..address =
                                                                      AddressStructStruct(
                                                                    id: 33,
                                                                    nameLabel:
                                                                        'My House',
                                                                    fullAddress:
                                                                        '100 Bloor St W, Toronto, ON M5S 1M4',
                                                                    lat:
                                                                        43.6708,
                                                                    lng:
                                                                        -79.3933,
                                                                    zipCode:
                                                                        'M5S 1M4',
                                                                    city:
                                                                        'Toronto',
                                                                    isDefault:
                                                                        true,
                                                                  )
                                                                  ..imageURL =
                                                                      listViewServicesRow
                                                                          .imageUrl
                                                                  ..categoryId =
                                                                      ServiceCategoryStruct(
                                                                    id: widget
                                                                        .category
                                                                        ?.id,
                                                                    name: widget
                                                                        .category
                                                                        ?.name,
                                                                    slug: widget
                                                                        .category
                                                                        ?.slug,
                                                                    imageUrl: widget
                                                                        .category
                                                                        ?.imageUrl,
                                                                    rating: widget
                                                                        .category
                                                                        ?.rating,
                                                                    packageHeader: widget
                                                                        .category
                                                                        ?.packageHeader,
                                                                    bookingsCount: widget
                                                                        .category
                                                                        ?.bookingsCount,
                                                                    miniHeader: widget
                                                                        .category
                                                                        ?.miniHeader,
                                                                  )
                                                                  ..kitchenDurationMinutes =
                                                                      listViewServicesRow
                                                                          .kitchenDurationMinutes,
                                                              );
                                                              safeSetState(
                                                                  () {});

                                                              context.pushNamed(
                                                                AddToCartAnimationWidget
                                                                    .routeName,
                                                                extra: <String,
                                                                    dynamic>{
                                                                  '__transition_info__':
                                                                      TransitionInfo(
                                                                    hasTransition:
                                                                        true,
                                                                    transitionType:
                                                                        PageTransitionType
                                                                            .fade,
                                                                  ),
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 22.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                        ),
                                      ),
                                    ),
                                    if (widget.category?.miniHeader != null &&
                                        widget.category?.miniHeader != '')
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    widget
                                                        .category?.miniHeader,
                                                    'Mini Services',
                                                  ),
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
                                                        fontSize: 20.0,
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    Container(
                                      width: double.infinity,
                                      height: 1.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                    ),
                                    FutureBuilder<List<ServicesRow>>(
                                      future: ServicesTable().queryRows(
                                        queryFn: (q) => q
                                            .eqOrNull(
                                              'category_id',
                                              widget.category?.id,
                                            )
                                            .eqOrNull(
                                              'group_type',
                                              'mini',
                                            )
                                            .order('sort_order',
                                                ascending: true),
                                      ),
                                      builder: (context, snapshot) {
                                        // Customize what your widget looks like when it's loading.
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: SizedBox(
                                              width: 10.0,
                                              height: 10.0,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        List<ServicesRow>
                                            listViewServicesRowList =
                                            snapshot.data!;

                                        return ListView.builder(
                                          padding: EdgeInsets.fromLTRB(
                                            0,
                                            0,
                                            0,
                                            140.0,
                                          ),
                                          primary: false,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              listViewServicesRowList.length,
                                          itemBuilder:
                                              (context, listViewIndex) {
                                            final listViewServicesRow =
                                                listViewServicesRowList[
                                                    listViewIndex];
                                            return wrapWithModel(
                                              model: _model.serviceCardModels2
                                                  .getModel(
                                                listViewServicesRow.id
                                                    .toString(),
                                                listViewIndex,
                                              ),
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: ServiceCardWidget(
                                                key: Key(
                                                  'Key2mw_${listViewServicesRow.id.toString()}',
                                                ),
                                                service: ServicePackageStruct(
                                                  id: listViewServicesRow.id,
                                                  name:
                                                      listViewServicesRow.name,
                                                  imageUrl: listViewServicesRow
                                                      .imageUrl,
                                                  shortDescription:
                                                      listViewServicesRow
                                                          .description,
                                                  groupType: listViewServicesRow
                                                      .groupType,
                                                  basePrice: listViewServicesRow
                                                      .basePrice,
                                                  flowType: listViewServicesRow
                                                      .flowType,
                                                  rating: listViewServicesRow
                                                      .rating,
                                                  reviewsCount:
                                                      listViewServicesRow
                                                          .reviewsCount,
                                                  categoryId:
                                                      listViewServicesRow
                                                          .categoryId,
                                                  allowedZoneIds:
                                                      listViewServicesRow
                                                          .allowedZoneIds,
                                                  cardBullets:
                                                      (listViewServicesRow
                                                                  .cardBullets
                                                              as List?)
                                                          ?.map<String>((e) =>
                                                              e.toString())
                                                          .toList()
                                                          .cast<String>(),
                                                  durationMinutes:
                                                      listViewServicesRow
                                                          .durationMinutes,
                                                ),
                                                navigate: () async {
                                                  FFAppState()
                                                      .deleteActiveBookingDraft();
                                                  FFAppState()
                                                          .activeBookingDraft =
                                                      BookingDraftStruct
                                                          .fromSerializableMap(
                                                              jsonDecode(
                                                                  '{\"selectedAddons\":\"[]\",\"visit\":\"{\\\"arrivalType\\\":\\\"standard\\\"}\"}'));

                                                  FFAppState().activeService =
                                                      ServicePackageStruct();
                                                  safeSetState(() {});
                                                  FFAppState()
                                                      .updateActiveServiceStruct(
                                                    (e) => e
                                                      ..id =
                                                          listViewServicesRow.id
                                                      ..name =
                                                          listViewServicesRow
                                                              .name
                                                      ..basePrice =
                                                          listViewServicesRow
                                                              .basePrice
                                                      ..configBanner =
                                                          listViewServicesRow
                                                              .configBanner
                                                      ..configHeader1 =
                                                          listViewServicesRow
                                                              .configHeader1
                                                      ..configHeader2 =
                                                          listViewServicesRow
                                                              .configHeader2,
                                                  );
                                                  FFAppState()
                                                      .updateActiveBookingDraftStruct(
                                                    (e) => e
                                                      ..categoryId =
                                                          ServiceCategoryStruct(
                                                        id: widget
                                                            .category?.id,
                                                        name: widget
                                                            .category?.name,
                                                        slug: widget
                                                            .category?.slug,
                                                        imageUrl: widget
                                                            .category?.imageUrl,
                                                      )
                                                      ..serviceId =
                                                          listViewServicesRow.id
                                                      ..serviceName =
                                                          listViewServicesRow
                                                              .name
                                                      ..imageURL =
                                                          listViewServicesRow
                                                              .imageUrl
                                                      ..basePrice =
                                                          listViewServicesRow
                                                              .basePrice
                                                      ..address =
                                                          AddressStructStruct(
                                                        id: 33,
                                                        nameLabel: 'My House',
                                                        fullAddress:
                                                            '100 Bloor St W, Toronto, ON M5S 1M4',
                                                        lat: 43.6708,
                                                        lng: -79.3933,
                                                        zipCode: 'M5S 1M4',
                                                        city: 'Toronto',
                                                      )
                                                      ..kitchenDurationMinutes =
                                                          listViewServicesRow
                                                              .kitchenDurationMinutes,
                                                  );
                                                  safeSetState(() {});

                                                  context.pushNamed(
                                                    AddToCartAnimationWidget
                                                        .routeName,
                                                    extra: <String, dynamic>{
                                                      '__transition_info__':
                                                          TransitionInfo(
                                                        hasTransition: true,
                                                        transitionType:
                                                            PageTransitionType
                                                                .fade,
                                                      ),
                                                    },
                                                  );
                                                },
                                                bottom: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                        },
                                                        child: Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              WhatsIncludeBottomWidget(
                                                            service:
                                                                listViewServicesRow,
                                                            navigate: () async {
                                                              FFAppState()
                                                                  .deleteActiveBookingDraft();
                                                              FFAppState()
                                                                      .activeBookingDraft =
                                                                  BookingDraftStruct
                                                                      .fromSerializableMap(
                                                                          jsonDecode(
                                                                              '{\"selectedAddons\":\"[]\",\"visit\":\"{\\\"arrivalType\\\":\\\"standard\\\"}\"}'));

                                                              FFAppState()
                                                                      .activeService =
                                                                  ServicePackageStruct();
                                                              safeSetState(
                                                                  () {});
                                                              FFAppState()
                                                                  .updateActiveServiceStruct(
                                                                (e) => e
                                                                  ..id =
                                                                      listViewServicesRow
                                                                          .id
                                                                  ..name =
                                                                      listViewServicesRow
                                                                          .name
                                                                  ..basePrice =
                                                                      listViewServicesRow
                                                                          .basePrice
                                                                  ..configBanner =
                                                                      listViewServicesRow
                                                                          .configBanner
                                                                  ..configHeader1 =
                                                                      listViewServicesRow
                                                                          .configHeader1
                                                                  ..configHeader2 =
                                                                      listViewServicesRow
                                                                          .configHeader2,
                                                              );
                                                              FFAppState()
                                                                  .updateActiveBookingDraftStruct(
                                                                (e) => e
                                                                  ..categoryId =
                                                                      ServiceCategoryStruct(
                                                                    id: widget
                                                                        .category
                                                                        ?.id,
                                                                    name: widget
                                                                        .category
                                                                        ?.name,
                                                                    slug: widget
                                                                        .category
                                                                        ?.slug,
                                                                    imageUrl: widget
                                                                        .category
                                                                        ?.imageUrl,
                                                                  )
                                                                  ..serviceId =
                                                                      listViewServicesRow
                                                                          .id
                                                                  ..serviceName =
                                                                      listViewServicesRow
                                                                          .name
                                                                  ..imageURL =
                                                                      listViewServicesRow
                                                                          .imageUrl
                                                                  ..basePrice =
                                                                      listViewServicesRow
                                                                          .basePrice
                                                                  ..address =
                                                                      AddressStructStruct(
                                                                    id: 33,
                                                                    nameLabel:
                                                                        'My House',
                                                                    fullAddress:
                                                                        '100 Bloor St W, Toronto, ON M5S 1M4',
                                                                    lat:
                                                                        43.6708,
                                                                    lng:
                                                                        -79.3933,
                                                                    zipCode:
                                                                        'M5S 1M4',
                                                                    city:
                                                                        'Toronto',
                                                                  )
                                                                  ..kitchenDurationMinutes =
                                                                      listViewServicesRow
                                                                          .kitchenDurationMinutes,
                                                              );
                                                              safeSetState(
                                                                  () {});

                                                              context.pushNamed(
                                                                AddToCartAnimationWidget
                                                                    .routeName,
                                                                extra: <String,
                                                                    dynamic>{
                                                                  '__transition_info__':
                                                                      TransitionInfo(
                                                                    hasTransition:
                                                                        true,
                                                                    transitionType:
                                                                        PageTransitionType
                                                                            .fade,
                                                                  ),
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ]
                                      .addToStart(SizedBox(height: 10.0))
                                      .addToEnd(SizedBox(height: 100.0)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ].addToStart(SizedBox(height: 48.0)),
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
