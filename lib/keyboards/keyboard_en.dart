import 'package:flutter/material.dart';
import 'package:key_peer/keyboards/key_renderer.dart';
import 'package:key_peer/utils/key_event_controller.dart';
import 'package:key_peer/utils/keyboard_config/en.dart';

class KeyboardEn extends StatelessWidget {
  const KeyboardEn({
    Key? key,
    required this.keyEventController,
  }) : super(key: key);

  static final KeyboardConfigEn _keyboardConfig = KeyboardConfigEn();
  final KeyEventController keyEventController;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: _keyboardConfig.keys.map((row) =>
        Padding(
          padding: EdgeInsets.symmetric(vertical: _keyboardConfig.keySpacing/1.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) =>
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _keyboardConfig.keySpacing),
                child: KeyRenderer(
                  keyInfo: key,
                  eventController: keyEventController,
                ),
              )
            ).toList(),
          ),
        )
      ).toList(),
    );
  }
}
