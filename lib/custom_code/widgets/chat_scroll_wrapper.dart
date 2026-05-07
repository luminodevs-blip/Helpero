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

class ChatScrollWrapper extends StatefulWidget {
  const ChatScrollWrapper({
    Key? key,
    this.width,
    this.height,
    required this.child,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Widget Function() child;

  @override
  State<ChatScrollWrapper> createState() => _ChatScrollWrapperState();
}

class _ChatScrollWrapperState extends State<ChatScrollWrapper> {
  // Теперь сохраняем напрямую позицию оригинального скролла
  ScrollPosition? _innerScrollPosition;
  double _keyboardHeight = 0.0;
  bool _wasAtBottom = true;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // Проверяем, начала ли открываться клавиатура
    bool isKeyboardOpening = bottomInset > 0 && _keyboardHeight == 0;

    if (isKeyboardOpening) {
      if (_wasAtBottom && _innerScrollPosition != null) {
        // Поднимаем чат с задержкой, пока выезжает клавиатура
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _innerScrollPosition!.animateTo(
              _innerScrollPosition!.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
            );
          }
        });
      }
    }

    // Сохраняем высоту клавиатуры для следующего кадра
    if (bottomInset > 0) {
      _keyboardHeight = bottomInset;
    } else if (bottomInset == 0) {
      _keyboardHeight = 0;
    }

    // NotificationListener перехватывает скролл изнутри (от ListView)
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        // Как только список скроллится (или просто рендерится), мы его захватываем
        if (notification.metrics is ScrollPosition) {
          _innerScrollPosition = notification.metrics as ScrollPosition;
          // Проверяем, находится ли юзер в самом низу (погрешность 150px)
          _wasAtBottom = _innerScrollPosition!.pixels >=
              _innerScrollPosition!.maxScrollExtent - 150;
        }
        return false; // Позволяем скроллу работать как обычно
      },
      child: widget.child(),
    );
  }
}
