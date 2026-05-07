import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_list_model.dart';
export 'chat_list_model.dart';

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({super.key});

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  late ChatListModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatListModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Container(
              decoration: BoxDecoration(),
              child: StreamBuilder<List<SupportMessagesRow>>(
                stream: _model.chatListSupabaseStream ??= SupaFlow.client
                    .from("support_messages")
                    .stream(primaryKey: ['id'])
                    .eqOrNull(
                      'user_id',
                      currentUserUid,
                    )
                    .order('created_at')
                    .map((list) =>
                        list.map((item) => SupportMessagesRow(item)).toList()),
                builder: (context, snapshot) {
                  // Customize what your widget looks like when it's loading.
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 10.0,
                        height: 10.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.transparent,
                          ),
                        ),
                      ),
                    );
                  }
                  List<SupportMessagesRow> chatListSupportMessagesRowList =
                      snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      30.0,
                      0,
                      90.0,
                    ),
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: chatListSupportMessagesRowList.length,
                    itemBuilder: (context, chatListIndex) {
                      final chatListSupportMessagesRow =
                          chatListSupportMessagesRowList[chatListIndex];
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (chatListSupportMessagesRow.type == 'header')
                            Expanded(
                              child: Align(
                                alignment: AlignmentDirectional(0.0, -1.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Text(
                                        'We are always ready to help you!',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 17.0,
                                              letterSpacing: 0.2,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 0.0, 20.0),
                                        child: Text(
                                          'Select the category of the problem:',
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
                                                fontSize: 17.0,
                                                letterSpacing: 0.2,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8.0, 0.0, 8.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
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
                                                    await SupportMessagesTable()
                                                        .insert({
                                                      'is_user': true,
                                                      'type': 'text',
                                                      'message': 'Booking',
                                                    });
                                                    await Future.delayed(
                                                      Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                    await SupportMessagesTable()
                                                        .insert({
                                                      'is_user': false,
                                                      'message':
                                                          'Here are some frequently asked questions related to the topic of “Booking”:',
                                                      'type': 'faq_list',
                                                      'faq': 'Booking',
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
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
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Text(
                                                        'Booking',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .outfit(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                              fontSize: 15.0,
                                                              letterSpacing:
                                                                  0.2,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                              ),
                                              Expanded(
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
                                                    await SupportMessagesTable()
                                                        .insert({
                                                      'message': 'Payment',
                                                      'is_user': true,
                                                      'type': 'text',
                                                    });
                                                    await Future.delayed(
                                                      Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                    await SupportMessagesTable()
                                                        .insert({
                                                      'is_user': false,
                                                      'message':
                                                          'Here are some frequently asked questions related to the topic of “Payment”:',
                                                      'type': 'faq_list',
                                                      'faq': 'Payment',
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
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
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Text(
                                                        'Payment',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .outfit(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                              fontSize: 15.0,
                                                              letterSpacing:
                                                                  0.2,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
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
                                                    await SupportMessagesTable()
                                                        .insert({
                                                      'message':
                                                          'Safety & trust',
                                                      'is_user': true,
                                                      'type': 'text',
                                                    });
                                                    await Future.delayed(
                                                      Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                    await SupportMessagesTable()
                                                        .insert({
                                                      'is_user': false,
                                                      'message':
                                                          'Here are some frequently asked questions related to the topic of “Safety & trust”:',
                                                      'type': 'faq_list',
                                                      'faq': 'Safety & trust',
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
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
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Text(
                                                        'Safety & trust',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .outfit(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                              fontSize: 15.0,
                                                              letterSpacing:
                                                                  0.2,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                              ),
                                              Expanded(
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
                                                    await SupportMessagesTable()
                                                        .insert({
                                                      'message': 'My account',
                                                      'is_user': true,
                                                      'type': 'text',
                                                    });
                                                    await Future.delayed(
                                                      Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                    await SupportMessagesTable()
                                                        .insert({
                                                      'is_user': false,
                                                      'message':
                                                          'Here are some frequently asked questions related to the topic of “My account”:',
                                                      'type': 'faq_list',
                                                      'faq': 'My account',
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
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
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Text(
                                                        'My account',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .outfit(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                              fontSize: 15.0,
                                                              letterSpacing:
                                                                  0.2,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
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
                                                    await SupportMessagesTable()
                                                        .insert({
                                                      'message': 'My orders',
                                                      'is_user': true,
                                                      'type': 'text',
                                                    });
                                                    await Future.delayed(
                                                      Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                    await SupportMessagesTable()
                                                        .insert({
                                                      'is_user': false,
                                                      'message':
                                                          'Here are some frequently asked questions related to the topic of “My orders”:',
                                                      'type': 'faq_list',
                                                      'faq': 'My orders',
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
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
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Text(
                                                        'My orders',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .outfit(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                              fontSize: 15.0,
                                                              letterSpacing:
                                                                  0.2,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                              ),
                                              Expanded(
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
                                                    await SupportMessagesTable()
                                                        .insert({
                                                      'message': 'Subscription',
                                                      'is_user': true,
                                                      'type': 'text',
                                                    });
                                                    await Future.delayed(
                                                      Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                    await SupportMessagesTable()
                                                        .insert({
                                                      'is_user': false,
                                                      'message':
                                                          'Here are some frequently asked questions related to the topic of “Subscription”:',
                                                      'type': 'faq_list',
                                                      'faq': 'Subscription',
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
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
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Text(
                                                        'Subscription',
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .outfit(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                              fontSize: 15.0,
                                                              letterSpacing:
                                                                  0.2,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                              ),
                                            ].divide(SizedBox(width: 12.0)),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 0.0, 0.0, 16.0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message': 'Other',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 600,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': false,
                                                    'message':
                                                        'Please tell us about your problem....',
                                                  });
                                                },
                                                child: Container(
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
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
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      'Other',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            font: GoogleFonts
                                                                .outfit(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
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
                                                ),
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 12.0)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if ((chatListSupportMessagesRow.isUser == true) &&
                              (chatListSupportMessagesRow.type == 'text'))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 300.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC7C9EA),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x33000000),
                                          offset: Offset(
                                            0.0,
                                            2.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              chatListSupportMessagesRow
                                                  .message,
                                              'New  Messages',
                                            ),
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
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
                                                      .primaryText,
                                                  fontSize: 14.5,
                                                  letterSpacing: 0.2,
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                  lineHeight: 1.4,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if ((chatListSupportMessagesRow.isUser == true) &&
                              (chatListSupportMessagesRow.type == 'media'))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 300.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC7C9EA),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4.0,
                                          color: Color(0x33000000),
                                          offset: Offset(
                                            0.0,
                                            2.0,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8.0),
                                              topRight: Radius.circular(8.0),
                                              bottomLeft: Radius.circular(8.0),
                                            ),
                                            child: Image.network(
                                              chatListSupportMessagesRow
                                                  .message!,
                                              width: 200.0,
                                              height: 200.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (chatListSupportMessagesRow.type == 'Order')
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  40.0, 20.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 570.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 4.0,
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            offset: Offset(
                                              0.0,
                                              2.0,
                                            ),
                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 12.0, 12.0, 12.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.asset(
                                                    'assets/images/cleaning.png',
                                                    width: 40.0,
                                                    height: 40.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        RichText(
                                                          textScaler:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .textScaler,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    'Painting',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .outfit(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryText,
                                                                      fontSize:
                                                                          16.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              TextSpan(
                                                                text: ' - ',
                                                                style:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    'Restaurant',
                                                                style:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                ),
                                                              )
                                                            ],
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .outfit(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      15.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  4.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Full fasad painting',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .outfit(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      14.0,
                                                                  letterSpacing:
                                                                      0.2,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  4.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Fri. July 3rd',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .outfit(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  fontSize:
                                                                      14.5,
                                                                  letterSpacing:
                                                                      0.2,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium
                                                                      .fontStyle,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ].divide(SizedBox(width: 16.0)),
                                            ),
                                            Text(
                                              '\$78.50',
                                              textAlign: TextAlign.end,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .headlineSmall
                                                  .override(
                                                    font: GoogleFonts.outfit(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineSmall
                                                              .fontStyle,
                                                    ),
                                                    fontSize: 15.0,
                                                    letterSpacing: 0.2,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineSmall
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if ((chatListSupportMessagesRow.type == 'text') &&
                              (chatListSupportMessagesRow.isUser == false))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 2.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(),
                                          child: Icon(
                                            Icons.support_agent,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 18.0,
                                          ),
                                        ),
                                        Text(
                                          'Support',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 13.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ].divide(SizedBox(width: 4.0)),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 300.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4.0,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              offset: Offset(
                                                0.0,
                                                2.0,
                                              ),
                                            )
                                          ],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              custom_widgets.TypewriterText(
                                                width: 2000.0,
                                                height: 200.0,
                                                text: valueOrDefault<String>(
                                                  chatListSupportMessagesRow
                                                      .message,
                                                  'New  Messages',
                                                ),
                                                fontSize: 14.5,
                                                textColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                speedMs: 45,
                                                showCursor: true,
                                                skippable: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          if ((chatListSupportMessagesRow.isUser == false) &&
                              (chatListSupportMessagesRow.type == 'faq_list'))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 2.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(),
                                          child: Icon(
                                            Icons.support_agent,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 18.0,
                                          ),
                                        ),
                                        Text(
                                          'Support',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 13.0,
                                                letterSpacing: 0.2,
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ].divide(SizedBox(width: 4.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  offset: Offset(
                                                    0.0,
                                                    2.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    valueOrDefault<String>(
                                                      chatListSupportMessagesRow
                                                          .message,
                                                      'New  Messages',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 14.5,
                                                          letterSpacing: 0.2,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                          lineHeight: 1.4,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Safety & trust') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How are service providers verified?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Every Helpero professional must pass a comprehensive background check and identity verification. They also complete mandatory hands-on training at our Hub before they can take their first job on the platform.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My orders') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'Where can I find my past orders?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'All your past, upcoming, and cancelled bookings are located in the \"My Orders\" tab on the bottom menu. You can tap on any completed order to view its detailed receipt and the professional\'s photo report!',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Subscription') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What benefits are included in the subscription?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Helpero Plus members automatically receive a 15% discount on every service, zero platform fees, and priority matching with our top-rated professionals.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My account') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I reset my password?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Helpero uses phone numbers and one-time SMS codes for secure login, so you don\'t need a password! Just enter your phone number to get a fresh login code.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Booking') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I create a new booking?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Tap the service category you need on the Home screen, select any add-ons, pick your time slot, and confirm your address. It takes less than 60 seconds!',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Payment') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What payment methods are accepted?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'We securely accept Visa, Mastercard, American Express, Apple Pay, and Google Pay through Stripe. We do not accept cash or e-transfers. ',
                                                  });
                                                } else {
                                                  return;
                                                }

                                                await _model
                                                    .chatListScrollController
                                                    ?.animateTo(
                                                  0,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease,
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 290.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Text(
                                                          () {
                                                            if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'Booking') {
                                                              return 'How do I create a new booking?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'Payment') {
                                                              return 'What payment methods are accepted?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'Safety & trust') {
                                                              return 'How are service providers verified?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'My account') {
                                                              return 'How do I reset my password?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'My orders') {
                                                              return 'Where can I find my past orders?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'Subscription') {
                                                              return 'What benefits are included in the subscription?';
                                                            } else {
                                                              return 'None';
                                                            }
                                                          }(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 15.0,
                                                                letterSpacing:
                                                                    0.2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                                lineHeight: 1.4,
                                                              ),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        size: 18.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Safety & trust') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How does Helpero protect my personal data?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Your privacy is our priority. All payment details are encrypted and securely handled by Stripe. Your actual phone number is never shared with professionals—all communication happens safely within the app.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My orders') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What happens if something gets damaged?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message': '',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Subscriptions') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I cancel my subscription?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'You can cancel anytime without penalty. Go to Account → Helpero Plus, tap \"Manage Subscription,\" and select \"Cancel\". You\'ll keep all your benefits until the end of your current billing cycle.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My account') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How can I update my profile information?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'To update your name, photo, or addresses, go to the Account tab (bottom right) and tap \"Edit Profile\".',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Booking') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'Can I cancel or reschedule my booking?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Yes! You can easily cancel or reschedule for free up to 2 hours before your appointment via the \"My Orders\" tab.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Payment') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'When will I be charged for my order?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'When you complete your booking, we place a temporary \"hold\" (pre-authorization) on your card to ensure the funds are available. However, the final charge only happens after the professional completes your service.',
                                                  });
                                                } else {
                                                  return;
                                                }

                                                await _model
                                                    .chatListScrollController
                                                    ?.animateTo(
                                                  0,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease,
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 290.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      1.0,
                                                                      0.0),
                                                          child: Text(
                                                            () {
                                                              if (chatListSupportMessagesRow
                                                                      .faq ==
                                                                  'Booking') {
                                                                return 'Can I cancel or reschedule my booking?';
                                                              } else if (chatListSupportMessagesRow
                                                                      .faq ==
                                                                  'Payment') {
                                                                return 'When will I be charged for my order?';
                                                              } else if (chatListSupportMessagesRow
                                                                      .faq ==
                                                                  'Safety & trust') {
                                                                return 'How does Helpero protect my personal data?';
                                                              } else if (chatListSupportMessagesRow
                                                                      .faq ==
                                                                  'My account') {
                                                                return 'How can I update my profile information?';
                                                              } else if (chatListSupportMessagesRow
                                                                      .faq ==
                                                                  'My orders') {
                                                                return 'How do I leave a review or tip for a completed order?';
                                                              } else if (chatListSupportMessagesRow
                                                                      .faq ==
                                                                  'Subscription') {
                                                                return 'How do I cancel my subscription?';
                                                              } else {
                                                                return 'None';
                                                              }
                                                            }(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .outfit(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      15.0,
                                                                  letterSpacing:
                                                                      0.2,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                  lineHeight:
                                                                      1.4,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        size: 18.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Safety & trust') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What should I do if I feel unsafe during a service?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Your safety is our absolute priority. If you ever feel unsafe or uncomfortable, ask the professional to leave immediately. Then, use the in-app SOS button or contact Support right away. We will suspend the professional\'s account pending an urgent investigation.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My orders') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What happens if something gets damaged?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message': '',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Subscriptions') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'Can I upgrade or downgrade my current plan?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Yes! You can easily switch between our Monthly (\$19.99/mo) and Annual (\$149/yr) plans. Just visit the \"Helpero Plus\" section in your Account tab to update your plan preferences.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My account') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I change my phone number or email?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Go to Account → Edit Profile. You can type in your new contact details there and quickly verify your new phone number via SMS.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Booking') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I check the status of my booking?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Open the \"My Orders\" tab to see the live status of your service. Once the professional is on the way, you can even track them on a GPS map!',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Payment') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I request a refund?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Go to the \"My Orders\" tab, select the completed service, and tap \"Report an Issue\" or \"Request Refund\". Our team will review your request and process eligible refunds within 3–5 business days to your original payment method.',
                                                  });
                                                } else {
                                                  return;
                                                }

                                                await _model
                                                    .chatListScrollController
                                                    ?.animateTo(
                                                  0,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease,
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 290.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Text(
                                                          () {
                                                            if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'Booking') {
                                                              return 'How do I check the status of my booking?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'Payment') {
                                                              return 'How do I request a refund?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'Safety & trust') {
                                                              return 'What should I do if I feel unsafe during a service?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'My account') {
                                                              return 'How do I change my phone number or email?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'My orders') {
                                                              return 'Can I rebook the exact same provider again?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'Subscription') {
                                                              return 'Can I upgrade or downgrade my current plan?';
                                                            } else {
                                                              return 'None';
                                                            }
                                                          }(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 15.0,
                                                                letterSpacing:
                                                                    0.2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                                lineHeight: 1.4,
                                                              ),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        size: 18.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Safety & trust') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I block or report another user?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'If you have an issue with someone, open their profile or your chat with them, tap the three dots (Menu) in the top right corner, and select \"Report\" or \"Block User\". Our Safety Team reviews all reports within 24 hours.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My orders') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What happens if something gets damaged?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message': '',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Subscriptions') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'When is my subscription auto-renewed?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Your subscription renews automatically exactly one month (or one year) from the date you signed up. You can check your next billing date anytime in the \"Helpero Plus\" section of the Account tab.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My account') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'Can I delete my account permanently?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Yes. Navigate to Account → Settings → Privacy → Delete Account. Please note this action is permanent and clears your entire history and wallet balance.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Booking') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What happens if a professional cancels my booking?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'This is rare, but if it happens, we will immediately fast-track a replacement for you or issue a full refund to your original payment method.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Payment') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What if my card is declined or expired?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'If your card lacks sufficient funds or is expired at the time of booking, the system cannot place the temporary hold, and your booking won\'t be confirmed. You\'ll simply be asked to add a new card in the Wallet tab to complete the request.',
                                                  });
                                                } else {
                                                  return;
                                                }

                                                await _model
                                                    .chatListScrollController
                                                    ?.animateTo(
                                                  0,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease,
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 290.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: Text(
                                                          () {
                                                            if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'Booking') {
                                                              return 'What happens if a professional cancels my booking?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'Payment') {
                                                              return 'What if my card is declined or expired?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'Safety & trust') {
                                                              return 'How do I block or report another user?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'My account') {
                                                              return 'Can I delete my account permanently?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'My orders') {
                                                              return 'What do the different order statuses mean?';
                                                            } else if (chatListSupportMessagesRow
                                                                    .faq ==
                                                                'Subscription') {
                                                              return 'When is my subscription auto-renewed?';
                                                            } else {
                                                              return 'None';
                                                            }
                                                          }(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 15.0,
                                                                letterSpacing:
                                                                    0.2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                                lineHeight: 1.4,
                                                              ),
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        size: 18.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ],
                              ),
                            ),
                          if (chatListSupportMessagesRow.type == 'order')
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 2.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(),
                                          child: Icon(
                                            Icons.support_agent,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            size: 18.0,
                                          ),
                                        ),
                                        Text(
                                          'Support',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 13.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ].divide(SizedBox(width: 4.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 4.0,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  offset: Offset(
                                                    0.0,
                                                    2.0,
                                                  ),
                                                )
                                              ],
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                topRight: Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    valueOrDefault<String>(
                                                      chatListSupportMessagesRow
                                                          .message,
                                                      'New  Messages',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
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
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 14.5,
                                                          letterSpacing: 0.2,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                          lineHeight: 1.4,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Safety & trust') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How are service providers verified?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Every Helpero professional must pass a comprehensive background check and identity verification. They also complete mandatory hands-on training at our Hub before they can take their first job on the platform.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My orders') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'Where can I find my past orders?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'All your past, upcoming, and cancelled bookings are located in the \"My Orders\" tab on the bottom menu. You can tap on any completed order to view its detailed receipt and the professional\'s photo report!',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Subscription') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What benefits are included in the subscription?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Helpero Plus members automatically receive a 15% discount on every service, zero platform fees, and priority matching with our top-rated professionals.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My account') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I reset my password?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Helpero uses phone numbers and one-time SMS codes for secure login, so you don\'t need a password! Just enter your phone number to get a fresh login code.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Booking') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I create a new booking?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Tap the service category you need on the Home screen, select any add-ons, pick your time slot, and confirm your address. It takes less than 60 seconds!',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Payment') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What payment methods are accepted?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'We securely accept Visa, Mastercard, American Express, Apple Pay, and Google Pay through Stripe. We do not accept cash or e-transfers. ',
                                                  });
                                                } else {
                                                  context.goNamed(
                                                      GenderWidget.routeName);
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        8.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons
                                                                  .design_services,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 22.0,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 290.0,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Text(
                                                              'Problem with the order',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .outfit(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    fontSize:
                                                                        15.0,
                                                                    letterSpacing:
                                                                        0.2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                    lineHeight:
                                                                        1.4,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        size: 18.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Safety & trust') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How does Helpero protect my personal data?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Your privacy is our priority. All payment details are encrypted and securely handled by Stripe. Your actual phone number is never shared with professionals—all communication happens safely within the app.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My orders') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What happens if something gets damaged?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message': '',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Subscriptions') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I cancel my Plus subscription?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'You can cancel anytime without penalty. Go to Account → Helpero Plus, tap \"Manage Subscription,\" and select \"Cancel\". You\'ll keep all your benefits until the end of your current billing cycle.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My account') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How can I update my profile information?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'To update your name, photo, or addresses, go to the Account tab (bottom right) and tap \"Edit Profile\".',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Booking') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'Can I cancel or reschedule my booking?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Yes! You can easily cancel or reschedule for free up to 2 hours before your appointment via the \"My Orders\" tab.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Payment') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'When will I be charged for my order?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'When you complete your booking, we place a temporary \"hold\" (pre-authorization) on your card to ensure the funds are available. However, the final charge only happens after the professional completes your service.',
                                                  });
                                                } else {
                                                  return;
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        8.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons
                                                                  .payments_outlined,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 22.0,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 290.0,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          1.0,
                                                                          0.0),
                                                              child: Text(
                                                                'Payment and Refunds',
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
                                                                          15.0,
                                                                      letterSpacing:
                                                                          0.2,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                      lineHeight:
                                                                          1.4,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        size: 18.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Safety & trust') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What should I do if I feel unsafe during a service?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Your safety is our absolute priority. If you ever feel unsafe or uncomfortable, ask the professional to leave immediately. Then, use the in-app SOS button or contact Support right away. We will suspend the professional\'s account pending an urgent investigation.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My orders') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What happens if something gets damaged?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message': '',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Subscriptions') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'Can I upgrade or downgrade my current plan?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Yes! You can easily switch between our Monthly (\$19.99/mo) and Annual (\$149/yr) plans. Just visit the \"Helpero Plus\" section in your Account tab to update your plan preferences.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My account') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I change my phone number or email?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Go to Account → Edit Profile. You can type in your new contact details there and quickly verify your new phone number via SMS.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Booking') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I check the status of my booking?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Open the \"My Orders\" tab to see the live status of your service. Once the professional is on the way, you can even track them on a GPS map!',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Payment') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I request a refund?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Go to the \"My Orders\" tab, select the completed service, and tap \"Report an Issue\" or \"Request Refund\". Our team will review your request and process eligible refunds within 3–5 business days to your original payment method.',
                                                  });
                                                } else {
                                                  return;
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        8.0,
                                                                        0.0),
                                                            child: FaIcon(
                                                              FontAwesomeIcons
                                                                  .comment,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 22.0,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 290.0,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Text(
                                                              'Complaint',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .outfit(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    fontSize:
                                                                        15.0,
                                                                    letterSpacing:
                                                                        0.2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                    lineHeight:
                                                                        1.4,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        size: 18.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Safety & trust') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'How do I block or report another user?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'If you have an issue with someone, open their profile or your chat with them, tap the three dots (Menu) in the top right corner, and select \"Report\" or \"Block User\". Our Safety Team reviews all reports within 24 hours.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My orders') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What happens if something gets damaged?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message': '',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Subscriptions') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'When is my subscription auto-renewed?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Your subscription renews automatically exactly one month (or one year) from the date you signed up. You can check your next billing date anytime in the \"Helpero Plus\" section of the Account tab.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'My account') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'Can I delete my account permanently?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'Yes. Navigate to Account → Settings → Privacy → Delete Account. Please note this action is permanent and clears your entire history and wallet balance.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Booking') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What happens if a professional cancels my booking?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'This is rare, but if it happens, we will immediately fast-track a replacement for you or issue a full refund to your original payment method.',
                                                  });
                                                } else if (chatListSupportMessagesRow
                                                        .faq ==
                                                    'Payment') {
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'type': 'text',
                                                    'is_user': true,
                                                    'message':
                                                        'What if my card is declined or expired?',
                                                  });
                                                  await Future.delayed(
                                                    Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  );
                                                  await SupportMessagesTable()
                                                      .insert({
                                                    'is_user': false,
                                                    'type': 'text',
                                                    'message':
                                                        'If your card lacks sufficient funds or is expired at the time of booking, the system cannot place the temporary hold, and your booking won\'t be confirmed. You\'ll simply be asked to add a new card in the Wallet tab to complete the request.',
                                                  });
                                                } else {
                                                  return;
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        8.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons
                                                                  .heart_broken_outlined,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              size: 22.0,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 290.0,
                                                            decoration:
                                                                BoxDecoration(),
                                                            child: Text(
                                                              'Damage or loss',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .outfit(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText,
                                                                    fontSize:
                                                                        15.0,
                                                                    letterSpacing:
                                                                        0.2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                    lineHeight:
                                                                        1.4,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(
                                                        Icons.arrow_forward_ios,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        size: 18.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ].divide(SizedBox(height: 8.0)),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                    controller: _model.chatListScrollController,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
