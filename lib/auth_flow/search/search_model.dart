import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/navbar_widget.dart';
import '/components/service_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'search_widget.dart' show SearchWidget;
import 'package:flutter/material.dart';

class SearchModel extends FlutterFlowModel<SearchWidget> {
  ///  Local state fields for this page.

  String? input;

  bool firstLoad = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - searchServicesNative] action in Search widget.
  List<ServicePackageStruct>? safeSearchResultsPage;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Custom Action - searchServicesNative] action in TextField widget.
  List<ServicePackageStruct>? safeSearchResults;
  // Models for ServiceCard dynamic component.
  late FlutterFlowDynamicModels<ServiceCardModel> serviceCardModels1;
  // Stores action output result for [Backend Call - Query Rows] action in ServiceCard widget.
  List<ServicesRow>? supaRow;
  // Models for ServiceCard dynamic component.
  late FlutterFlowDynamicModels<ServiceCardModel> serviceCardModels2;
  // Stores action output result for [Backend Call - Query Rows] action in ServiceCard widget.
  List<ServicesRow>? supaRow2;
  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    serviceCardModels1 = FlutterFlowDynamicModels(() => ServiceCardModel());
    serviceCardModels2 = FlutterFlowDynamicModels(() => ServiceCardModel());
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    serviceCardModels1.dispose();
    serviceCardModels2.dispose();
    navbarModel.dispose();
  }
}
