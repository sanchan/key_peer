import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_config.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_key_info.dart';

class KeyboardConfigEn extends KeyboardConfig {
  const KeyboardConfigEn() : super();

  static const _keyBaseSize = 60.0;
  static const _keySpacing = _keyBaseSize  / 10;

  final Map<String, double> _customWidth = const {
    '[BACKSPACE]': 1.5,
    '[TAB]': 1.5,
    '[CAPS]': 1.84,
    '[RETURN]': 1.84,
    '[LEFT_SHIFT]': 2.4,
    '[RIGHT_SHIFT]': 2.4,

    '[LEFT_CMD]': 1.25,
    '[SPACE]': 6.15,
    '[RIGHT_CMD]': 1.25,
    '[___]': 3,
  };

  final Map<String, LogicalKeyboardKey> _regularToLogical = const {
    '[BACKSPACE]': LogicalKeyboardKey.backspace,
    '[TAB]': LogicalKeyboardKey.tab,
    '[CAPS]': LogicalKeyboardKey.capsLock,
    '[RETURN]': LogicalKeyboardKey.enter,
    '[LEFT_SHIFT]': LogicalKeyboardKey.shiftLeft,
    '[RIGHT_SHIFT]': LogicalKeyboardKey.shiftRight,

    '[LEFT_CMD]': LogicalKeyboardKey.metaLeft,
    '[SPACE]': LogicalKeyboardKey.space,
    '[RIGHT_CMD]': LogicalKeyboardKey.metaRight,
  };

  static const List<List<String>> _regulars = [
    ['`', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '[BACKSPACE]'],
    ['[TAB]', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\\'],
    ['[CAPS]', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '[RETURN]'],
    ['[LEFT_SHIFT]', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', '[RIGHT_SHIFT]'],
    ['[FN]', '[LEFT_CONTROL]', '[LEFT_OPTION]', '[LEFT_CMD]', '[SPACE]', '[RIGHT_CMD]', '[RIGHT_OPTION]', '[___]']
  ];


  static List<List<KeyboardKeyInfo>>? _keys;

  @override
  double get keySpacing => _keySpacing;

  @override
  LogicalKeyboardKey? logicalOf(String regular) {
    return _regularToLogical[regular];
  }

  @override
  List<List<String>> get regulars => _regulars;

  @override
  List<List<KeyboardKeyInfo>> get keys {
    _keys ??= _regulars.map((row) =>
      row.map((key) =>
        KeyboardKeyInfo(
          regular: key,
          logicalKey: logicalOf(key),
          size: sizeOf(key),
        )
      ).toList()
    ).toList();

    return _keys!;
  }

  @override
  Size sizeOf(String key) {
    return Size(
      (_customWidth[key] ?? 1) * _keyBaseSize,
      _keyBaseSize
    );
  }
}