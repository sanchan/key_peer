import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardSettingsCubit extends Cubit<KeyboardConfig> {
  KeyboardSettingsCubit() : super(KeyboardConfig.forLang());

  void setConfig(KeyboardConfig config) => emit(config);
}

// ignore: avoid_private_typedef_functions
typedef _K = LogicalKeyboardKey;

@immutable
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

  // ignore: avoid_unused_constructor_parameters
  factory KeyboardConfig.forLang({ String lang = 'en' }) {
    return KeyboardConfig(
      keys: const [
        [_K.backquote, _K.digit1, _K.digit2, _K.digit3, _K.digit4, _K.digit5, _K.digit6, _K.digit7, _K.digit8, _K.digit9, _K.digit0, _K.minus, _K.equal, _K.backspace],
        [_K.tab, _K.keyQ, _K.keyW, _K.keyE, _K.keyR, _K.keyT, _K.keyY, _K.keyU, _K.keyI, _K.keyO, _K.keyP, _K.bracketLeft, _K.bracketRight, _K.backslash],
        [_K.capsLock, _K.keyA, _K.keyS, _K.keyD, _K.keyF, _K.keyG, _K.keyH, _K.keyJ, _K.keyK, _K.keyL, _K.semicolon, _K.quoteSingle, _K.enter],
        [_K.shiftLeft, _K.keyZ, _K.keyX, _K.keyC, _K.keyV, _K.keyB, _K.keyN, _K.keyM, _K.comma, _K.period, _K.slash, _K.shiftRight],
        [_K.fn, _K.controlLeft, _K.altLeft, _K.metaLeft, _K.space, _K.metaRight, _K.altRight, _K.escape],
      ],

      altKeys: const [
        [_K.tilde, _K.exclamation, _K.at, _K.numberSign, _K.dollar, _K.percent, _K.caret, _K.ampersand, _K.asterisk, _K.parenthesisLeft, _K.parenthesisRight, _K.underscore, _K.add, _K.backspace],
        [_K.tab, _K.keyQ, _K.keyW, _K.keyE, _K.keyR, _K.keyT, _K.keyY, _K.keyU, _K.keyI, _K.keyO, _K.keyP, _K.braceLeft, _K.braceRight, _K.bar],
        [_K.capsLock, _K.keyA, _K.keyS, _K.keyD, _K.keyF, _K.keyG, _K.keyH, _K.keyJ, _K.keyK, _K.keyL, _K.colon, _K.quote, _K.enter],
        [_K.shiftLeft, _K.keyZ, _K.keyX, _K.keyC, _K.keyV, _K.keyB, _K.keyN, _K.keyM, _K.less, _K.greater, _K.slash, _K.shiftRight],
        [_K.fn, _K.controlLeft, _K.altLeft, _K.metaLeft, _K.space, _K.metaRight, _K.altRight, _K.escape],
      ],

      customWidths: {
        _K.backspace: 1.5,
        _K.tab: 1.5,
        _K.capsLock: 1.84,
        _K.enter: 1.84,
        _K.shiftLeft: 2.4,
        _K.shiftRight: 2.4,

        _K.metaLeft: 1.25,
        _K.space: 6.15,
        _K.metaRight: 1.25,
        _K.escape: 3,
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

@immutable
class KeyboardKeyInfo {
  const KeyboardKeyInfo({
    required this.key,
    required this.altKey,
    required this.size,
  });

  final LogicalKeyboardKey altKey;
  final LogicalKeyboardKey key;
  final Size size;
}
