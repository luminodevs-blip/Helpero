import '/backend/supabase/supabase.dart';
import '/booking_flow/new/category_card/category_card_widget.dart';
import '/components/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'general_widget.dart' show GeneralWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class GeneralModel extends FlutterFlowModel<GeneralWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in General widget.
  List<CountriesRow>? loadedCountry;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Models for CategoryCard dynamic component.
  late FlutterFlowDynamicModels<CategoryCardModel> categoryCardModels;
  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController1;
  int carouselCurrentIndex1 = 0;

  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController2;
  int carouselCurrentIndex2 = 0;

  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    categoryCardModels = FlutterFlowDynamicModels(() => CategoryCardModel());
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    categoryCardModels.dispose();
    navbarModel.dispose();
  }
}
