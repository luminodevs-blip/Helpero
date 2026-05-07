import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/profile/support/chat_list/chat_list_widget.dart';
import 'consultant_chat_widget.dart' show ConsultantChatWidget;
import 'package:flutter/material.dart';

class ConsultantChatModel extends FlutterFlowModel<ConsultantChatWidget> {
  ///  Local state fields for this page.

  SupportMessageStruct? chatHistory;
  void updateChatHistoryStruct(Function(SupportMessageStruct) updateFn) {
    updateFn(chatHistory ??= SupportMessageStruct());
  }

  bool hasText = false;

  bool textField = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in Consultant_chat widget.
  List<SupportMessagesRow>? existingWelcome;
  // Model for ChatList component.
  late ChatListModel chatListModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  bool isDataUploading_uploadDataZug1 = false;
  FFUploadedFile uploadedLocalFile_uploadDataZug1 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataZug1 = '';

  @override
  void initState(BuildContext context) {
    chatListModel = createModel(context, () => ChatListModel());
  }

  @override
  void dispose() {
    chatListModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
