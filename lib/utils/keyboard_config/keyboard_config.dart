

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_key_info.dart';

abstract class KeyboardConfig {
  const KeyboardConfig();
  double get keySpacing;

  List<List<KeyboardKeyInfo>> get keys;
  List<List<String>> get regulars;

  LogicalKeyboardKey? logicalOf(String regular);

  Size sizeOf(String key);
}