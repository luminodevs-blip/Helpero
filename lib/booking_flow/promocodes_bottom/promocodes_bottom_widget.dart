import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'promocodes_bottom_model.dart';
export 'promocodes_bottom_model.dart';

class PromocodesBottomWidget extends StatefulWidget {
  const PromocodesBottomWidget({super.key});

  @override
  State<PromocodesBottomWidget> createState() => _PromocodesBottomWidgetState();
}

class _PromocodesBottomWidgetState extends State<PromocodesBottomWidget> {
  late PromocodesBottomModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PromocodesBottomModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.getUserVouchers = await GetUserVouchersCall.call(
        authToken: currentJwtToken,
        cartId: FFAppState().activeBookingDraft.currentCartId,
      );

      if ((_model.getUserVouchers?.succeeded ?? true)) {
        _model.allVouchers = functions
            .parseUserVouchers(getJsonField(
              (_model.getUserVouchers?.jsonBody ?? ''),
              r'''$.vouchers''',
              true,
            ))
            .toList()
            .cast<UserVoucherStruct>();
        safeSetState(() {});
      }
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

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

    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
              child: Container(
                width: 44.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                child: Text(
                  'Apply Vaucher',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 20.0,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.textController',
                            Duration(milliseconds: 2000),
                            () => safeSetState(() {}),
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
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 15.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                            hintText: 'Enter code',
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.outfit(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 15.0,
                                  letterSpacing: 0.2,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 20.0, 16.0, 20.0),
                            suffixIcon: _model.textController!.text.isNotEmpty
                                ? InkWell(
                                    onTap: () async {
                                      _model.textController?.clear();
                                      safeSetState(() {});
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      size: 22,
                                    ),
                                  )
                                : null,
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.outfit(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 14.5,
                                    letterSpacing: 0.2,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                          cursorColor: FlutterFlowTheme.of(context).primaryText,
                          enableInteractiveSelection: true,
                          validator: _model.textControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      _model.claimVoucher = await ClaimVoucherCall.call(
                        authToken: currentJwtToken,
                        code: _model.textController.text,
                      );

                      if ((_model.claimVoucher?.succeeded ?? true)) {
                        safeSetState(() {
                          _model.textController?.clear();
                        });
                        _model.getUserVouchersClaim =
                            await GetUserVouchersCall.call(
                          authToken: currentJwtToken,
                          cartId: FFAppState().activeBookingDraft.currentCartId,
                        );

                        _model.allVouchers = functions
                            .parseUserVouchers(getJsonField(
                              (_model.getUserVouchers?.jsonBody ?? ''),
                              r'''$.vouchers''',
                              true,
                            ))
                            .toList()
                            .cast<UserVoucherStruct>();
                        safeSetState(() {});
                        safeSetState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              getJsonField(
                                (_model.claimVoucher?.jsonBody ?? ''),
                                r'''$.message''',
                              ).toString(),
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                      }

                      safeSetState(() {});
                    },
                    text: 'Apply',
                    options: FFButtonOptions(
                      height: 54.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.outfit(
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                                color: Colors.white,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1.0, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 20.0),
                child: Text(
                  'Available Offers',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        fontSize: 18.0,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.tab = 'all';
                          safeSetState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: valueOrDefault<Color>(
                              _model.tab == 'all'
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                              FlutterFlowTheme.of(context).secondaryBackground,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 16.0, 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Global',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.normal,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: valueOrDefault<Color>(
                                          _model.tab == 'all'
                                              ? FlutterFlowTheme.of(context)
                                                  .secondaryBackground
                                              : FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    _model.allVouchers
                                        .where((e) => e.targetAudience == 'all')
                                        .toList()
                                        .length
                                        .toString(),
                                    '0',
                                  ),
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
                                        color: valueOrDefault<Color>(
                                          _model.tab == 'all'
                                              ? FlutterFlowTheme.of(context)
                                                  .secondaryBackground
                                              : FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _model.tab = 'specific';
                          safeSetState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: valueOrDefault<Color>(
                              _model.tab == 'specific'
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                              FlutterFlowTheme.of(context).secondaryBackground,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 8.0, 16.0, 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Personal',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.normal,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: valueOrDefault<Color>(
                                          _model.tab == 'specific'
                                              ? FlutterFlowTheme.of(context)
                                                  .secondaryBackground
                                              : FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    _model.allVouchers
                                        .where((e) =>
                                            e.targetAudience == 'specific')
                                        .toList()
                                        .length
                                        .toString(),
                                    '0',
                                  ),
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
                                        color: valueOrDefault<Color>(
                                          _model.tab == 'specific'
                                              ? FlutterFlowTheme.of(context)
                                                  .secondaryBackground
                                              : FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                          FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 8.0)),
                  ),
                ),
                Builder(
                  builder: (context) {
                    final vaucher = _model.allVouchers
                        .where((e) => e.targetAudience == _model.tab)
                        .toList();

                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        12.0,
                        0,
                        80.0,
                      ),
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: vaucher.length,
                      separatorBuilder: (_, __) => SizedBox(height: 16.0),
                      itemBuilder: (context, vaucherIndex) {
                        final vaucherItem = vaucher[vaucherIndex];
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (FFAppState()
                                      .activeBookingDraft
                                      .selectedVoucherId ==
                                  vaucherItem.id) {
                                FFAppState().updateActiveBookingDraftStruct(
                                  (e) => e..selectedVoucherId = null,
                                );
                                safeSetState(() {});
                                _model.checkoutResulTrue =
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
                                  voucherId: FFAppState()
                                      .activeBookingDraft
                                      .selectedVoucherId,
                                );

                                if ((_model.checkoutResulTrue?.succeeded ??
                                    true)) {
                                  FFAppState().updateActiveBookingDraftStruct(
                                    (e) => e
                                      ..serverCheckout = ServerCheckoutStruct(
                                        subtotal: getJsonField(
                                          (_model.checkoutResulTrue?.jsonBody ??
                                              ''),
                                          r'''$.subtotal''',
                                        ),
                                        visitFee: getJsonField(
                                          (_model.checkoutResulTrue?.jsonBody ??
                                              ''),
                                          r'''$.visit_fee''',
                                        ),
                                        totalToPay: getJsonField(
                                          (_model.checkoutResulTrue?.jsonBody ??
                                              ''),
                                          r'''$.total_to_pay''',
                                        ),
                                        bookingFee: getJsonField(
                                          (_model.checkoutResulTrue?.jsonBody ??
                                              ''),
                                          r'''$.booking_fee''',
                                        ),
                                        priorityFee: getJsonField(
                                          (_model.checkoutResulTrue?.jsonBody ??
                                              ''),
                                          r'''$.priority_fee''',
                                        ),
                                        taxAmount: getJsonField(
                                          (_model.checkoutResulTrue?.jsonBody ??
                                              ''),
                                          r'''$.tax_amount''',
                                        ),
                                        taxName: getJsonField(
                                          (_model.checkoutResulTrue?.jsonBody ??
                                              ''),
                                          r'''$.tax_name''',
                                        ).toString(),
                                        voucherDiscount: getJsonField(
                                          (_model.checkoutResulTrue?.jsonBody ??
                                              ''),
                                          r'''$.voucher_discount''',
                                        ),
                                        highDemandFee: getJsonField(
                                          (_model.checkoutResulTrue?.jsonBody ??
                                              ''),
                                          r'''$.high_demand_fee''',
                                        ),
                                        creditsUsed: getJsonField(
                                          (_model.checkoutResulTrue?.jsonBody ??
                                              ''),
                                          r'''$.credits_used''',
                                        ),
                                        appliedVoucherTitle: getJsonField(
                                          (_model.checkoutResulTrue?.jsonBody ??
                                              ''),
                                          r'''$.applied_voucher_title''',
                                        ).toString(),
                                      ),
                                  );
                                  _model.updatePage(() {});
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        (_model.checkoutResulTrue?.bodyText ??
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
                              } else {
                                FFAppState().updateActiveBookingDraftStruct(
                                  (e) => e..selectedVoucherId = vaucherItem.id,
                                );
                                safeSetState(() {});
                                _model.checkoutResultFalse =
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
                                  voucherId: FFAppState()
                                      .activeBookingDraft
                                      .selectedVoucherId,
                                );

                                if ((_model.checkoutResultFalse?.succeeded ??
                                    true)) {
                                  FFAppState().updateActiveBookingDraftStruct(
                                    (e) => e
                                      ..serverCheckout = ServerCheckoutStruct(
                                        subtotal: getJsonField(
                                          (_model.checkoutResultFalse
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.subtotal''',
                                        ),
                                        visitFee: getJsonField(
                                          (_model.checkoutResultFalse
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.visit_fee''',
                                        ),
                                        totalToPay: getJsonField(
                                          (_model.checkoutResultFalse
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.total_to_pay''',
                                        ),
                                        bookingFee: getJsonField(
                                          (_model.checkoutResultFalse
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.booking_fee''',
                                        ),
                                        priorityFee: getJsonField(
                                          (_model.checkoutResultFalse
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.priority_fee''',
                                        ),
                                        taxAmount: getJsonField(
                                          (_model.checkoutResultFalse
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.tax_amount''',
                                        ),
                                        taxName: getJsonField(
                                          (_model.checkoutResultFalse
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.tax_name''',
                                        ).toString(),
                                        voucherDiscount: getJsonField(
                                          (_model.checkoutResultFalse
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.voucher_discount''',
                                        ),
                                        highDemandFee: getJsonField(
                                          (_model.checkoutResultFalse
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.high_demand_fee''',
                                        ),
                                        creditsUsed: getJsonField(
                                          (_model.checkoutResultFalse
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.credits_used''',
                                        ),
                                        appliedVoucherTitle: getJsonField(
                                          (_model.checkoutResultFalse
                                                  ?.jsonBody ??
                                              ''),
                                          r'''$.applied_voucher.title''',
                                        ).toString(),
                                      ),
                                  );
                                  _model.updatePage(() {});
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        (_model.checkoutResultFalse?.bodyText ??
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
                              }

                              safeSetState(() {});
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    offset: Offset(
                                      0.0,
                                      2.0,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 0.0, 0.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: valueOrDefault<Color>(
                                      FFAppState()
                                                  .activeBookingDraft
                                                  .selectedVoucherId ==
                                              vaucherItem.id
                                          ? FlutterFlowTheme.of(context)
                                              .primaryBackground
                                          : FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                      FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(0.0),
                                      bottomRight: Radius.circular(8.0),
                                      topLeft: Radius.circular(0.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 16.0, 16.0, 16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 4.0),
                                          child: Text(
                                            vaucherItem.title,
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
                                                  fontSize: 18.0,
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
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 14.0),
                                            child: Text(
                                              vaucherItem.description,
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
                                                    color: FlutterFlowTheme.of(
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
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 10.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 1.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    1.0, 0.0),
                                                child: Text(
                                                  FFAppState()
                                                              .activeBookingDraft
                                                              .selectedVoucherId ==
                                                          vaucherItem.id
                                                      ? 'Selected'
                                                      : 'Select',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        fontSize: 15.0,
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
                                              ),
                                              Text(
                                                functions.getDaysLeftText(
                                                    vaucherItem.expiresAt),
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ].addToStart(SizedBox(height: 16.0)),
        ),
      ),
    );
  }
}
