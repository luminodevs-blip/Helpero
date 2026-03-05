import '/backend/supabase/supabase.dart';
import '/booking_flow/new/category_card/category_card_widget.dart';
import '/components/add_baners_carusel_widget.dart';
import '/components/information_block_widget.dart';
import '/components/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'general_entry_first_widget.dart' show GeneralEntryFirstWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class GeneralEntryFirstModel extends FlutterFlowModel<GeneralEntryFirstWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in GeneralEntryFirst widget.
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

  // Model for addBanersCarusel component.
  late AddBanersCaruselModel addBanersCaruselModel1;
  // Model for addBanersCarusel component.
  late AddBanersCaruselModel addBanersCaruselModel2;
  // Model for addBanersCarusel component.
  late AddBanersCaruselModel addBanersCaruselModel3;
  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController2;
  int carouselCurrentIndex2 = 0;

  // Model for InformationBlock component.
  late InformationBlockModel informationBlockModel1;
  // Model for InformationBlock component.
  late InformationBlockModel informationBlockModel2;
  // Model for InformationBlock component.
  late InformationBlockModel informationBlockModel3;
  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    categoryCardModels = FlutterFlowDynamicModels(() => CategoryCardModel());
    addBanersCaruselModel1 =
        createModel(context, () => AddBanersCaruselModel());
    addBanersCaruselModel2 =
        createModel(context, () => AddBanersCaruselModel());
    addBanersCaruselModel3 =
        createModel(context, () => AddBanersCaruselModel());
    informationBlockModel1 =
        createModel(context, () => InformationBlockModel());
    informationBlockModel2 =
        createModel(context, () => InformationBlockModel());
    informationBlockModel3 =
        createModel(context, () => InformationBlockModel());
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    categoryCardModels.dispose();
    addBanersCaruselModel1.dispose();
    addBanersCaruselModel2.dispose();
    addBanersCaruselModel3.dispose();
    informationBlockModel1.dispose();
    informationBlockModel2.dispose();
    informationBlockModel3.dispose();
    navbarModel.dispose();
  }
}
