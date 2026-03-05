import '/components/service_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'service_page_widget.dart' show ServicePageWidget;
import 'package:flutter/material.dart';

class ServicePageModel extends FlutterFlowModel<ServicePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for ServiceCard dynamic component.
  late FlutterFlowDynamicModels<ServiceCardModel> serviceCardModels1;
  // Models for ServiceCard dynamic component.
  late FlutterFlowDynamicModels<ServiceCardModel> serviceCardModels2;

  @override
  void initState(BuildContext context) {
    serviceCardModels1 = FlutterFlowDynamicModels(() => ServiceCardModel());
    serviceCardModels2 = FlutterFlowDynamicModels(() => ServiceCardModel());
  }

  @override
  void dispose() {
    serviceCardModels1.dispose();
    serviceCardModels2.dispose();
  }
}
