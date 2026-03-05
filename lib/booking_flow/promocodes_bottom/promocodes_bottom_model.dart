import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'promocodes_bottom_widget.dart' show PromocodesBottomWidget;
import 'package:flutter/material.dart';

class PromocodesBottomModel extends FlutterFlowModel<PromocodesBottomWidget> {
  ///  Local state fields for this component.

  dynamic userWallet;

  int? selectedVoucherId = 0;

  String tab = 'all';

  List<UserVoucherStruct> allVouchers = [];
  void addToAllVouchers(UserVoucherStruct item) => allVouchers.add(item);
  void removeFromAllVouchers(UserVoucherStruct item) =>
      allVouchers.remove(item);
  void removeAtIndexFromAllVouchers(int index) => allVouchers.removeAt(index);
  void insertAtIndexInAllVouchers(int index, UserVoucherStruct item) =>
      allVouchers.insert(index, item);
  void updateAllVouchersAtIndex(
          int index, Function(UserVoucherStruct) updateFn) =>
      allVouchers[index] = updateFn(allVouchers[index]);

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (getUserVouchers)] action in Promocodes_Bottom widget.
  ApiCallResponse? getUserVouchers;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (claimVoucher)] action in Button widget.
  ApiCallResponse? claimVoucher;
  // Stores action output result for [Backend Call - API (getUserVouchers)] action in Button widget.
  ApiCallResponse? getUserVouchersClaim;
  // Stores action output result for [Backend Call - API (CalculateCheckout)] action in Container widget.
  ApiCallResponse? checkoutResulTrue;
  // Stores action output result for [Backend Call - API (CalculateCheckout)] action in Container widget.
  ApiCallResponse? checkoutResultFalse;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
