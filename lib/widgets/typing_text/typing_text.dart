import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/blocs.dart';
import 'package:key_peer/bloc/game_bloc/game_bloc.dart';
import 'package:key_peer/utils/enums.dart';

class TypingText extends StatefulWidget {
  const TypingText({
    Key? key,
  }) : super(key: key);

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  int get _cursorIndex => Blocs.get<GameBloc>().state.cursorPosition;
  bool get _isLessonCompleted => Blocs.get<GameBloc>().state.gameStatus == GameStatus.completed;
  List<GameKeyStatus> get _statuses => Blocs.get<GameBloc>().statuses;
  String get _targetText => Blocs.get<GameBloc>().currentText;

  Color _textColor(int index) {
    switch (_statuses[index]) {
      case GameKeyStatus.none:
        return _cursorIndex == index
          ? Colors.black
          : Colors.grey;
      case GameKeyStatus.correct:
        return _cursorIndex == index && !_isLessonCompleted
          ? Colors.black
          : Colors.white;
      case GameKeyStatus.error:
        return Colors.red;
      case GameKeyStatus.ammended:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final richCharacters = <TextSpan>[];

        for (var i = 0; i < _targetText.length; i++) {
          final char = _targetText[i];
          richCharacters.add(
            TextSpan(
              text: char == ' ' && [GameKeyStatus.error, GameKeyStatus.ammended].contains(_statuses[i])
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
