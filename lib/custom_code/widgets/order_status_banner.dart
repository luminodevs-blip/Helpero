// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OrderStatusBanner extends StatefulWidget {
  const OrderStatusBanner({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<OrderStatusBanner> createState() => _OrderStatusBannerState();
}

class _OrderStatusBannerState extends State<OrderStatusBanner> {
  @override
  Widget build(BuildContext context) {
    // Проверка наличия сессии пользователя
    final uid = Supabase.instance.client.auth.currentUser?.id;

    // Если мы в редакторе (uid == null), показываем превью
    if (uid == null) {
      return _buildBannerContent(
        context: context,
        serviceName: 'Home Cleaning (Preview)',
        statusText: 'Specialist is on the way',
        orderId: 0,
      );
    }

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Supabase.instance.client
          .from('orders')
          .stream(primaryKey: ['id'])
          .eq('user_id', uid)
          .order('id', ascending: false),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final activeStatuses = [
          'searching',
          'assigned',
          'en_route',
          'arrived',
          'in_progress'
        ];
        final activeOrders = snapshot.data!
            .where((o) => activeStatuses.contains(o['status']))
            .toList();

        if (activeOrders.isEmpty) return const SizedBox.shrink();

        final order = activeOrders.first;
        final orderId = order['id'] as int;
        final status = order['status'] as String;

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: Supabase.instance.client
              .from('v_active_order_details')
              .select()
              .eq('order_id', orderId)
              .limit(1),
          builder: (context, detailsSnapshot) {
            final details = detailsSnapshot.data?.firstOrNull;
            return _buildBannerContent(
              context: context,
              serviceName: details?['primary_service_name'] ?? 'Active Order',
              statusText: _getStatusText(status),
              orderId: orderId,
            );
          },
        );
      },
    );
  }

  Widget _buildBannerContent({
    required BuildContext context,
    required String serviceName,
    required String statusText,
    required int orderId,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () async {
          if (orderId == 0) return;
          // Навигация на страницу Activeorder
          context.pushNamed('Activeorder',
              queryParameters: {'orderId': orderId.toString()}.withoutNulls);
        },
        child: Container(
          width: double.infinity,
          height: 70.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primary,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                  blurRadius: 12.0,
                  color: const Color(0x33000000),
                  offset: const Offset(0.0, 5.0))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                      color: const Color(0x33FFFFFF), shape: BoxShape.circle),
                  child: Icon(Icons.timer_sharp,
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      size: 24.0),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.outfit(),
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                      ),
                      Text(
                        statusText,
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                              font: GoogleFonts.outfit(),
                              color: const Color(0xB3FFFFFF),
                            ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: Color(0x99FFFFFF), size: 24.0),
              ],
            ),
          ),
        ),
      ).animate().fade(duration: 400.ms).slideY(begin: 0.2, end: 0.0),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'searching':
        return 'Finding the best specialist...';
      case 'assigned':
        return 'Specialist assigned and preparing';
      case 'en_route':
        return 'Specialist is on the way';
      case 'arrived':
        return 'Specialist has arrived';
      case 'in_progress':
        return 'Service is currently in progress';
      default:
        return 'Updating status...';
    }
  }
}
