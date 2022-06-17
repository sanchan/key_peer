import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/keyboards/key_renderer.dart';
import 'package:key_peer/state/blocs/game_bloc/game_bloc.dart';
import 'package:key_peer/state/blocs/game_bloc/game_state.dart';
import 'package:key_peer/state/models/keyboard_config.dart';

class KeyboardEn extends StatelessWidget {
  const KeyboardEn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<GameBloc, GameState, KeyboardConfig>(
      selector: (state) => state.settings.keyboardConfig,
      builder: (_, KeyboardConfig keyboardConfig) =>
        Column(
          children: keyboardConfig.keysInfo.map((row) =>
            Padding(
              padding: EdgeInsets.symmetric(vertical: keyboardConfig.keySpacing/1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((key) =>
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: keyboardConfig.keySpacing),
                    child: KeyRenderer(
                      keyInfo: key,
                    ),
                  ),
                ).toList(),
              ),
            ),
          ).toList(),
        ),
    );
  }
}
