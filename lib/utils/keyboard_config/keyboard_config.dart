

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_key_info.dart';

abstract class KeyboardConfig {
  KeyboardConfig({
    required this.keyLabels,
    required this.customWidths,
    this.keyBaseSize = 60.0
  });

  static const Map<String, LogicalKeyboardKey> logicals = {
    '`': LogicalKeyboardKey.backquote,
    '1': LogicalKeyboardKey.digit1,
    '2': LogicalKeyboardKey.digit2,
    '3': LogicalKeyboardKey.digit3,
    '4': LogicalKeyboardKey.digit4,
    '5': LogicalKeyboardKey.digit5,
    '6': LogicalKeyboardKey.digit6,
    '7': LogicalKeyboardKey.digit7,
    '8': LogicalKeyboardKey.digit8,
    '9': LogicalKeyboardKey.digit9,
    '0': LogicalKeyboardKey.digit0,
    '-': LogicalKeyboardKey.minus,
    '=': LogicalKeyboardKey.equal,
    'Backspace': LogicalKeyboardKey.backspace,

    'Tab': LogicalKeyboardKey.tab,
    'q': LogicalKeyboardKey.keyQ,
    'w': LogicalKeyboardKey.keyW,
    'e': LogicalKeyboardKey.keyE,
    'r': LogicalKeyboardKey.keyR,
    't': LogicalKeyboardKey.keyT,
    'y': LogicalKeyboardKey.keyY,
    'u': LogicalKeyboardKey.keyU,
    'i': LogicalKeyboardKey.keyI,
    'o': LogicalKeyboardKey.keyO,
    'p': LogicalKeyboardKey.keyP,
    '[': LogicalKeyboardKey.braceLeft,
    ']': LogicalKeyboardKey.bracketRight,
    '\\': LogicalKeyboardKey.backslash,

    'Caps Lock': LogicalKeyboardKey.capsLock,
    'a': LogicalKeyboardKey.keyA,
    's': LogicalKeyboardKey.keyS,
    'd': LogicalKeyboardKey.keyD,
    'f': LogicalKeyboardKey.keyF,
    'g': LogicalKeyboardKey.keyG,
    'h': LogicalKeyboardKey.keyH,
    'j': LogicalKeyboardKey.keyJ,
    'k': LogicalKeyboardKey.keyK,
    'l': LogicalKeyboardKey.keyL,
    ';': LogicalKeyboardKey.semicolon,
    '\'': LogicalKeyboardKey.quoteSingle,
    'Enter': LogicalKeyboardKey.enter,

    'Shift Left': LogicalKeyboardKey.shiftLeft,
    'z': LogicalKeyboardKey.keyZ,
    'x': LogicalKeyboardKey.keyX,
    'c': LogicalKeyboardKey.keyC,
    'v': LogicalKeyboardKey.keyV,
    'b': LogicalKeyboardKey.keyB,
    'n': LogicalKeyboardKey.keyN,
    'm': LogicalKeyboardKey.keyM,
    ',': LogicalKeyboardKey.comma,
    '.': LogicalKeyboardKey.period,
    '/': LogicalKeyboardKey.slash,
    'Shift Right': LogicalKeyboardKey.shiftRight,

    'Fn': LogicalKeyboardKey.fn,
    'Control Left': LogicalKeyboardKey.controlLeft,
    'Alt Left': LogicalKeyboardKey.altLeft,
    'Meta Left': LogicalKeyboardKey.metaLeft,
    ' ': LogicalKeyboardKey.space,
    'Meta Right': LogicalKeyboardKey.metaRight,
    'Alt Right': LogicalKeyboardKey.altRight,

    'Arrow Left': LogicalKeyboardKey.arrowLeft,
    'Arrow Down': LogicalKeyboardKey.arrowDown,
    'Arrow Up': LogicalKeyboardKey.arrowUp,
    'Arrow Right': LogicalKeyboardKey.arrowRight,
  };

  final Map<String, double> customWidths;
  final double keyBaseSize;
  final List<List<String>> keyLabels;

  List<List<KeyboardKeyInfo>>? _keys;

  double get keySpacing => keyBaseSize  / 10;
  List<List<KeyboardKeyInfo>> get keys {
    _keys ??= keyLabels.map((row) =>
      row.map((character) =>
        KeyboardKeyInfo(
          logicalKey: logicals[character] ?? LogicalKeyboardKey.escape,
          size: sizeOf(character),
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