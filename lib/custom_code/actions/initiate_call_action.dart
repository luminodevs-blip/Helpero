// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:url_launcher/url_launcher.dart';

Future<void> initiateCallAction(
  BuildContext context,
  int orderId,
) async {
  try {
    // 1. Fetch the anonymous proxy phone number from Supabase
    final response = await SupaFlow.client
        .rpc('get_or_assign_proxy_phone', params: {'p_order_id': orderId});

    if (response != null && response is String && response.isNotEmpty) {
      final String proxyPhone = response;
      final Uri callUri = Uri(scheme: 'tel', path: proxyPhone);

      // 2. Open the native dialer
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch the phone dialer.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to allocate a proxy phone number.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error initiating call: $e'),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ),
    );
  }
}
