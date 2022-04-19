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

    keyEventController.removeListener(handleEventChange);
  }

  @override
  void initState() {
    super.initState();

    statuses = targetText.characters.map((char) => TypedKeyStatus.none).toList();

    keyEventController.addListener(handleEventChange);
  }

  bool get isLessonCompleted => SystemService.isLessonCompleted;
  List<TypedKeyStatus> get statuses => SystemService.statuses.value;
  String get targetText => SystemService.targetText.value;
  KeyEventController get keyEventController => SystemService.keyEventController;

  void handleEventChange() {
    if(isLessonCompleted) {
      return;
    }

    final event = keyEventController.event;

    if(event is RawKeyUpEvent || event?.character == null) {
      return;
    }

    if(
      event?.logicalKey == LogicalKeyboardKey.backspace ||
      event?.logicalKey == LogicalKeyboardKey.arrowLeft
    ) {
      return moveCursorLeft();
    } else if(event?.logicalKey == LogicalKeyboardKey.arrowRight) {
      return moveCursorRight();
    }

    if(event?.logicalKey.keyLabel.toLowerCase() == targetText[_cursorIndex]) {
      if(
        statuses[_cursorIndex] == TypedKeyStatus.none ||
        statuses[_cursorIndex] == TypedKeyStatus.correct
      ) {
        SystemService.updateStatus(_cursorIndex, TypedKeyStatus.correct);
      } else {
        SystemService.updateStatus(_cursorIndex, TypedKeyStatus.corrected);
      }
    } else {
      SystemService.updateStatus(_cursorIndex, TypedKeyStatus.error);
    }

    moveCursorRight();
  }

  void moveCursorLeft() {
    setState(() {
      if(_cursorIndex > 0) {
        _cursorIndex--;
      }
    });
  }

  void moveCursorRight() {
    setState(() {
      if(_cursorIndex < targetText.length - 1) {
        _cursorIndex++;
      }
    });
  }

  set statuses(List<TypedKeyStatus> newStatuses) => SystemService.statuses.value = newStatuses;

  @override
  Widget build(BuildContext context) {
    List<TextSpan> richCharacters = [];

    for (var i = 0; i < targetText.length; i++) {
      final char = targetText[i];
        richCharacters.add(
          TextSpan(
            text: char == ' ' && (statuses[i] == TypedKeyStatus.error || statuses[i] == TypedKeyStatus.corrected)
              ? '•'
              : char,
            style: TextStyle(
              backgroundColor: _cursorIndex == i && !isLessonCompleted
                ? Colors.grey[300]
                : null,
              color: statuses[i] == TypedKeyStatus.none
                ? _cursorIndex == i
                  ? Colors.black
                  : Colors.grey
                : statuses[i] == TypedKeyStatus.correct
                  ? _cursorIndex == i && !isLessonCompleted
                    ? Colors.black
                    : Colors.white
                  : statuses[i] == TypedKeyStatus.error
                    ? Colors.red
                    : statuses[i] == TypedKeyStatus.corrected
                      ? Colors.blue
                      : Colors.blue
            )
          )
        );
    }

    return RichText(
      text: TextSpan(
        children: richCharacters,
        style: const TextStyle(fontFamily: 'Courier New', fontSize: 24)
      )
    );
  }
}