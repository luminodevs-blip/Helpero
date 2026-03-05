import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'address_autocomplete_widget.dart' show AddressAutocompleteWidget;
import 'package:flutter/material.dart';

class AddressAutocompleteModel
    extends FlutterFlowModel<AddressAutocompleteWidget> {
  ///  Local state fields for this component.

  bool typeText = false;

  List<dynamic> searchResults = [];
  void addToSearchResults(dynamic item) => searchResults.add(item);
  void removeFromSearchResults(dynamic item) => searchResults.remove(item);
  void removeAtIndexFromSearchResults(int index) =>
      searchResults.removeAt(index);
  void insertAtIndexInSearchResults(int index, dynamic item) =>
      searchResults.insert(index, item);
  void updateSearchResultsAtIndex(int index, Function(dynamic) updateFn) =>
      searchResults[index] = updateFn(searchResults[index]);

  String? selectedAddress;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (MapboxAutocomplete)] action in TextField widget.
  ApiCallResponse? mapboxAutocomplete;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
