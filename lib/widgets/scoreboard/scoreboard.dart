

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/cubits/scoreboard_cubit.dart';
import 'package:key_peer/widgets/scoreboard/scoreboard_item.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocSelector<ScoreboardCubit, ScoreboardState, int>(
            selector: (state) => state.typedCharacters,
            builder: (context, typedCharacters) => ScoreboardItem(
              icon: CupertinoIcons.speedometer,
              value: typedCharacters.toString(),
              caption: 'typed chars',
            ),
          ),
          BlocSelector<ScoreboardCubit, ScoreboardState, int>(
            selector: (state) => state.accuracy,
            builder: (context, accuracy) => ScoreboardItem(
              icon: CupertinoIcons.heart,
              value: '$accuracy%',
              caption: 'accuracy',
            ),
          ),
          BlocSelector<ScoreboardCubit, ScoreboardState, int>(
            selector: (state) => state.errors,
            builder: (context, errors) => ScoreboardItem(
              icon: CupertinoIcons.flag_fill,
              value: errors.toString(),
              caption: 'errors',
            ),
          ),
        ],
      ),
    );
  }
}
