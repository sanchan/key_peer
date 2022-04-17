import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardConfigEn {
  const KeyboardConfigEn();

  static const _keyBaseSize = 50.0;
  static const _keySpacing = _keyBaseSize  / 10;

  final List<List<String>> _regulars = const [
    ['`', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '[BACKSPACE]'],
    ['[TAB]', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\\'],
    ['[CAPS]', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '[RETURN]'],
    ['[LEFT_SHIFT]', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', '[RIGHT_SHIFT]'],
    ['[FN]', '[LEFT_CONTROL]', '[LEFT_OPTION]', '[LEFT_CMD]', '[SPACE]', '[RIGHT_CMD]', '[RIGHT_OPTION]', '[___]']
  ];

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

  double get keySpacing => _keySpacing;

  List<List<String>> get regulars => _regulars;

  LogicalKeyboardKey? logicalOf(String regular) {
    return _regularToLogical[regular];
  }

  Size sizeOf(String key) {
    return Size(
      (_customWidth[key] ?? 1) * _keyBaseSize,
      _keyBaseSize
    );
  }
}