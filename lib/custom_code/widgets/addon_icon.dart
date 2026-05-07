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

class AddonIcon extends StatefulWidget {
  const AddonIcon({
    super.key,
    this.width,
    this.height,
    required this.addonText,
    required this.iconSize,
    required this.iconColor,
  });

  final double? width;
  final double? height;
  final String addonText;
  final double iconSize;
  final Color iconColor;

  @override
  State<AddonIcon> createState() => _AddonIconState();
}

class _AddonIconState extends State<AddonIcon> {
  IconData _getIcon() {
    final text = widget.addonText.toLowerCase();

    // Сначала проверяем bath, чтобы отловить bathrooms
    if (text.contains('bath')) return Icons.bathtub;
    // Только если это не bath, проверяем room
    if (text.contains('room')) return Icons.bed;

    if (text.contains('pet')) return Icons.pets;
    if (text.contains('sofa') || text.contains('couch')) return Icons.weekend;
    if (text.contains('window')) return Icons.window;
    if (text.contains('fridge')) return Icons.kitchen;
    if (text.contains('oven')) return Icons.microwave;

    return Icons.check_circle_outline; // Дефолтная иконка
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIcon(),
      size: widget.iconSize,
      color: widget.iconColor,
    );
  }
}
