import '/components/menu_item_widget.dart';
import '/components/navbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'account_page_widget.dart' show AccountPageWidget;
import 'package:flutter/material.dart';

class AccountPageModel extends FlutterFlowModel<AccountPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for menuItem component.
  late MenuItemModel menuItemModel1;
  // Model for menuItem component.
  late MenuItemModel menuItemModel2;
  // Model for menuItem component.
  late MenuItemModel menuItemModel3;
  // Model for menuItem component.
  late MenuItemModel menuItemModel4;
  // Model for menuItem component.
  late MenuItemModel menuItemModel5;
  // Model for menuItem component.
  late MenuItemModel menuItemModel6;
  // State field(s) for Switch widget.
  bool? switchValue;
  // Model for navbar component.
  late NavbarModel navbarModel;

  @override
  void initState(BuildContext context) {
    menuItemModel1 = createModel(context, () => MenuItemModel());
    menuItemModel2 = createModel(context, () => MenuItemModel());
    menuItemModel3 = createModel(context, () => MenuItemModel());
    menuItemModel4 = createModel(context, () => MenuItemModel());
    menuItemModel5 = createModel(context, () => MenuItemModel());
    menuItemModel6 = createModel(context, () => MenuItemModel());
    navbarModel = createModel(context, () => NavbarModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    menuItemModel1.dispose();
    menuItemModel2.dispose();
    menuItemModel3.dispose();
    menuItemModel4.dispose();
    menuItemModel5.dispose();
    menuItemModel6.dispose();
    navbarModel.dispose();
  }
}
