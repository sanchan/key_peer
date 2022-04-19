import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_peer/services/system.dart';

enum TypedKeyStatus {
  NONE,
  CORRECT,
  ERROR,
  CORRECTED,
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
  List<TypedKeyStatus> _statuses = [];

  String get targetText => SystemService.targetText.value;

  @override
  void dispose() {
    super.dispose();

    SystemService.keyEventController.removeListener(handleEventChange);
  }

  @override
  void initState() {
    super.initState();

    _statuses = targetText.characters.map((char) => TypedKeyStatus.NONE).toList();

    SystemService.keyEventController.addListener(handleEventChange);
  }

  void handleEventChange() {
    final event = SystemService.keyEventController.event;

    if(event is RawKeyUpEvent || event?.character == null) {
      return;
    }

    if(event?.logicalKey == LogicalKeyboardKey.backspace) {
      setState(() {
        if(_cursorIndex > 0) {
          _cursorIndex--;
        }
      });
      return;
    }

    if(event?.logicalKey.keyLabel.toLowerCase() == targetText[_cursorIndex]) {
      if(_statuses[_cursorIndex] == TypedKeyStatus.NONE || _statuses[_cursorIndex] == TypedKeyStatus.CORRECT) {
        _statuses[_cursorIndex] = TypedKeyStatus.CORRECT;
      } else {
        _statuses[_cursorIndex] = TypedKeyStatus.CORRECTED;
      }
    } else {
      _statuses[_cursorIndex] = TypedKeyStatus.ERROR;
    }

    setState(() {
      if(_cursorIndex < targetText.length - 1) {
        _cursorIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> richCharacters = [];

    for (var i = 0; i < targetText.length; i++) {
      final char = targetText[i];
        richCharacters.add(
          TextSpan(
            text: char == ' ' && (_statuses[i] == TypedKeyStatus.ERROR || _statuses[i] == TypedKeyStatus.CORRECTED)
              ? '•'
              : char,
            style: TextStyle(
              backgroundColor: _cursorIndex == i
                ? Colors.grey[300]
                : null,
              color: _statuses[i] == TypedKeyStatus.NONE
                ? _cursorIndex == i
                  ? Colors.black
                  : Colors.grey
                : _statuses[i] == TypedKeyStatus.CORRECT
                  ? _cursorIndex == i
                    ? Colors.black
                    : Colors.white
                  : _statuses[i] == TypedKeyStatus.ERROR
                    ? Colors.red
                    : _statuses[i] == TypedKeyStatus.CORRECTED
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