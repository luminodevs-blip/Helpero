import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_list_widget.dart' show ChatListWidget;
import 'package:flutter/material.dart';

class ChatListModel extends FlutterFlowModel<ChatListWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for ChatList widget.
  ScrollController? chatListScrollController;
  Stream<List<SupportMessagesRow>>? chatListSupabaseStream;

  @override
  void initState(BuildContext context) {
    chatListScrollController = ScrollController();
  }

  @override
  void dispose() {
    chatListScrollController?.dispose();
  }
}
