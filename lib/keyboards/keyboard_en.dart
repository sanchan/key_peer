import 'package:flutter/material.dart';
import 'package:key_peer/keyboards/key_renderer.dart';
import 'package:key_peer/services/system.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_config.dart';

class KeyboardEn extends StatelessWidget {
  const KeyboardEn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SystemService.keyboardConfig,
      builder: (_, KeyboardConfig keyboardConfig, __) =>
        Column(
          children: keyboardConfig.keys.map((row) =>
            Padding(
              padding: EdgeInsets.symmetric(vertical: keyboardConfig.keySpacing/1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((key) =>
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: keyboardConfig.keySpacing),
                    child: KeyRenderer(
                      keyInfo: key,
                      eventController: SystemService.keyEventController,
                    ),
                  )
                ).toList(),
              ),
            )
          ).toList(),
        ),
    );
  }
}
