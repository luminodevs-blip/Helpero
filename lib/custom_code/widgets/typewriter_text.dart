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

import 'dart:async';
import 'dart:math';

// Сохраняем статусы анимации по hashCode текста
final Set<int> _animatedMessages = {};

class TypewriterText extends StatefulWidget {
  const TypewriterText({
    super.key,
    this.width, // Возвращаем width, чтобы FlutterFlow не выдавал ошибку
    this.height, // Возвращаем height, чтобы FlutterFlow не выдавал ошибку
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.speedMs,
    this.showCursor = true,
    this.skippable = true,
  });

  final double? width;
  final double? height;
  final String text;
  final double fontSize;
  final Color textColor;
  final int speedMs;
  final bool showCursor;
  final bool skippable;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  late bool _hasAnimated;
  late int _currentKey;
  String _displayed = '';
  int _charIndex = 0;

  Timer? _timer;
  Timer? _cursorTimer;
  bool _cursorVisible = true;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _currentKey = widget.text.hashCode;
    _hasAnimated = _animatedMessages.contains(_currentKey);

    if (!_hasAnimated) {
      _startTyping();
      if (widget.showCursor) _startCursorBlink();
    }
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newKey = widget.text.hashCode;

    if (newKey != _currentKey || oldWidget.text != widget.text) {
      _currentKey = newKey;
      _hasAnimated = _animatedMessages.contains(_currentKey);

      _timer?.cancel();
      _cursorTimer?.cancel();

      if (!_hasAnimated) {
        _displayed = '';
        _charIndex = 0;
        _startTyping();
        if (widget.showCursor) _startCursorBlink();
      } else {
        setState(() {});
      }
    }
  }

  void _startTyping() {
    _scheduleNext();
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;
      setState(() {
        _cursorVisible = !_cursorVisible;
      });
    });
  }

  void _scheduleNext() {
    if (!mounted) return;
    if (_charIndex >= widget.text.length) {
      _finishAnimation();
      return;
    }

    final char = widget.text[_charIndex];
    int delay = widget.speedMs;

    // Паузы после знаков препинания
    if (char == '.' || char == '!' || char == '?') {
      delay = widget.speedMs * 6;
    } else if (char == ',') {
      delay = widget.speedMs * 3;
    } else if (char == ':') {
      delay = widget.speedMs * 4;
    } else if (char == ' ') {
      delay = widget.speedMs + _random.nextInt(widget.speedMs);
    } else {
      if (_random.nextDouble() < 0.15) {
        delay = widget.speedMs * (3 + _random.nextInt(3));
      } else {
        final variation = (_random.nextDouble() * widget.speedMs * 0.6).toInt();
        delay = (widget.speedMs - widget.speedMs ~/ 3) + variation;
      }
    }

    _timer = Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;
      setState(() {
        _displayed += widget.text[_charIndex];
        _charIndex++;
      });
      _scheduleNext();
    });
  }

  void _finishAnimation() {
    _animatedMessages.add(_currentKey);
    _timer?.cancel();
    _cursorTimer?.cancel();
    if (mounted) {
      setState(() {
        _hasAnimated = true;
        _displayed = widget.text;
      });
    }
  }

  void _skipAnimation() {
    if (!widget.skippable || _hasAnimated) return;
    _finishAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: widget.fontSize,
      color: widget.textColor,
      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
      fontWeight: FontWeight.w400,
      height: 1.4,
      letterSpacing: 0.2,
    );

    String finalDisplayText = _hasAnimated ? widget.text : _displayed;
    if (!_hasAnimated && widget.showCursor && _cursorVisible) {
      finalDisplayText += '|';
    }

    return GestureDetector(
      onTap: _skipAnimation,
      behavior: HitTestBehavior.deferToChild,
      // ВАЖНО: Мы вернули width и height в конструктор, но НЕ используем здесь
      // Container(width: widget.width). Благодаря этому виджет сам
      // расширяется по мере набора текста, как ты и просил.
      child: Text(
        finalDisplayText,
        style: textStyle,
      ),
    );
  }
}
