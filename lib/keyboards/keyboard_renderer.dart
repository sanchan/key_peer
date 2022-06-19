import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/bloc/cubits/keyboard_settings_cubit.dart';
import 'package:key_peer/keyboards/key_renderer.dart';

class KeyboardRenderer extends StatelessWidget {
  const KeyboardRenderer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeyboardSettingsCubit, KeyboardConfig>(
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
