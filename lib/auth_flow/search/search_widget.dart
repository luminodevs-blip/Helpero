import '/auth_flow/cart_general/cart_general_widget.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/booking_flow/whats_include_bottom/whats_include_bottom_widget.dart';
import '/components/navbar_widget.dart';
import '/components/search_empty_result_widget.dart';
import '/components/service_card_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'search_model.dart';
export 'search_model.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  static String routeName = 'Search';
  static String routePath = '/search';

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late SearchModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.safeSearchResultsPage = await actions.searchServicesNative(
        '',
      );
      _model.firstLoad = false;
      safeSetState(() {});
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

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
          alignment: AlignmentDirectional(0.0, 0.0),
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
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Search service',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.outfit(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.2,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Text(
                                            'Anything, whenever it\'s convenient',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.outfit(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xC6E0E3E7),
                                                  fontSize: 15.0,
                                                  letterSpacing: 0.2,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ].divide(SizedBox(height: 4.0)),
                                      ),
                                    ),
                                    Stack(
                                      alignment:
                                          AlignmentDirectional(1.0, -1.0),
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
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
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        MediaQuery.viewInsetsOf(
                                                            context),
                                                    child: Container(
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          0.95,
                                                      child:
                                                          CartGeneralWidget(),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).then(
                                                (value) => safeSetState(() {}));
                                          },
                                          child: Container(
                                            width: 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25.0),
                                                topRight: Radius.circular(25.0),
                                                bottomLeft:
                                                    Radius.circular(25.0),
                                                bottomRight:
                                                    Radius.circular(25.0),
                                              ),
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: Color(0x6DE0E3E7),
                                                width: 2.0,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.shopping_cart_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              size: 20.0,
                                            ),
                                          ),
                                        ),
                                        if ((FFAppState()
                                                .GeneralCarts
                                                .isNotEmpty) ==
                                            true)
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 2.0, 2.0, 0.0),
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 1.0,
                                              shape: const CircleBorder(),
                                              child: Container(
                                                width: 10.0,
                                                height: 10.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.textController,
                                  focusNode: _model.textFieldFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.textController',
                                    Duration(milliseconds: 2000),
                                    () async {
                                      _model.input = _model.textController.text;
                                      _model.firstLoad = true;
                                      safeSetState(() {});
                                      _model.safeSearchResults =
                                          await actions.searchServicesNative(
                                        _model.textController.text,
                                      );

                                      safeSetState(() {});
                                    },
                                  ),
                                  autofocus: false,
                                  enabled: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                    hintText: 'Mounting, cleaning...',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          fontSize: 16.0,
                                          letterSpacing: 0.2,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Color(0x45FFFFFF),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                  ),
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
                                            .secondaryBackground,
                                        fontSize: 16.0,
                                        letterSpacing: 0.2,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                  cursorColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  enableInteractiveSelection: true,
                                  validator: _model.textControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
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
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 10.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (_model.textController.text ==
                                                    '')
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.0, 0.0),
                                                  child: Text(
                                                    'Trending searches',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .outfit(
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
                                              ),
                                            if (_model.textController.text !=
                                                    '')
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          -1.0, -1.0),
                                                  child: RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Results for: ',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                fontSize: 18.0,
                                                                letterSpacing:
                                                                    0.2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                        TextSpan(
                                                          text: valueOrDefault<
                                                              String>(
                                                            _model.input,
                                                            'Service',
                                                          ),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 18.0,
                                                          ),
                                                        )
                                                      ],
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .outfit(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            fontSize: 18.0,
                                                            letterSpacing: 0.2,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
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
                                            Opacity(
                                              opacity: 0.0,
                                              child: FlutterFlowIconButton(
                                                borderRadius: 26.0,
                                                buttonSize: 40.0,
                                                fillColor: Color(0xFFF5F7FB),
                                                icon: Icon(
                                                  Icons.arrow_forward_rounded,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 24.0,
                                                ),
                                                onPressed: () async {
                                                  context.pushNamed(
                                                    SearchWidget.routeName,
                                                    extra: <String, dynamic>{
                                                      '__transition_info__':
                                                          TransitionInfo(
                                                        hasTransition: true,
                                                        transitionType:
                                                            PageTransitionType
                                                                .fade,
                                                        duration: Duration(
                                                            milliseconds: 0),
                                                      ),
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 1.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                    ),
                                  ],
                                ),
                                if (_model.firstLoad == false)
                                  Builder(
                                    builder: (context) {
                                      final searchResults = _model
                                          .safeSearchResultsPage!
                                          .toList()
                                          .take(10)
                                          .toList();
                                      if (searchResults.isEmpty) {
                                        return SearchEmptyResultWidget();
                                      }

                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: searchResults.length,
                                        itemBuilder:
                                            (context, searchResultsIndex) {
                                          final searchResultsItem =
                                              searchResults[searchResultsIndex];
                                          return wrapWithModel(
                                            model: _model.serviceCardModels1
                                                .getModel(
                                              searchResultsItem.id.toString(),
                                              searchResultsIndex,
                                            ),
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: ServiceCardWidget(
                                              key: Key(
                                                'Keyabv_${searchResultsItem.id.toString()}',
                                              ),
                                              service: searchResultsItem,
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
                                                FFAppState().activeService =
                                                    searchResultsItem;
                                                FFAppState()
                                                    .updateActiveBookingDraftStruct(
                                                  (e) => e
                                                    ..serviceId =
                                                        searchResultsItem.id
                                                    ..serviceName =
                                                        searchResultsItem.name
                                                    ..basePrice =
                                                        searchResultsItem
                                                            .basePrice
                                                    ..configBanner =
                                                        searchResultsItem
                                                            .configBanner
                                                    ..durationMinutes =
                                                        searchResultsItem
                                                            .durationMinutes
                                                    ..address =
                                                        AddressStructStruct(
                                                      id: FFAppState()
                                                          .selectedAddress
                                                          .id,
                                                      nameLabel: FFAppState()
                                                          .selectedAddress
                                                          .nameLabel,
                                                      fullAddress: FFAppState()
                                                          .selectedAddress
                                                          .fullAddress,
                                                      lat: FFAppState()
                                                          .selectedAddress
                                                          .lat,
                                                      lng: FFAppState()
                                                          .selectedAddress
                                                          .lng,
                                                      zipCode: 'M5S 1M4',
                                                      city: 'Toronto',
                                                      isDefault: true,
                                                    )
                                                    ..imageURL =
                                                        searchResultsItem
                                                            .imageUrl
                                                    ..categoryId =
                                                        ServiceCategoryStruct(
                                                      id: searchResultsItem
                                                          .categoryId,
                                                      name: searchResultsItem
                                                          .category,
                                                      imageUrl:
                                                          searchResultsItem
                                                              .categoryImageUrl,
                                                      slug: searchResultsItem
                                                          .categorySlug,
                                                      videoUrl:
                                                          searchResultsItem
                                                              .categoryVideoUrl,
                                                      rating: searchResultsItem
                                                          .categoryRating,
                                                      bookingsCount:
                                                          searchResultsItem
                                                              .categoryBookingsCount,
                                                      packageHeader:
                                                          searchResultsItem
                                                              .categoryPackageHeader,
                                                      miniHeader:
                                                          searchResultsItem
                                                              .categoryMiniHeader,
                                                    )
                                                    ..kitchenDurationMinutes =
                                                        searchResultsItem
                                                            .kitchenDurationMinutes
                                                    ..visit =
                                                        VisitDetailsStruct(
                                                      entryMethod:
                                                          'meet_at_door',
                                                    ),
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
                                                _model.supaRow =
                                                    await ServicesTable()
                                                        .queryRows(
                                                  queryFn: (q) => q.eqOrNull(
                                                    'id',
                                                    searchResultsItem.id,
                                                  ),
                                                );
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
                                                        child: Container(
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.95,
                                                          child:
                                                              WhatsIncludeBottomWidget(
                                                            service: _model
                                                                .supaRow!
                                                                .firstOrNull!,
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
                                                                      .activeService =
                                                                  searchResultsItem;
                                                              FFAppState()
                                                                  .updateActiveBookingDraftStruct(
                                                                (e) => e
                                                                  ..serviceId =
                                                                      searchResultsItem
                                                                          .id
                                                                  ..serviceName =
                                                                      searchResultsItem
                                                                          .name
                                                                  ..basePrice =
                                                                      searchResultsItem
                                                                          .basePrice
                                                                  ..configBanner =
                                                                      searchResultsItem
                                                                          .configBanner
                                                                  ..durationMinutes =
                                                                      searchResultsItem
                                                                          .durationMinutes
                                                                  ..address =
                                                                      AddressStructStruct(
                                                                    id: FFAppState()
                                                                        .selectedAddress
                                                                        .id,
                                                                    nameLabel: FFAppState()
                                                                        .selectedAddress
                                                                        .nameLabel,
                                                                    fullAddress:
                                                                        FFAppState()
                                                                            .selectedAddress
                                                                            .fullAddress,
                                                                    lat: FFAppState()
                                                                        .selectedAddress
                                                                        .lat,
                                                                    lng: FFAppState()
                                                                        .selectedAddress
                                                                        .lng,
                                                                    zipCode:
                                                                        'M5S 1M4',
                                                                    city:
                                                                        'Toronto',
                                                                    isDefault:
                                                                        true,
                                                                  )
                                                                  ..imageURL =
                                                                      searchResultsItem
                                                                          .imageUrl
                                                                  ..categoryId =
                                                                      ServiceCategoryStruct(
                                                                    id: searchResultsItem
                                                                        .categoryId,
                                                                    name: searchResultsItem
                                                                        .category,
                                                                    imageUrl:
                                                                        searchResultsItem
                                                                            .categoryImageUrl,
                                                                    slug: searchResultsItem
                                                                        .categorySlug,
                                                                    videoUrl:
                                                                        searchResultsItem
                                                                            .categoryVideoUrl,
                                                                    rating: searchResultsItem
                                                                        .categoryRating,
                                                                    bookingsCount:
                                                                        searchResultsItem
                                                                            .categoryBookingsCount,
                                                                    packageHeader:
                                                                        searchResultsItem
                                                                            .categoryPackageHeader,
                                                                    miniHeader:
                                                                        searchResultsItem
                                                                            .categoryMiniHeader,
                                                                  )
                                                                  ..kitchenDurationMinutes =
                                                                      searchResultsItem
                                                                          .kitchenDurationMinutes
                                                                  ..visit =
                                                                      VisitDetailsStruct(
                                                                    entryMethod:
                                                                        'meet_at_door',
                                                                  ),
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
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));

                                                safeSetState(() {});
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                if (_model.firstLoad == true)
                                  Builder(
                                    builder: (context) {
                                      final searchResults = _model
                                          .safeSearchResults!
                                          .toList()
                                          .take(10)
                                          .toList();
                                      if (searchResults.isEmpty) {
                                        return SearchEmptyResultWidget();
                                      }

                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: searchResults.length,
                                        itemBuilder:
                                            (context, searchResultsIndex) {
                                          final searchResultsItem =
                                              searchResults[searchResultsIndex];
                                          return wrapWithModel(
                                            model: _model.serviceCardModels2
                                                .getModel(
                                              searchResultsItem.id.toString(),
                                              searchResultsIndex,
                                            ),
                                            updateCallback: () =>
                                                safeSetState(() {}),
                                            child: ServiceCardWidget(
                                              key: Key(
                                                'Keyqrx_${searchResultsItem.id.toString()}',
                                              ),
                                              service: searchResultsItem,
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
                                                FFAppState().activeService =
                                                    searchResultsItem;
                                                FFAppState()
                                                    .updateActiveBookingDraftStruct(
                                                  (e) => e
                                                    ..serviceId =
                                                        searchResultsItem.id
                                                    ..serviceName =
                                                        searchResultsItem.name
                                                    ..basePrice =
                                                        searchResultsItem
                                                            .basePrice
                                                    ..configBanner =
                                                        searchResultsItem
                                                            .configBanner
                                                    ..durationMinutes =
                                                        searchResultsItem
                                                            .durationMinutes
                                                    ..address =
                                                        AddressStructStruct(
                                                      id: FFAppState()
                                                          .selectedAddress
                                                          .id,
                                                      nameLabel: FFAppState()
                                                          .selectedAddress
                                                          .nameLabel,
                                                      fullAddress: FFAppState()
                                                          .selectedAddress
                                                          .fullAddress,
                                                      lat: FFAppState()
                                                          .selectedAddress
                                                          .lat,
                                                      lng: FFAppState()
                                                          .selectedAddress
                                                          .lng,
                                                      zipCode: 'M5S 1M4',
                                                      city: 'Toronto',
                                                      isDefault: true,
                                                    )
                                                    ..imageURL =
                                                        searchResultsItem
                                                            .imageUrl
                                                    ..categoryId =
                                                        ServiceCategoryStruct(
                                                      id: searchResultsItem
                                                          .categoryId,
                                                      name: searchResultsItem
                                                          .category,
                                                      imageUrl:
                                                          searchResultsItem
                                                              .categoryImageUrl,
                                                      slug: searchResultsItem
                                                          .categorySlug,
                                                      videoUrl:
                                                          searchResultsItem
                                                              .categoryVideoUrl,
                                                      rating: searchResultsItem
                                                          .categoryRating,
                                                      bookingsCount:
                                                          searchResultsItem
                                                              .categoryBookingsCount,
                                                      packageHeader:
                                                          searchResultsItem
                                                              .categoryPackageHeader,
                                                      miniHeader:
                                                          searchResultsItem
                                                              .categoryMiniHeader,
                                                    )
                                                    ..kitchenDurationMinutes =
                                                        searchResultsItem
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
                                                _model.supaRow2 =
                                                    await ServicesTable()
                                                        .queryRows(
                                                  queryFn: (q) => q.eqOrNull(
                                                    'id',
                                                    searchResultsItem.id,
                                                  ),
                                                );
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
                                                        child: Container(
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height *
                                                                  0.95,
                                                          child:
                                                              WhatsIncludeBottomWidget(
                                                            service: _model
                                                                .supaRow2!
                                                                .firstOrNull!,
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
                                                                      .activeService =
                                                                  searchResultsItem;
                                                              FFAppState()
                                                                  .updateActiveBookingDraftStruct(
                                                                (e) => e
                                                                  ..serviceId =
                                                                      searchResultsItem
                                                                          .id
                                                                  ..serviceName =
                                                                      searchResultsItem
                                                                          .name
                                                                  ..basePrice =
                                                                      searchResultsItem
                                                                          .basePrice
                                                                  ..configBanner =
                                                                      searchResultsItem
                                                                          .configBanner
                                                                  ..durationMinutes =
                                                                      searchResultsItem
                                                                          .durationMinutes
                                                                  ..address =
                                                                      AddressStructStruct(
                                                                    id: FFAppState()
                                                                        .selectedAddress
                                                                        .id,
                                                                    nameLabel: FFAppState()
                                                                        .selectedAddress
                                                                        .nameLabel,
                                                                    fullAddress:
                                                                        FFAppState()
                                                                            .selectedAddress
                                                                            .fullAddress,
                                                                    lat: FFAppState()
                                                                        .selectedAddress
                                                                        .lat,
                                                                    lng: FFAppState()
                                                                        .selectedAddress
                                                                        .lng,
                                                                    zipCode:
                                                                        'M5S 1M4',
                                                                    city:
                                                                        'Toronto',
                                                                    isDefault:
                                                                        true,
                                                                  )
                                                                  ..imageURL =
                                                                      searchResultsItem
                                                                          .imageUrl
                                                                  ..categoryId =
                                                                      ServiceCategoryStruct(
                                                                    id: searchResultsItem
                                                                        .categoryId,
                                                                    name: searchResultsItem
                                                                        .category,
                                                                    imageUrl:
                                                                        searchResultsItem
                                                                            .categoryImageUrl,
                                                                    slug: searchResultsItem
                                                                        .categorySlug,
                                                                    videoUrl:
                                                                        searchResultsItem
                                                                            .categoryVideoUrl,
                                                                    rating: searchResultsItem
                                                                        .categoryRating,
                                                                    bookingsCount:
                                                                        searchResultsItem
                                                                            .categoryBookingsCount,
                                                                    packageHeader:
                                                                        searchResultsItem
                                                                            .categoryPackageHeader,
                                                                    miniHeader:
                                                                        searchResultsItem
                                                                            .categoryMiniHeader,
                                                                  )
                                                                  ..kitchenDurationMinutes =
                                                                      searchResultsItem
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
                                                      ),
                                                    );
                                                  },
                                                ).then((value) =>
                                                    safeSetState(() {}));

                                                safeSetState(() {});
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                              ]
                                  .addToStart(SizedBox(height: 16.0))
                                  .addToEnd(SizedBox(height: 160.0)),
                            ),
                          ),
                        ),
                      ]
                          .addToStart(SizedBox(
                              height: valueOrDefault<double>(
                            isWeb ? 16.0 : 44.0,
                            44.0,
                          )))
                          .addToEnd(SizedBox(height: 112.0)),
                    ),
                  ),
                ),
                wrapWithModel(
                  model: _model.navbarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavbarWidget(
                    activePage: 'Search',
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
