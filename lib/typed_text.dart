import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/blocs.dart';
import 'package:key_peer/bloc/cubits/game_status_cubit.dart';
import 'package:key_peer/bloc/cubits/keyboard_cubit.dart';
import 'package:key_peer/bloc/cubits/text_cubit.dart';
import 'package:key_peer/utils/enums.dart';

class TypedText extends StatefulWidget {
  const TypedText({
    Key? key,
  }) : super(key: key);

  @override
  State<TypedText> createState() => _TypedTextState();
}

class _TypedTextState extends State<TypedText> {

  bool get _isLessonCompleted => Blocs.get<GameStatusCubit>().state == GameStatus.completed;
  List<TypedKeyStatus> get _statuses => Blocs.get<TextCubit>().statuses;
  String get _targetText => Blocs.get<TextCubit>().targetText;

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

  void _handleTargetTextChange(BuildContext _, TextCubitState __) {
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

  void _updateStatus(int index, TypedKeyStatus status) => Blocs.get<TextCubit>().updateStatus(index, status);

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
    return BlocListener<TextCubit, TextCubitState>(
      listener: _handleTargetTextChange,
      child: BlocConsumer<KeyboardCubit, RawKeyEvent?>(
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
      ),
    );
  }
}
