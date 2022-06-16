

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:key_peer/utils/keyboard_config/keyboard_key_info.dart';

typedef K = LogicalKeyboardKey;

class KeyboardConfig {
  KeyboardConfig({
    required List<List<LogicalKeyboardKey>> keys,
    required List<List<LogicalKeyboardKey>> altKeys,
    required Map<LogicalKeyboardKey, double> customWidths,
    this.baseKeySize = 60.0,
  }) {
    keysInfo = [];
    for (var i = 0; i < keys.length; i++) {
      keysInfo.add([]);
      final row = keys[i];
      for (var j = 0; j < row.length; j++) {
        keysInfo[i].add(
          KeyboardKeyInfo(
            key: keys[i][j],
            altKey: altKeys[i][j],
            size: _sizeOf(keys[i][j], customWidths),
          ),
        );
      }
    }
  }

  factory KeyboardConfig.forLang() {
    return KeyboardConfig(
      keys: [
        [K.backquote, K.digit1, K.digit2, K.digit3, K.digit4, K.digit5, K.digit6, K.digit7, K.digit8, K.digit9, K.digit0, K.minus, K.equal, K.backspace],
        [K.tab, K.keyQ, K.keyW, K.keyE, K.keyR, K.keyT, K.keyY, K.keyU, K.keyI, K.keyO, K.keyP, K.bracketLeft, K.bracketRight, K.backslash],
        [K.capsLock, K.keyA, K.keyS, K.keyD, K.keyF, K.keyG, K.keyH, K.keyJ, K.keyK, K.keyL, K.semicolon, K.quoteSingle, K.enter],
        [K.shiftLeft, K.keyZ, K.keyX, K.keyC, K.keyV, K.keyB, K.keyN, K.keyM, K.comma, K.period, K.slash, K.shiftRight],
        [K.fn, K.controlLeft, K.altLeft, K.metaLeft, K.space, K.metaRight, K.altRight, K.escape],
      ],

      altKeys: [
        [K.tilde, K.exclamation, K.at, K.numberSign, K.dollar, K.percent, K.caret, K.ampersand, K.asterisk, K.parenthesisLeft, K.parenthesisRight, K.underscore, K.add, K.backspace],
        [K.tab, K.keyQ, K.keyW, K.keyE, K.keyR, K.keyT, K.keyY, K.keyU, K.keyI, K.keyO, K.keyP, K.braceLeft, K.braceRight, K.bar],
        [K.capsLock, K.keyA, K.keyS, K.keyD, K.keyF, K.keyG, K.keyH, K.keyJ, K.keyK, K.keyL, K.colon, K.quote, K.enter],
        [K.shiftLeft, K.keyZ, K.keyX, K.keyC, K.keyV, K.keyB, K.keyN, K.keyM, K.less, K.greater, K.slash, K.shiftRight],
        [K.fn, K.controlLeft, K.altLeft, K.metaLeft, K.space, K.metaRight, K.altRight, K.escape],
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
      },
    );
  }

  final double baseKeySize;
  late final List<List<KeyboardKeyInfo>> keysInfo;

  double get keySpacing => baseKeySize  / 10;

  Size _sizeOf(LogicalKeyboardKey key, Map<LogicalKeyboardKey, double> customWidths) {
    return Size(
      (customWidths[key] ?? 1) * baseKeySize,
      baseKeySize,
    );
  }
}
