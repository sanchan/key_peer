import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_peer/services/system.dart';
import 'package:key_peer/utils/key_event_controller.dart';

enum TypedKeyStatus {
  none,
  correct,
  error,
  corrected,
}

class TypedText extends StatefulWidget {
  const TypedText({
    Key? key,
  }) : super(key: key);

  @override
  State<TypedText> createState() => _TypedTextState();
}

class _TypedTextState extends State<TypedText> {
  int _cursorIndex = 0;

  @override
  void dispose() {
    super.dispose();

    _keyEventController.removeListener(_handleEventChange);
    SystemService.targetText.removeListener(_handleTargetTextChange);
  }

  @override
  void initState() {
    super.initState();

    _statuses = _targetText.characters.map((char) => TypedKeyStatus.none).toList();

    _keyEventController.addListener(_handleEventChange);
    SystemService.targetText.addListener(_handleTargetTextChange);
  }

  bool get _isLessonCompleted => SystemService.isLessonCompleted;
  KeyEventController get _keyEventController => SystemService.keyEventController;
  List<TypedKeyStatus> get _statuses => SystemService.statuses.value;
  String get _targetText => SystemService.targetText.value;

  void _handleEventChange() {
    if(_isLessonCompleted) {
      return;
    }

    final event = _keyEventController.event;

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

    if(event?.logicalKey.keyLabel.toLowerCase() == _targetText[_cursorIndex]) {
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
    setState(() {
      if(_cursorIndex < _targetText.length - 1) {
        _cursorIndex++;
      }
    });
  }

  set _statuses(List<TypedKeyStatus> newStatuses) => SystemService.statuses.value = newStatuses;

  _updateStatus(int index, TypedKeyStatus status) => SystemService.updateStatus(index, status);

  @override
  Widget build(BuildContext context) {
    List<TextSpan> richCharacters = [];

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
              color: _statuses[i] == TypedKeyStatus.none
                ? _cursorIndex == i
                  ? Colors.black
                  : Colors.grey
                : _statuses[i] == TypedKeyStatus.correct
                  ? _cursorIndex == i && !_isLessonCompleted
                    ? Colors.black
                    : Colors.white
                  : _statuses[i] == TypedKeyStatus.error
                    ? Colors.red
                    : _statuses[i] == TypedKeyStatus.corrected
                      ? Colors.blue
                      : Colors.blue
            )
          )
        );
    }

    return SizedBox(
      width: 1040.0,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: richCharacters,
          style: const TextStyle(fontFamily: 'Courier New', fontSize: 24)
        )
      ),
    );
  }
}