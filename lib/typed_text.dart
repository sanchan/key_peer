import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/blocs/cubits/keyboard_cubic.dart';
import 'package:key_peer/services/system_service.dart';

class TypedText extends StatefulWidget {
  const TypedText({
    Key? key,
  }) : super(key: key);

  @override
  State<TypedText> createState() => _TypedTextState();
}

class _TypedTextState extends State<TypedText> {
  @override
  void dispose() {
    super.dispose();

    SystemService.targetText.removeListener(_handleTargetTextChange);
  }

  @override
  void initState() {
    super.initState();

    _statuses = _targetText.characters.map((char) => TypedKeyStatus.none).toList();

    SystemService.targetText.addListener(_handleTargetTextChange);
  }

  bool get _isLessonCompleted => SystemService.isLessonCompleted;
  List<TypedKeyStatus> get _statuses => SystemService.statuses.value;
  String get _targetText => SystemService.targetText.value;

  int _cursorIndex = 0;

  void _handleEventChange(BuildContext _, RawKeyEvent? event) {
    if(_isLessonCompleted) {
      return;
    }

    if(event is RawKeyUpEvent || event?.character == null) {
      return;
    }

    if(
      event?.logicalKey == LogicalKeyboardKey.backspace ||
      event?.logicalKey == LogicalKeyboardKey.arrowLeft
    ) {
      return _moveCursorLeft();
    } else if(event?.logicalKey == LogicalKeyboardKey.arrowRight) {
      return _moveCursorRight();
    }

    if(event != null) {
      var keyLabel = event.logicalKey.keyLabel;
      final modifiers = event.data.modifiersPressed;
      keyLabel =
        modifiers.containsKey(ModifierKey.shiftModifier) ||
        modifiers.containsKey(ModifierKey.capsLockModifier)
          ? keyLabel.toUpperCase()
          : keyLabel.toLowerCase();

      if(keyLabel == _targetText[_cursorIndex]) {
        if(
          _statuses[_cursorIndex] == TypedKeyStatus.none ||
          _statuses[_cursorIndex] == TypedKeyStatus.correct
        ) {
          _updateStatus(_cursorIndex, TypedKeyStatus.correct);
        } else {
          _updateStatus(_cursorIndex, TypedKeyStatus.corrected);
        }
      } else {
        _updateStatus(_cursorIndex, TypedKeyStatus.error);
      }

      _moveCursorRight();
    }
  }

  void _handleTargetTextChange() {
    setState(() {
      _cursorIndex = 0;
    });
  }

  void _moveCursorLeft() {
    setState(() {
      if(_cursorIndex > 0) {
        _cursorIndex--;
      }
    });
  }

  void _moveCursorRight() {
    if(_cursorIndex < _targetText.length - 1) {
      setState(() {
        _cursorIndex++;
      });
    }
  }

  set _statuses(List<TypedKeyStatus> newStatuses) => SystemService.statuses.value = newStatuses;

  void _updateStatus(int index, TypedKeyStatus status) => SystemService.updateStatus(index, status);

  Color _textColor(int index) {
    switch (_statuses[index]) {
      case TypedKeyStatus.none:
        return _cursorIndex == index
          ? Colors.black
          : Colors.grey;
      case TypedKeyStatus.correct:
        return _cursorIndex == index && !_isLessonCompleted
          ? Colors.black
          : Colors.white;
      case TypedKeyStatus.error:
        return Colors.red;
      case TypedKeyStatus.corrected:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KeyboardCubic, RawKeyEvent?>(
      listener: _handleEventChange,
      builder: (_, __) {
        final richCharacters = <TextSpan>[];

        for (var i = 0; i < _targetText.length; i++) {
          final char = _targetText[i];
            richCharacters.add(
              TextSpan(
                text: char == ' ' && (_statuses[i] == TypedKeyStatus.error || _statuses[i] == TypedKeyStatus.corrected)
                  ? '•'
                  : char,
                style: TextStyle(
                  backgroundColor: _cursorIndex == i && !_isLessonCompleted
                    ? Colors.grey[300]
                    : null,
                  color: _textColor(i),
                ),
              ),
            );
        }

        return SizedBox(
          width: 1040.0,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: richCharacters,
              style: const TextStyle(fontFamily: 'Courier New', fontSize: 24),
            ),
          ),
        );
      },
    );
  }
}

enum TypedKeyStatus {
  none,
  correct,
  error,
  corrected,
}
