import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'vouchers_widget.dart' show VouchersWidget;
import 'package:flutter/material.dart';

class VouchersModel extends FlutterFlowModel<VouchersWidget> {
  ///  Local state fields for this page.

  List<UserVoucherStruct> vouchersList = [];
  void addToVouchersList(UserVoucherStruct item) => vouchersList.add(item);
  void removeFromVouchersList(UserVoucherStruct item) =>
      vouchersList.remove(item);
  void removeAtIndexFromVouchersList(int index) => vouchersList.removeAt(index);
  void insertAtIndexInVouchersList(int index, UserVoucherStruct item) =>
      vouchersList.insert(index, item);
  void updateVouchersListAtIndex(
          int index, Function(UserVoucherStruct) updateFn) =>
      vouchersList[index] = updateFn(vouchersList[index]);

  String tab = 'all';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getUserVouchers)] action in Vouchers widget.
  ApiCallResponse? getUserVouchers;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (claimVoucher)] action in Button widget.
  ApiCallResponse? claimVoucher;
  // Stores action output result for [Backend Call - API (getUserVouchers)] action in Button widget.
  ApiCallResponse? getUserVouchersClaim;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
