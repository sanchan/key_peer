

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/cubits/scoreboard_cubit.dart';
import 'package:key_peer/utils/colors.dart';
import 'package:macos_ui/macos_ui.dart';

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

class ScoreboardItem extends StatelessWidget {
  const ScoreboardItem({
    Key? key,
    required this.icon,
    required this.value,
    required this.caption,
  }) : super(key: key);

  final String caption;
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: lighten(MacosColors.alternatingContentBackgroundColor, 0.2),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                blurRadius: 1.0,
                color: darken(MacosColors.alternatingContentBackgroundColor),
                offset: const Offset(0, 1.0),
              ),
            ],
          ),
          child: MacosIcon(
            icon,
            size: 32,
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(width: 8.0),
        Column(
          children: [
            Text(value, style: MacosTheme.of(context).typography.title1.copyWith(fontSize: 32)),
            Text(caption, style: MacosTheme.of(context).typography.body
              .copyWith(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
