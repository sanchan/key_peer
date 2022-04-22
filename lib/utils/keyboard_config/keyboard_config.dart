

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_key_info.dart';

typedef K = LogicalKeyboardKey;

class KeyboardConfig {
  KeyboardConfig({
    required this.keys,
    required this.altKeys,
    required this.customWidths,
    this.keyBaseSize = 60.0
  });

  factory KeyboardConfig.forLang({String lang = 'en'}) {

    return KeyboardConfig(
      keys: [
        [K.backquote, K.digit1, K.digit2, K.digit3, K.digit4, K.digit5, K.digit6, K.digit7, K.digit8, K.digit9, K.digit0, K.minus, K.equal, K.backspace],
        [K.tab, K.keyQ, K.keyW, K.keyE, K.keyR, K.keyT, K.keyY, K.keyU, K.keyI, K.keyO, K.keyP, K.bracketLeft, K.bracketRight, K.backslash],
        [K.capsLock, K.keyA, K.keyS, K.keyD, K.keyF, K.keyG, K.keyH, K.keyJ, K.keyK, K.keyL, K.semicolon, K.quoteSingle, K.enter],
        [K.shiftLeft, K.keyZ, K.keyX, K.keyC, K.keyV, K.keyB, K.keyN, K.keyM, K.comma, K.period, K.slash, K.shiftRight],
        [K.fn, K.controlLeft, K.altLeft, K.metaLeft, K.space, K.metaRight, K.altRight, K.escape]
      ],

      altKeys: [
        [K.tilde, K.exclamation, K.at, K.numberSign, K.dollar, K.percent, K.caret, K.ampersand, K.asterisk, K.parenthesisLeft, K.parenthesisRight, K.underscore, K.add, K.backspace],
        [K.tab, K.keyQ, K.keyW, K.keyE, K.keyR, K.keyT, K.keyY, K.keyU, K.keyI, K.keyO, K.keyP, K.braceLeft, K.braceRight, K.bar],
        [K.capsLock, K.keyA, K.keyS, K.keyD, K.keyF, K.keyG, K.keyH, K.keyJ, K.keyK, K.keyL, K.colon, K.quote, K.enter],
        [K.shiftLeft, K.keyZ, K.keyX, K.keyC, K.keyV, K.keyB, K.keyN, K.keyM, K.less, K.greater, K.slash, K.shiftRight],
        [K.fn, K.controlLeft, K.altLeft, K.metaLeft, K.space, K.metaRight, K.altRight, K.escape]
      ],

      customWidths: {
        K.backspace: 1.5,
        K.tab: 1.5,
        K.capsLock: 1.84,
        K.enter: 1.84,
        K.shiftLeft: 2.4,
        K.shiftRight: 2.4,

        K.metaLeft: 1.25,
        K.space: 6.15,
        K.metaRight: 1.25,
        K.escape: 3,
      }
    );
  }

  final List<List<LogicalKeyboardKey>> keys;
  final List<List<LogicalKeyboardKey>> altKeys;
  final Map<LogicalKeyboardKey, double> customWidths;

  final double keyBaseSize;

  List<List<KeyboardKeyInfo>>? _keys;

  double get keySpacing => keyBaseSize  / 10;
  // List<List<KeyboardKeyInfo>> keys;
  // List<List<KeyboardKeyInfo>> altKeys;


  Size sizeOf(String keyLabel) {
    return Size(
      (customWidths[keyLabel] ?? 1) * keyBaseSize,
      keyBaseSize
    );
  }
}