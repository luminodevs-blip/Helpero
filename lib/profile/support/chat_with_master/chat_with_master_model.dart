import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_with_master_widget.dart' show ChatWithMasterWidget;
import 'package:flutter/material.dart';

class ChatWithMasterModel extends FlutterFlowModel<ChatWithMasterWidget> {
  ///  Local state fields for this page.

  SupportMessageStruct? chatHistory;
  void updateChatHistoryStruct(Function(SupportMessageStruct) updateFn) {
    updateFn(chatHistory ??= SupportMessageStruct());
  }

  bool hasText = false;

  bool textField = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in ChatWithMaster widget.
  List<SupportMessagesRow>? existingWelcome;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  bool isDataUploading_uploadDataZug = false;
  FFUploadedFile uploadedLocalFile_uploadDataZug =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataZug = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
