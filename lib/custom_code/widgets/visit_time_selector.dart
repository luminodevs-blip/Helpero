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

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class VisitTimeSelector extends StatefulWidget {
  const VisitTimeSelector({
    super.key,
    this.width,
    this.height,
    this.initialDate,
    this.initialTimeDisplay,
    this.availableSlots,
    this.onDateChanged,
    this.onSlotConfirmed,
    this.durationText,
  });

  final double? width;
  final double? height;
  final DateTime? initialDate;
  final String? initialTimeDisplay;
  final List<ArrivalOptionStructStruct>? availableSlots;
  final Future Function(DateTime selectedDate)? onDateChanged;
  final Future Function(ArrivalOptionStructStruct selectedSlot)?
      onSlotConfirmed;
  final String? durationText;

  @override
  State<VisitTimeSelector> createState() => _VisitTimeSelectorState();
}

class _VisitTimeSelectorState extends State<VisitTimeSelector> {
  DateTime? _selDate;
  ArrivalOptionStructStruct? _selSlot;

  @override
  void initState() {
    super.initState();
    _selDate = widget.initialDate ?? DateTime.now();
    _updateSlot();
  }

  void _updateSlot() {
    final slots = widget.availableSlots ?? [];
    if (slots.isEmpty) {
      _selSlot = null;
    } else {
      _selSlot = slots.firstWhereOrNull(
              (s) => s.displayTime == widget.initialTimeDisplay) ??
          slots.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final slots = widget.availableSlots ?? [];
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text("Select Time",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: slots.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2.5,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                    itemCount: slots.length,
                    itemBuilder: (context, index) {
                      final s = slots[index];
                      final isSel = _selSlot == s;
                      return InkWell(
                        onTap: () => setState(() => _selSlot = s),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSel ? Colors.blue : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                              child: Text(s.displayTime,
                                  style: TextStyle(
                                      color: isSel
                                          ? Colors.white
                                          : Colors.black))),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _selSlot == null
                  ? null
                  : () async {
                      FFAppState().updateActiveBookingDraftStruct((b) {
                        b.visit.arrivalDate = _selDate;
                        b.visit.id = _selSlot!.id;
                        b.visit.arrivalTimeDisplay = _selSlot!.displayTime;
                      });
                      if (widget.onSlotConfirmed != null)
                        await widget.onSlotConfirmed!(_selSlot!);
                      Navigator.pop(context);
                    },
              child: const Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }
}
