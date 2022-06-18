import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/blocs.dart';
import 'package:key_peer/bloc/game_bloc/game_bloc.dart';
import 'package:key_peer/utils/enums.dart';

class TypedText extends StatefulWidget {
  const TypedText({
    Key? key,
  }) : super(key: key);

  @override
  State<TypedText> createState() => _TypedTextState();
}

class _TypedTextState extends State<TypedText> {
  int get _cursorIndex => Blocs.get<GameBloc>().state.cursorPosition;
  bool get _isLessonCompleted => Blocs.get<GameBloc>().state.gameStatus == GameStatus.completed;
  List<TypedKeyStatus> get _statuses => Blocs.get<GameBloc>().statuses;
  String get _targetText => Blocs.get<GameBloc>().targetText;

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
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
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
