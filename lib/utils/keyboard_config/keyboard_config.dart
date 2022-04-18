

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_key_info.dart';

abstract class KeyboardConfig {
  KeyboardConfig({
    required this.keyLabels,
    required this.logicals,
    required this.customWidths,
    this.keyBaseSize = 60.0
  });

  final Map<String, double> customWidths;
  final double keyBaseSize;
  final Map<String, LogicalKeyboardKey> logicals;
  final List<List<String>> keyLabels;

  List<List<KeyboardKeyInfo>>? _keys;

  double get keySpacing => keyBaseSize  / 10;
  List<List<KeyboardKeyInfo>> get keys {
    _keys ??= keyLabels.map((row) =>
      row.map((regular) =>
        KeyboardKeyInfo(
          keyLabel: regular,
          logicalKey: logicals[regular],
          size: sizeOf(regular),
        )
      ).toList()
    ).toList();

    return _keys!;
  }

  LogicalKeyboardKey? logicalOf(String regular) {
    return logicals[regular];
  }

  Size sizeOf(String keyLabel) {
    return Size(
      (customWidths[keyLabel] ?? 1) * keyBaseSize,
      keyBaseSize
    );
  }
}